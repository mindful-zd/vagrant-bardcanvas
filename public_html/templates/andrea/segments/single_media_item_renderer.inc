<?php
/**
 * Single media item renderer
 *
 * @var config       $config
 * @var module       $current_module gallery
 * @var media_record $item
 */

use hng2_base\config;
use hng2_base\module;
use hng2_media\media_record;

$author = $item->get_author();
?>

<article class="post single_post media_item single_media_item clearfix" data-item-id="<?= $item->id_media ?>"
         data-main-category="<?= $item->main_category_slug ?>"
         data-author-role="<?= $author->get_role(true) ?>" data-author-level="<?= $author->level ?>">
    
    <div class="meta_box clearfix">
        
        <img class="user_avatar" src="<?= $author->get_avatar_url() ?>">
        
        <div class="meta_section upper">
            <a class="meta_field user_display_name" data-user-level="<?= $author->level ?>"
               href="<?= $config->full_root_url ?>/user/<?= $author->user_name ?>/">
                <span class="fa fa-user fa-fw"></span>
                <?= $author->get_processed_display_name() ?>
            </a>
            
            <? if($account->level >= config::COADMIN_USER_LEVEL && $account->id_account != $author->id_account): ?>
                <span class="meta_field critical pseudo_link disable_user_link" onclick="if(confirm($_GENERIC_CONFIRMATION)) toggle_account( '<?= $author->id_account ?>', 'disable', this )">
                    <span class="fa fa-lock"></span>
                    <?= $language->disable ?>
                </span>
                <span class="user_level_switcher">
                    <span class="current meta_field critical pseudo_link"
                          onclick="open_level_switcher(this, '<?= $author->id_account ?>', '<?= $author->level ?>', false)">
                        <span class="fa fa-pencil fa-fw"></span>
                        [<?= $author->level ?>] <?= $config->user_levels_by_level[$author->level] ?>
                    </span>
                    <span class="target" style="display: none;"></span>
                </span>
            <? endif; ?>
            
            <a class="meta_field" href="<?= $config->full_root_url ?>/category/<?= $item->main_category_slug ?>/">
                <span class="fa fa-folder fa-fw"></span>
                <?= $item->main_category_title ?>
            </a>
            <? if( $item->main_category_visibility == "level_based" && ! empty($item->main_category_min_level) ): ?>
                <span class="meta_field important">
                    <span class="fa fa-users"></span>
                    <?= $config->user_levels_by_level[$item->main_category_min_level]; ?>
                </span>
            <? elseif( $item->visibility == "level_based" ): ?>
                <span class="meta_field important">
                    <span class="fa fa-users"></span>
                    <?= $config->user_levels_by_level[$item->author_level]; ?>
                </span>
            <? endif; ?>
            
            <? foreach( $item->get_filtered_tags_list() as $tag): ?>
                <a class="meta_field" href="<?= $config->full_root_path ?>/tag/<?= $tag ?>/media" target="_blank">
                    <span class="fa fa-hashtag"></span>
                    <?= $tag ?>
                </a>
            <? endforeach; ?>
        </div>
        <div class="meta_section">
            <a class="meta_field dimmed" href="<?= $config->full_root_url ?>/date/<?= date("Y/m/d", strtotime($item->publishing_date)) ?>/">
                <span class="fa fa-calendar fa-fw"></span>
                <?= time_complete_string($item->publishing_date) . " (" . time_elapsed_string($item->publishing_date) . ")" ?>
            </a>
            <span class="meta_field">
                <span class="fa fa-eye fa-fw"></span>
                <?= number_format($item->views); ?>
            </span>
            
            <? if( $account->level >= config::MODERATOR_USER_LEVEL ): ?>
                <span class="meta_field critical">
                    <span class="fa fa-cloud"></span>
                    <?= $item->creation_ip ?>
                </span>
                <a class="meta_field critical" href="<?= $config->full_root_path ?>/?s=ip:<?= $item->creation_ip ?>">
                    <span class="fa fa-search"></span>
                    <?= $language->ip ?>
                </a>
                <? $parts = explode(".", $item->creation_ip); array_pop($parts); ?>
                <a class="meta_field critical" href="<?= $config->full_root_path ?>/?s=ip:<?= implode(".", $parts) ?>.%25">
                    <span class="fa fa-search"></span>
                    <?= $language->segment ?>
                </a>
                
                <?
                $parts    = explode("; ", $item->creation_location);
                $isp      = array_pop($parts);
                $country  = array_pop($parts);
                $city     = implode("; ", $parts);
                
                if( $city != "N/A; N/A") : ?>
                    <a class="meta_field critical" href="<?= $config->full_root_path ?>/?s=city:<?= urlencode($city) ?>">
                        <span class="fa fa-map-marker"></span>
                        <?= $city ?>
                    </a>
                <? endif; ?>
                <? if($country != "N/A"): ?>
                    <a class="meta_field critical" href="<?= $config->full_root_path ?>/?s=country:<?= urlencode($country) ?>">
                        <span class="fa fa-globe"></span>
                        <?= $country ?>
                    </a>
                <? endif; ?>
                <? if($isp != "N/A"): ?>
                    <a class="meta_field critical" href="<?= $config->full_root_path ?>/?s=isp:<?= urlencode($isp) ?>">
                        <span class="fa fa-building"></span>
                        <?= $isp ?>
                    </a>
                <? endif; ?>
            <? endif; ?>
        </div>
        
    </div>
    
    <h1>
        <?= $item->get_processed_title() ?>
    </h1>
    
    <p class="single_item_actions">
        <span class="item action clipboard-copy" data-clipboard-text="<?= $item->get_page_url(true) ?>" style="">
            <?= $language->permalink ?>
            <span class="fa fa-clipboard"></span>
        </span>
        
        <? if( $item->can_be_edited() ): ?>
            <a class="item action" href="<?= $config->full_root_path ?>/gallery/?edit_item=<?= $item->id_media ?>&wasuuup=<?= md5(mt_rand(1, 65535)) ?>">
                <span class="fa fa-pencil"></span>
                <?= $language->edit ?>
            </a>
        <? endif; ?>
    
        <? if( $item->can_be_deleted() ): ?>
            <a class="item action" href="<?= $config->full_root_path ?>/gallery/?trash_item=<?= $item->id_media ?>&wasuuup=<?= md5(mt_rand(1, 65535)) ?>"
               onclick="return confirm('<?= $language->confirm_action ?>')">
                <span class="fa fa-trash"></span>
                <?= $current_module->language->record_nav->actions->trash ?>
            </a>
        <? endif; ?>
        
        <?= $author->get_pm_sending_link($language->pm_author, "item action") ?>
        
        <? if( $account->_exists || $settings->get("modules:contact.no_anonymous_emails") != "true" ): ?>
            <? if( $author->get_engine_pref("@contact:allow_emails") != "false"
                   || $account->level >= config::MODERATOR_USER_LEVEL ): ?>
                <a class="item action" href="<?= $config->full_root_path ?>/contact/?target=<?= urlencode($author->user_name) ?>">
                    <span class="fa fa-envelope"></span>
                    <?= $language->email_author ?>
                </a>
            <? endif; ?>
        <? endif; ?>
        
        <? if( $account->level < config::MODERATOR_USER_LEVEL && $account->id_account != $author->id_account ): ?>
            <a class="item action" href="<?= $config->full_root_path ?>/contact/?action=report&type=media&id=<?= $item->id_media ?>">
                <span class="fa fa-exclamation-circle"></span>
                <?= $language->report_to_webmaster ?>
            </a>
        <? endif; ?>
        
        <? $current_module->load_extensions("front", "single_media_item_actions"); ?>
        
    </p>
    
    <div class="post_contents">
        
        <? if($item->type == "image"): ?>
            <p>
                <a href="<?= $item->get_item_url() ?>" target="_blank">
                    <img src="<?= $item->get_item_url() ?>" style="max-width: 100%; height: auto;">
                </a>
            </p>
        <? elseif($item->type == "video"): ?>
            <p>
                <?= convert_media_tags("<img src='' data-media-type='video' data-id-media='{$item->id_media}'>") ?>
            </p>
        <? endif; ?>
        
        <?= $item->get_processed_description() ?>
    </div>
    
    <? if( ! empty($author->signature) ): ?>
        <div class="author_signature">
            <?= $author->get_processed_signature() ?>
        </div>
    <? endif ?>
    
</article>

<? $current_module->load_extensions("front", "single_media_item_after_contents"); ?>
