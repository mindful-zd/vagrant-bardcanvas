
<!-- accounts :: basic :: dialog defs -->

<? if( ! $account->_exists ): ?>
    
    <div id="login_dialog" style="display: none;" title="<?= $this_module->language->login ?>">
        <div id="login_targetarea" style="display: none;"></div>
        <form name="login_form" id="login_form" method="post" action="<?=$config->full_root_path?>/accounts/scripts/login.php">
            <input type="hidden" name="goto" value="<?= $_SERVER["REQUEST_URI"] ?>">
    
            <? $this_module->load_extensions("login_form", "top"); ?>
            
            <span class="field">
                <span class="caption"><?= $this_module->language->user_name ?></span>
                <input type="text" name="user_name">
            </span>
            <span class="field">
                <span class="caption"><?= $this_module->language->password ?></span>
                <input type="password" name="password">
            </span>
            <span class="pseudo_link" onclick="$('#login_dialog').dialog('close'); reset_password();">
                <span class="fa fa-key"></span>
                <?= $this_module->language->reset_password ?>
            </span>
            
            <? $this_module->load_extensions("login_form", "before_submit_button"); ?>
            
            <p align="right" style="margin-bottom: 0;">
                <button type="submit">
                    <?= $language->submit ?>
                    <span class="fa fa-play"></span>
                </button>
            </p>
        </form>
    </div>
    
    <div id="password_reset" style="display: none;" title="<?= $this_module->language->reset_form->title ?>">
        
        <div id="reset_targetarea" style="display: none;"></div>
        
        <form name="reset_form" id="reset_form" method="post" action="<?=$config->full_root_path?>/accounts/reset_password.php">
            
            <div class="framed_content state_highlight" style="margin-top: 0;">
                <span class="fa fa-info-circle"></span>
                <?=$this_module->language->reset_form->intro ?>
            </div>
            
            <?=$this_module->language->reset_form->your_email ?>
            <div style="margin-left: 25px;">
                <input type="text" name="email" style="width: 100%;">
            </div>
    
            <p align="right" style="margin-bottom: 0;">
                <button type="submit">
                    <?= $language->submit ?>
                    <span class="fa fa-play"></span>
                </button>
            </p>
        </form>
    </div>
    
    <div id="login_errors" style="display: none;">
        <div class="invalid_login_info"><?= $this_module->language->errors->invalid_login_info ?></div>
        <div class="NO_EMAIL_AS_USER_NAME"><?= $this_module->language->errors->no_email_as_user_name ?></div>
        <div class="ERROR_MISSING_PARAMS"><?= $this_module->language->errors->missing_params ?></div>
        <div class="ERROR_ACCOUNT_UNEXISTENT"><?= $this_module->language->errors->account_unexistent ?></div>
        <div class="ERROR_ACCOUNT_DISABLED"><?= $this_module->language->errors->account_disabled ?></div>
        <div class="ERROR_UNCONFIRMED_ACCOUNT"><?= unindent($this_module->language->errors->verification_email_resent) ?></div>
        <div class="ERROR_WRONG_PASSWORD"><?= $this_module->language->errors->wrong_password ?></div>
        <div class="ERROR_ENGINE_DISABLED"><?= $this_module->language->errors->engine_disabled ?></div>
        <div class="ERROR_DEVICE_DISABLED"><?= $this_module->language->errors->device_disabled ?></div>
        <? $this_module->load_extensions("login", "additional_errors"); ?>
    </div>
    <div id="device_messages" style="display: none;">
        <div class="UNREGISTERED"><?= $this_module->language->errors->device_unregistered ?></div>
    </div>
    
    <div id="reset_messages" style="display: none;">
        <div class="OK"><?= $this_module->language->reset_form->OK ?></div>
    </div>
    
    <script type="text/javascript">
        $(document).ready(function() {
            if( '<?= $_GET["show_login_form"] ?>' == 'true' )
                show_login_form();
        });
    </script>
    
<? else: ?>
    
    <div id="user_menu_items" class="dropdown_menu" style="display: none;">
        
        <a class="main_menu_item <?= $current_module->name == $this_module->name && basename($_SERVER["PHP_SELF"]) == "edit_account.php" ? "current" : ""  ?>"
           href="<?= "$config->full_root_path/$this_module->name/edit_account.php" ?>">
            <span class="fa fa-edit fa-fw"></span>
            <?= $this_module->language->edit_account ?>
        </a>
        
        <? if( ! empty($config->globals["editable_prefs_collection"]) ): ?>
            <a class="main_menu_item <?= $current_module->name == $this_module->name && basename($_SERVER["PHP_SELF"]) == "preferences.php" ? "current" : ""  ?>"
               href="<?= "$config->full_root_path/$this_module->name/preferences.php" ?>">
                <span class="fa fa-list-ul fa-fw"></span>
                <?= $this_module->language->preferences ?>
            </a>
        <? endif; ?>
        
        <a class="main_menu_item <?= $current_module->name == $this_module->name && basename($_SERVER["PHP_SELF"]) == "devices.php" ? "current" : "" ?>"
           href="<?= "$config->full_root_path/$this_module->name/devices.php" ?>">
            <span class="fa fa-mobile fa-fw"></span>
            <?= $this_module->language->edit_devices ?>
        </a>
        
        <a class="main_menu_item <?= basename($_SERVER["REQUEST_URI"]) == $account->user_name ? "current" : ""  ?>"
           href="<?= "$config->full_root_path/user/{$account->user_name}" ?>">
            <span class="fa fa-home fa-fw"></span>
            <?= $this_module->language->view_my_profile ?>
        </a>
        
        <a class="main_menu_item" href="<?=$config->full_root_path?>/"
           onclick="location.href='<?=$config->full_root_path?>/accounts/scripts/logout.php'; return false;">
            <span class="fa fa-sign-out fa-fw"></span>
            <?= $this_module->language->logout ?>
        </a>
    
    </div>
    
<? endif; ?>

<? if( ! $account->has_admin_rights_to_module("accounts") ) return; ?>

<div id="level_switch" style="display: none;">
    <select onchange="change_user_level(this)">
        <? foreach($config->user_levels_by_level as $level => $caption): ?>
            <? if( $level > $account->level ) continue; ?>
            <option value="<?= $level ?>">[<?= $level ?>] <?= $caption ?></option>
        <? endforeach; ?>
        <option disabled>──────────</option>
        <option value="!@cancel">&lt;<?= $language->cancel ?>&gt;</option>
    </select>
</div>

<div id="online_users_notification_target" style="display: none;"></div>
<div id="online_users_notification_dialog" style="display: none;"
     title="<?= $this_module->language->notify_online_users->title ?>"
     data-ok-caption="<?= $language->submit ?>" data-cancel-caption="<?= $language->cancel ?>">
    <form method="post" id="online_users_notification" action="<?= $this_module->get_url() ?>/scripts/notify_online_users.php">
        
        <p style="margin-bottom: 10px;"><?= $this_module->language->notify_online_users->select_type ?></p>
        <p style="margin-top: 0;">
            <? foreach($this_module->language->notify_online_users->types->type as $index => $type): ?>
                <label><input type="radio" <? if(trim($type["key"]) == "information") echo "checked"; ?> name="type"
                              value="<?= $type["key"] ?>"><?= $type ?></input></label><br>
            <? endforeach; ?>
        </p>
        
        <p style="margin-bottom: 10px;"><?= $this_module->language->notify_online_users->type_message ?></p>
        <textarea name="message" style="width: 100%" rows="4" wrap="soft"></textarea>
    </form>
</div>
