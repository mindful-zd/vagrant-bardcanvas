<?php
/**
 * Version checker
 * Callable by the command line
 * 
 * Arguments:
 * -n to avoid downloading updates
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 */

use hng2_modules\updates_client\updates_toolbox;
use hng2_tools\cli_colortags;

if( ! empty($_SERVER["HTTP_HOST"]) ) die("This program cannot be called this way.");

chdir(__DIR__);
include "../config.php";
include "../includes/bootstrap.inc";

/** @var array $arg */
include "../includes/extract_cli_arguments.inc";

# Inits
$update = empty($arg["-n"]);
$current_module = $modules["updates_client"];

$toolbox  = new updates_toolbox();
$packages = array();

$update_engine    = $settings->get("modules:updates_client.no_engine_automatic_updates")    != "true";
$update_modules   = $settings->get("modules:updates_client.no_modules_automatic_updates")   != "true";
$update_templates = $settings->get("modules:updates_client.no_templates_automatic_updates") != "true";

if( ! $update_engine && ! $update_modules )
{
    $settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
    die();
}

if( $update_engine )
{
    $packages["core/bardcanvas_core"] = trim(file_get_contents(ROOTPATH . "/engine_version.dat"));
    if( ! file_exists(ROOTPATH . "/lib/version.dat") )
        $packages["core/bardcanvas_lib"] = "0.0.1";
    else
        $packages["core/bardcanvas_lib"]  = trim(file_get_contents(ROOTPATH . "/lib/version.dat"));
}

if( $update_templates )
{
    $templates = glob(ROOTPATH . "/templates/*", GLOB_ONLYDIR);
    foreach($templates as $dir)
    {
        if( ! file_exists("$dir/template_info.xml") ) continue;
        
        $name = basename($dir);
        $xml  = simplexml_load_file("$dir/template_info.xml");
        $group = trim($xml->group);
        
        $packages["{$group}/{$name}"] = trim($xml->version);
    }
}

if( $update_modules )
    foreach($modules as $module)
        $packages["{$module->group}/{$module->name}"] = $module->version;

if( empty($packages) )
{
    $settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
    die();
}

$new_versions = $toolbox->get_versions($packages);
if( is_object($new_versions) )  $new_versions = (array) $new_versions;
if( ! is_array($new_versions) ) $new_versions = array();
$count = count($new_versions);

if( $arg["--debug"] )
{
    cli_colortags::write("<green>[Debug] Installed packages:</green>\n");
    foreach($packages as $package => $version)
    {
        $remote_version = empty($new_versions[$package]) 
            ? "<green>N/A</green>" 
            : "<light_purple>{$new_versions[$package]}</light_purple>";
        
        cli_colortags::write(
            "<green> • $package<green>: </green>" .
            "<light_blue>$version</light_blue>" .
            "<green> => </green>" .
            "$remote_version\n"
        );
    }
}

if( $count == 0 )
{
    $settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
    die();
}

$now = date("Y-m-d H:i:s");
cli_colortags::write("<cyan>$now - Got updates for the next packages:</cyan>\n");
foreach($new_versions as $package_key => $version)
    cli_colortags::write("<cyan> • $package_key: </cyan><light_blue>{$packages[$package_key]}</light_blue><cyan> => </cyan><light_green>$version</light_green>\n");

if( ! $update )
{
    $settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
    die();
}

if( empty($new_versions) )
{
    $settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
    die();
}

cli_colortags::write("<cyan>Starting updates loop</cyan>\n\n");
$arg["--no-cache-purge"] = true;
$skip_inits = true;
foreach($new_versions as $package_key => $version)
{
    $arg["--name"] = $package_key;
    include __DIR__ . "/cli_update_package.php";
}
cli_colortags::write("<cyan>Updates checker finished.</cyan>\n");

if( $settings->get("modules:modules_manager.disable_cache") != "true" )
{
    cli_colortags::write("<green>Purging modules cache...</green>");
    $force_regeneration = true;
    $avoid_postinits    = true;
    include ROOTPATH . "/includes/modules_autoloader.inc";
    $settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
    cli_colortags::write("<green> done.</green>\n");
}
cli_colortags::write("\n");
