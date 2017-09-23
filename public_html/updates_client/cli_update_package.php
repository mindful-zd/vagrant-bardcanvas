<?php
/**
 * Single package downloader/applier
 * Can only be invoked from the CLI
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 */

use hng2_modules\updates_client\updates_toolbox;
use hng2_tools\cli_colortags;

if( ! $skip_inits )
{
    if( ! empty($_SERVER["HTTP_HOST"]) ) die("This program cannot be called this way.");
    
    chdir(__DIR__);
    include "../config.php";
    include "../includes/bootstrap.inc";
    
    /** @var array $arg */
    include "../includes/extract_cli_arguments.inc";
}

# Inits
$now            = date("Y-m-d H:i:s");
$current_module = $modules["updates_client"];
$package        = $arg["--name"];

#
# Package installation (on demand)
#

if( ! function_exists("install_package") )
{
    function install_package()
    {
        global $package, $settings, $errors, $messages, $current_module, $config, $language, $account, $database;
        
        $name = end(explode("/", $package));
        $path = ROOTPATH . "/$name";
        $xml  = "$path/module_info.xml";
        
        //cli_colortags::write("<light_blue>Name: $name</light_blue>\n");
        //cli_colortags::write("<light_blue>Path: $path</light_blue>\n");
        //cli_colortags::write("<light_blue>XML:  $xml</light_blue>\n");
        
        if( ! file_exists($xml) ) return;
        
        /** @noinspection PhpUnusedLocalVariableInspection */
        $module_install_action = "install";
        $do_module_name        = $name;
        if( $settings->get("modules:$do_module_name.installed") == "true" ) return;
        
        #
        # Install
        #
        
        if( file_exists(ROOTPATH . "/$do_module_name/module_install.inc") )
        {
            include ROOTPATH . "/$do_module_name/module_install.inc";
            if( count($errors) > 0 )
            {
                $errors[] = $current_module->language->task_messages->installed_ko;
                
                return;
            }
        }
        
        $settings->set("modules:$do_module_name.installed", "true");
        $messages[] = $current_module->language->task_messages->installed_ok;
        
        #
        # Enable
        #
        
        /** @noinspection PhpUnusedLocalVariableInspection */
        $module_install_action = "enable";
        if( file_exists(ROOTPATH . "/$do_module_name/module_install.inc") )
        {
            include ROOTPATH . "/$do_module_name/module_install.inc";
            if( count($errors) > 0 )
            {
                $errors[] = $current_module->language->task_messages->enabled_ko;
                
                return;
            }
        }
        
        $settings->set("modules:$do_module_name.enabled", "true");
        $messages[] = $current_module->language->task_messages->enabled_ok;
    }
}

try
{
    $toolbox = new updates_toolbox();
}
catch(\Exception $e)
{
    cli_colortags::write("<light_red>{$now} - {$e->getMessage()}</light_red>\n\n");
    
    return;
}

if( empty($package) )
{
    cli_colortags::write("<light_red>{$now} - Missing</light_red> <yellow>--name</yellow> <light_red>argument</light_red>\n\n");
    
    return;
}

$target = "{$config->datafiles_location}/tmp/bcupdater-{$config->website_key}." . uniqid();
if( ! is_dir($target) )
{
    if( ! @mkdir($target, 0777, true) )
    {
        cli_colortags::write("<light_red>{$now} - Can't create {$target} dir! Aborting.</light_red>\n\n");
        
        return;
    }
    
    @chmod("{$config->datafiles_location}/tmp", 0777);
    @chmod($target, 0777);
}

cli_colortags::write("<cyan>$now - Starting update for</cyan> <light_cyan>$package</light_cyan>\n");

