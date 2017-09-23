<?php
/**
 * Remote version checker for a local package. Returns if the local version is equal, higher, lower than the remote version or is missing.
 * Callable from the web
 * 
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 * 
 * $_GET params:
 * @param string "package"
 * @param string "version"
 * @param string "callback"
 * 
 * @return string {message:string, data:[local:x.x.x.x, is:higher|lower|equal|missing]}
 */

include "../config.php";
include "../includes/bootstrap.inc";
header("Content-Type: application/json; charset=utf-8");

function throw_response(array $data)
{
    die(
        $_GET["callback"] . "(" .
        json_encode($data) .
        ")"
    );
}

/**
 * @param $local
 *
 * @return array[local:x.x.x.x, is:higher|lower|equal|missing]
 */
function return_comparison_against_local_version($local)
{
    $remote = $_GET["version"];
    
    if( $remote == $local ) return array("local" => $local, "is" => "equal");
    
    if( version_compare($remote, $local) == 1 ) return array("local" => $local, "is" => "lower");
    
    return array("local" => $local, "is" => "higher");
}

if( ! $account->_exists )      throw_response(array("message" => trim($language->errors->page_requires_login)));
if( ! $account->_is_admin )    throw_response(array("message" => trim($language->errors->access_denied)));
if( empty($_GET["callback"]) ) throw_response(array("message" => trim($language->errors->invalid_call)));
if( empty($_GET["package"]) )  throw_response(array("message" => trim($language->errors->invalid_call)));
if( empty($_GET["version"]) )  throw_response(array("message" => trim($language->errors->invalid_call)));
if( ! is_writable(ROOTPATH) )  throw_response(array("message" => trim($current_module->language->document_root_not_writable)));

$parts = explode("/", $_GET["package"]);
if( count($parts) != 2 ) throw_response(array("message" => trim($language->errors->invalid_call)));

$update_engine    = $settings->get("modules:updates_client.no_engine_automatic_updates")    != "true";
$update_modules   = $settings->get("modules:updates_client.no_modules_automatic_updates")   != "true";
$update_templates = $settings->get("modules:updates_client.no_templates_automatic_updates") != "true";

$group   = $parts[0];
$fileset = $parts[1];

#
# Core checks
#

if( $group == "core" )
{
    if( ! $update_engine ) throw_response(array("message" => trim($current_module->language->engine_updates_disabled)));
    
    if( $fileset == "bardcanvas_core") throw_response(array("message" => "OK", "data" => return_comparison_against_local_version($config->engine_version)));
    
    if( $fileset == "bardcanvas_lib" ) throw_response(
        array("message" => "OK", "data" => return_comparison_against_local_version(trim(file_get_contents(ROOTPATH . "/lib/version.dat"))))
    );
}

#
# Template checks
#

$templates = glob(ROOTPATH . "/templates/*", GLOB_ONLYDIR);
foreach($templates as $dir)
{
    if( ! file_exists("$dir/template_info.xml") ) continue;
    
    $tpl_name  = basename($dir);
    $xml       = simplexml_load_file("$dir/template_info.xml");
    $tpl_group = trim($xml->group);
    
    if( "$group/$fileset" == "$tpl_group/$tpl_name" )
    {
        if( ! $update_templates) throw_response(array("message" => trim($current_module->language->template_updates_disabled)));
        
        throw_response(array("message" => "OK", "data" => return_comparison_against_local_version(trim($xml->version))));
    }
}

#
# Module checks
#

foreach($modules as $module)
{
    if( "$group/$fileset" == "$module->group/$module->name" )
    {
        if( ! $update_modules) throw_response(array("message" => trim($current_module->language->module_updates_disabled)));
        
        throw_response(array("message" => "OK", "data" => return_comparison_against_local_version(trim($module->version))));
    }
}

#
# Nothing found
#

throw_response(array("message" => "OK", "data" => array("local" => 0, "is" => "missing")));
