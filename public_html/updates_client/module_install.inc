<?php
/**
 * Module installation file
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 * 
 * Trailing vars:
 * @var string $module_install_action install, uninstall, enable, disable
 * @var array  $messages
 * @var array  $errors
 * @var module $this_module
 * @var module $current_module
 */

use hng2_base\module;

$init_settings = array(
    "modules:updates_client.server_url" => "http://bardcanvas.com",
);

if( $module_install_action == "install" )
{
    foreach($init_settings as $key => $val) $settings->set($key, $val);
    
    return;
}

if( $module_install_action == "uninstall" )
{
    foreach($init_settings as $key => $val) $settings->delete($key);
    
    return;
}
