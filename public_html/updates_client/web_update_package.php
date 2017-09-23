<?php
/**
 * Single package downloader/applier
 * Can only be invoked from the web
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 * 
 * $_GET params:
 * @param string "name"
 */

include "../config.php";
include "../includes/bootstrap.inc";
header("Content-Type: text/plain; charset=utf-8");

if( empty($_SERVER["HTTP_HOST"]) ) throw_fake_404();
if( empty($_GET["name"]) ) die($language->errors->invalid_call);

$package = stripslashes($_GET["name"]);
$date    = date("Ymd-His");
$logpath = "{$config->logfiles_location}";
$logfile = "package_updater_{$date}.log";

@touch("$logpath/$logfile");
@chmod("$logpath/$logfile", 0777);

file_put_contents("$logpath/$logfile", unindent("
    Invoking downloader for {$package}.
    ------------------------------------------
    Please wait until this script is finished!
    If an error occurs, please contact the tech support staff.
    ----------------------------------------------------------
") . "\n\n");

$skip_inits = true;
$arg = array("--name" => $_GET["name"], "--install" => $_GET["install"]);
ob_start();
include __DIR__ . "/cli_update_package.php";
$contents = ob_get_contents();
ob_end_clean();

file_put_contents("$logpath/$logfile", $contents, FILE_APPEND);
echo "OK:$logfile";
