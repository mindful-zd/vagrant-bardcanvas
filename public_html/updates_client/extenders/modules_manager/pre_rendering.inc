<?php
/**
 * Modules manager extender: pre-rendering
 *
 * @package    BardCanvas
 * @subpackage updates_client
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 */

global $_all_modules, $config;

#
# Forging of actually updatable stuff
#

$updatable_items = array();

# Core
if( is_writable(ROOTPATH . "/engine_version.dat") ) $updatable_items[] = "core/bardcanvas_core";
if( is_writable(ROOTPATH . "/lib/version.dat")    ) $updatable_items[] = "core/bardcanvas_lib";

# Modules
foreach(glob(ROOTPATH . "/*", GLOB_ONLYDIR) as $dir)
{
    if( ! is_writable($dir) ) continue;
    
    $file = "$dir/module_info.xml";
    if( ! file_exists($file) ) continue;
    
    $module_name = basename(dirname($file));
    if( ! isset($_all_modules[$module_name]) ) continue;
    
    $updatable_items[] = $_all_modules[$module_name]->group . "/" . $module_name;
}

# Templates
foreach(glob(ROOTPATH . "/templates/*", GLOB_ONLYDIR) as $dir)
{
    if( ! is_writable($dir) ) continue;
    
    $file = "$dir/template_info.xml";
    if( ! file_exists($file) ) continue;
    
    $name  = basename(dirname($file));
    $xml   = simplexml_load_file($file);
    $group = trim($xml->group);
    
    $updatable_items[] = "{$group}/{$name}";
}

$config->globals["modules:updates_client.updatable_items"] = $updatable_items;
?>

<!-- Updates client elements -->

<style type="text/css">
    #modules_listing tr           .updatable_span { display: none; }
    #modules_listing tr.updatable .updatable_span { display: inline-block; }
    #modules_listing tr           .updatable_div  { display: none; }
    #modules_listing tr.updatable .updatable_div  { display: block; }
    
    #modules_listing tr.updatable td { background-color:   #fff1a0; }
</style>

<script type="text/javascript">
    
    function check_for_updates()
    {
        clear_modules_filter();
        
        var packages = [];
        $('#modules_listing').find('tr').each(function()
        {
            var $this = $(this);
            $this.removeClass('updatable');
            
            var package_key = $this.attr('data-module-group') + '/' + $this.attr('data-module-name');
            packages[packages.length] = package_key + '|' + $this.attr('data-package-version');
        });
        
        var url = $_FULL_ROOT_PATH + '/updates_client/web_check.php';
        var params = {
            packages: packages,
            wasuuup:  wasuuup()
        };
        $.blockUI(blockUI_default_params);
        $.post(url, params, function(data)
        {
            $.unblockUI();
            if( data.message != 'OK' )
            {
                alert( data.message );
                
                return;
            }
            
            var $listing = $('#modules_listing');
            for(var i in data.data)
            {
                var parts     = i.split('/');
                var group     = parts[0];
                var name      = parts[1];
                var version   = data.data[i];
                var changelog = 'https://bardcanvas.com/changes/' + i + '.md';
                
                var $tr = $listing.find('tr[data-module-group="' + group + '"][data-module-name="' +  name + '"]');
                $tr.find('.updatable_span .new_version').text(version);
                $tr.find('a.changelog_link').attr('href', changelog);
                $tr.toggleClass('updatable', true);
            }
            
            $listing.find('tr:not(.updatable)').hide();
        });
    }
    
    function update_component(trigger)
    {
        var $trigger     = $(trigger);
        var $tr          = $trigger.closest('.module');
        var package_name = $tr.attr('data-module-group') + '/' + $tr.attr('data-module-name');
        
        $('#realtime_log_viewer').data('on-close-exec-function', function()
        {
            var new_version = $tr.find('.updatable_span .new_version').text();
            $tr.find('.local_version_details').text(new_version);
            $tr.toggleClass('updatable', false)
        });
    
        deploy_component(package_name);
    }
    
    function deploy_component(package_name, install)
    {
        var url    = $_FULL_ROOT_PATH + '/updates_client/web_update_package.php';
        var params = {
            name:    package_name,
            wasuuup: wasuuup()
        };
        
        if( typeof install == 'undefined' ) install = '';
        if( install == 'true' ) params.install = 'true';
        
        $.blockUI(blockUI_default_params);
        $.get(url, params, function(response)
        {
            $.unblockUI();
            if( response.indexOf('OK:') < 0 )
            {
                alert( response );
                
                return;
            }
            
            var log = response.replace('OK:', '');
            launch_realtime_log_viewer(log, false);
        });
    }
    
    function launch_component_installation(package_name)
    {
        if( package_name == '' )
        {
            alert('<?= $this_module->language->component_addition->manual->enter_a_package_identifier ?>');
            
            return;
        }
        
        var parts = package_name.split('/');
        var sel   = sprintf('tr[data-module-group="%s"][data-module-name="%s"]', parts[0], parts[1]);
        if( $('#modules_listing').find(sel).length > 0 )
        {
            alert('<?= $this_module->language->modules_manager->package_already_installed ?>');
            
            return;
        }
        
        var $dialog = $('#component_addition_dialog').closest('.ui-dialog');
        
        var url = $_FULL_ROOT_PATH + '/updates_client/web_check.php';
        var params = {
            packages:            [package_name + '|0'],
            check_for_existence: 'true',
            wasuuup:             wasuuup()
        };
        $dialog.block(blockUI_default_params);
        $.post(url, params, function(data)
        {
            $dialog.unblock();
            if( data.message != 'OK' )
            {
                alert( data.message );
                
                return;
            }
            
            $('#component_addition_dialog').dialog('close');
            deploy_component( package_name, 'true' )
        });
    }
</script>

<? if( ! empty($_GET["deploy_package"])): ?>
    <script type="text/javascript">
        $(document).ready(function() { deploy_component('<?= $_GET["deploy_package"] ?>', '<?= $_GET["install"] ?>'); });
    </script>
<? endif; ?>

<div id="component_addition_dialog" style="display: none"
     title="<?= $this_module->language->component_addition->title ?>">
    
    <?= $this_module->language->component_addition->info ?>
    
    <section>
        <h2><?= $this_module->language->component_addition->manual->title ?></h2>
        <div class="framed_content">
            <?= $this_module->language->component_addition->manual->info ?>
            <p class="aligncenter" style="margin-bottom: 0;">
                <input type="text" id="package_key_to_install"
                       placeholder="<?= $this_module->language->component_addition->manual->input_placeholder ?>"
                       style="width: 100%; margin-bottom: 10px;"><br>
                <button onclick="launch_component_installation( $('#package_key_to_install').val().trim() )"
                        style="width: 50%">
                    <?= $this_module->language->component_addition->manual->install ?>
                    <i class="fa fa-play"></i>
                </button>
            </p>
        </div>
    </section>
    
    <section>
        <h2><?= $this_module->language->component_addition->remote->title ?></h2>
        <div class="framed_content">
            <?= $this_module->language->component_addition->remote->info ?>
        </div>
    </section>
</div>
