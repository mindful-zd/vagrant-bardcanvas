<?php
/**
 * Version checker
 * Callable from the web
 * 
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 * 
 * $_POST params:
 * @param array  $packages            [group/name|local_version, ...]
 * @param string $check_for_existence If "true", will check for package existence.
 * 
 * @return string {message:string, data:array(group/name: remote_version, ...)
 */

use hng2_modules\updates_client\updates_toolbox;

include "../config.php";
include "../includes/bootstrap.inc";
header("Content-Type: application/json; charset=utf-8");

if( ! $account->_is_admin ) die(json_encode(array("message" => trim($language->errors->access_denied))));
if( ! is_array($_POST["packages"]) ) die(json_encode(array("message" => trim($language->errors->invalid_call))));

$toolbox = new updates_toolbox();

# Sanitization
$packages = array();
foreach($_POST["packages"] as $package)
{
    list($key, $local_version) = explode("|", $package);
    $packages[$key] = $local_version;
}

$new_versions = $toolbox->get_versions($packages);
if( is_object($new_versions) )  $new_versions = (array) $new_versions;
if( ! is_array($new_versions) ) $new_versions = array();

$settings->set("modules:updates_client.last_check", date("Y-m-d H:i:s"));
if( empty($new_versions) )
{
    if( $_POST["check_for_existence"] == "true" )
        die( json_encode(array("message" => trim($current_module->language->modules_manager->package_not_found))) );
    else
        die( json_encode(array("message" => trim($current_module->language->modules_manager->no_updates_detected))) );
}

die( json_encode(array("message" => "OK", "data" => $new_versions)) );
