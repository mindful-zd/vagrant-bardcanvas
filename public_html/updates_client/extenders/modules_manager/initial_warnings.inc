<?php
/**
 * Modules manager extender: initial warnings
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 */

global $account;

# $userid = fileowner(ROOTPATH . "/config.php");
# $phpuid = fileowner("{$config->datafiles_location}/installed");
if( is_writable(ROOTPATH) ) return; ?>

<? $info_handler = "{$this_module->name}_non_updatable_warning"; ?>
<div class="info_handler framed_content state_highlight" id="<?= $info_handler ?>"
     style="margin-bottom: 0; <? if($account->engine_prefs[$info_handler] == "hidden") echo "display: none;"; ?>">
    <span class="fa fa-times-circle pseudo_link pull-right" onclick="toggle_info_section('<?= $info_handler ?>')"></span>
    <i class="fa fa-warning"></i>
    <?= $this_module->language->modules_manager->warning; ?>
</div>
