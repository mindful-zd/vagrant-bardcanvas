<?php
/**
 * Modules manager extender: extra heading buttons
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 */

global $account;
?>

<button onclick="check_for_updates()">
    <i class="fa fa-search"></i>
    <?= $this_module->language->modules_manager->buttons->check_updates ?>
</button>

<?
# $userid = fileowner(ROOTPATH . "/config.php");
# $phpuid = fileowner("{$config->datafiles_location}/installed");
if( ! is_writable(ROOTPATH) )
{
    $info_handler = "{$this_module->name}_non_updatable_warning";
    $display      = $account->engine_prefs[$info_handler] == "hidden" ? "" : "display: none;";
    echo "
        <i class=\"fa fa-exclamation-circle pseudo_link\" style=\"vertical-align: bottom; $display\"
           onclick=\"toggle_info_section('$info_handler')\"></i>
    ";
    
    return;
}
?>

<button onclick="show_discardable_dialog('#component_addition_dialog')">
    <i class="fa fa-plus"></i>
    <?= $this_module->language->modules_manager->buttons->add_component ?>
</button>