$res     = "";
$start   = time();
$tarfile = "$target/" . str_replace("/", "-", $package) . ".tgz";
cli_colortags::write("<cyan>Fetching package...</cyan> ");
try
{
    $res = $toolbox->download_package($package);
}
catch(\Exception $e)
{
    cli_colortags::write(array(
        "", "",
        "<light_red>Can't fetch package from updates server:</light_red>",
        "<light_red>{$e->getMessage()}</light_red>",
        "<light_red>Download aborted.</light_red>",
        "", "",
    ));
    rmdir($target);
    
    $hostname = gethostname();
    broadcast_mail_to_moderators(
        "Error while updating BardCanvas on {$config->website_key} at $hostname",
        unindent("
            Error trying to update $package:<br>
            Can't fetch file from updates server due to an error:<br>
            {$e->getMessage()}<br>
            Please check communications and try a manual check.
        ")
    );
    
    return;
}
$length = strlen($res);
$seconds = time() - $start;
cli_colortags::write("<cyan>done. $length bytes downloaded in $seconds seconds.</cyan>\n");
file_put_contents($tarfile, $res);

$config->globals["copy_package_files_log"]        = array();
$config->globals["copy_package_files_has_errors"] = array();
$config->globals["remove_tempdir_log"]            = array();
$config->globals["remove_tempdir_has_errors"]     = array();

$dir = __DIR__;
chdir($target);
cli_colortags::write("<cyan>Extracting file contents...</cyan>\n");
$res = $toolbox->extract_targz($tarfile, $target);
if( ! empty($res) )
{
    cli_colortags::write(array(
        "",
        "<light_red>Error while extracting {$tarfile}:</light_red>",
        "<light_red>{$res}</light_red>",
        "<light_red>Update aborted.</light_red>",
        "", "",
    ));
    
    $hostname = gethostname();
    broadcast_mail_to_moderators(
        "Error while updating BardCanvas on {$config->website_key} at $hostname",
        unindent("
            Error trying to update $package:<br>
            There was an error while extracting the tarfile <b>$tarfile</b>:<br>
            {$res}<br>
            Please check the logs.
        ")
    );
    
    chdir($dir);
    $toolbox->remove_tempdir($target);
    if( $config->globals["remove_tempdir_has_errors"] )
        echo "Can't remove $target. Please review the output below:"
        .    implode("\n", $config->globals["remove_tempdir_log"])
        .    "\n";
    
    return;
}
cli_colortags::write("<cyan>Extraction finished.</cyan>\n");
@unlink($tarfile);

$final_dir   = ROOTPATH;
$display_src = str_replace(ROOTPATH . "/", "", $target);
$display_tgt = str_replace(ROOTPATH . "/", "", $final_dir);
cli_colortags::write("<cyan>Copying new files from </cyan><light_blue>$display_src</light_blue><cyan> to </cyan><light_blue>$display_tgt</light_blue><cyan>...</cyan>\n");
chdir($target);
$toolbox->copy_package_files($target, $final_dir);
$output = implode("\n", $config->globals["copy_package_files_log"]) . "\n";
echo $output;

if( $package == "core/bardcanvas_core" )
{
    @chmod("data", 0777);
    @chmod("logs", 0777);
}

if( $config->globals["copy_package_files_has_errors"] )
{
    cli_colortags::write(array(
        "",
        "<light_red>Error while copying contents on $final_dir!</light_red>",
        "<light_red>Tech support must be contacted ASAP!</light_red>",
        "", "",
    ));
    
    $html = cli_colortags::to_html($output);
    $hostname = gethostname();
    $formatted_output = nl2br($output);
    broadcast_mail_to_moderators(
        "Error while updating BardCanvas on {$config->website_key} at $hostname",
        unindent("
            Critical error trying to update $package!<br>
            There was an error while copying files on {$final_dir}:<br><br>
            {$formatted_output}<br><br>
            This issue must be fixed immediately to avoid errors.<br>
            Please review the log to get full details about the problem.<br><br>
        ")
    );
    
    chdir($dir);
    $toolbox->remove_tempdir($target);
    if( $config->globals["remove_tempdir_has_errors"] )
        echo "Can't remove $target. Please review the output below:"
        .    implode("\n", $config->globals["remove_tempdir_log"])
        .    "\n";
    
    return;
}
cli_colortags::write("<cyan>Coying finished.</cyan>\n");

chdir($dir);
$toolbox->remove_tempdir($target);
    if( $config->globals["remove_tempdir_has_errors"] )
        echo "Can't remove $target. Please review the output below:"
        .    implode("\n", $config->globals["remove_tempdir_log"])
        .    "\n";
cli_colortags::write("<cyan>Update finished.</cyan>\n");
cli_colortags::write("\n");

broadcast_to_moderators(
    "information",
    "$package has been updated. Please check the logs if you want full details."
);

if( $arg["--install"] == "true" )
{
    $errors   = array();
    $messages = array();
    
    cli_colortags::write("<light_blue>Starting package installation...</light_blue>\n");
    
    $original_module_name = $current_module->name;
    $current_module = $modules["modules_manager"];
    install_package();
    $current_module = $modules[$original_module_name];
    
    foreach($messages as $message) cli_colortags::write("<light_green> • $message</light_green>\n");
    foreach($errors as $error)     cli_colortags::write("<light_red> ! $error</light_red>\n");
    cli_colortags::write("<light_blue>Finished package installation.</light_blue>\n");
}

if( $arg["--no-cache-purge"] ) return;

if( $settings->get("modules:modules_manager.disable_cache") != "true" )
{
    cli_colortags::write("<green>Purging modules cache...</green>");
    $force_regeneration = true;
    $avoid_postinits    = true;
    include ROOTPATH . "/includes/modules_autoloader.inc";
    cli_colortags::write("<green> done.</green>\n");
}
cli_colortags::write("\n");
