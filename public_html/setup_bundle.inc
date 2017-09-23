<?php
/**
 * BardCanvas Setup commands for Bardcanvas Bundle
 * 
 * @var \PDO $db
 * @var bool $preinit_bundle If true, preinit vars will be set
 *                           and return. After preiniting, $preinit_bundle is set to false on
 *                           the calling script so next call goes straight ahead.
 * @var string $bundle_name
 * @var string $support_text
 */

if( $preinit_bundle )
{
    # No preinits for this bundle.
    return;
}

#
# Categories
#

$db->exec("
    create table if not exists categories (
    
      id_category       VARCHAR(32) NOT NULL DEFAULT '',
      parent_category   VARCHAR(32) NOT NULL DEFAULT '',
    
      slug              VARCHAR(128) NOT NULL DEFAULT '',
      title             VARCHAR(255) NOT NULL DEFAULT '',
      description       VARCHAR(255) NOT NULL DEFAULT '',
    
      visibility        ENUM('public', 'users', 'level_based') NOT NULL DEFAULT 'public',
      min_level         tinyint unsigned not null default 0,
    
      PRIMARY KEY           ( id_category ),
      INDEX   category_tree ( id_category, parent_category ),
      INDEX   by_slug       ( slug(5) )
    
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE='utf8mb4_unicode_ci'
");
$db->exec("
    insert ignore into categories set
      id_category     = '0000000000000',
      parent_category = '',
      slug            = 'default',
      title           = 'Default category',
      description     = 'Uncategorized items',
      visibility      = 'public',
      min_level       = '0'
");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:categories.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:categories.enabled'");

#
# Basic ad injections
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:basic_ad_injections.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:basic_ad_injections.enabled'");

#
# BC customizable header
#

$db->exec("insert ignore into settings set value = 'My BC Website' , name = 'modules:bc_customizable_header.icon_caption'");
$db->exec("
    insert ignore into settings set
    value = 'A place for those that seek<br>The Answer to the Great Question of Life,<br>the Universe and Everything',
    name = 'modules:bc_customizable_header.site_legend'
");

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:bc_customizable_header.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:bc_customizable_header.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:bc_customizable_header.enabled'");

#
# Log viewer
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:log_viewer.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:log_viewer.enabled'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:log_viewer.for_admins_only'");

#
# Contact
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:contact.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:contact.enabled'");

#
# Gallery
#

$db->exec("
    create table if not exists media (
    
      id_media          bigint unsigned not null default 0,
      id_author         bigint unsigned not null default 0,
    
      # Path is relative to the /media_server directory, E.G.:
      # Relative> /year/month/username_mediatitle_randomseed.png
      # Absolute> /mediaserver/year/month/username_mediatitle_randomseed.png
      # /media_server is located in /data/uploaded_media
      path              varchar(255) not null default '',
      type              varchar(64) not null default '',
      mime_type         varchar(64) not null default '',
      dimensions        varchar(64) not null default '',
      size              int unsigned not null default 0,
      title             varchar(255) not null default '',
      thumbnail         varchar(255) not null default '',
    
      description       text,
      main_category     varchar(32) not null default '',
    
      visibility        enum('public', 'private', 'users', 'friends', 'level_based') not null default 'public',
      status            enum('draft', 'published', 'reviewing', 'hidden', 'trashed') not null default 'draft',
      password          varchar(32) not null default '',
      allow_comments    tinyint unsigned not null default 1,
    
      creation_date     datetime default null,
      creation_ip       varchar(15) not null default '',
      creation_host     varchar(255) not null default '',
      creation_location varchar(255) not null default '',
    
      publishing_date   datetime default null,
      comments_count    int unsigned not null default 0,
      tags              varchar(255) not null default '',
    
      last_update       datetime default null,
      last_commented    datetime default null,
    
      primary key        ( id_media ),
      index   by_path    ( path(5) ),
      index   by_author  ( id_author )
    
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists media_views (
      id_media          bigint unsigned not null default 0,
      views             int unsigned not null default 0,
      last_viewed       datetime default null,
    
      primary key        ( id_media )
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists media_tags (
    
      id_media       bigint unsigned not null default 0,
      tag            varchar(100) not null default '',
      date_attached  datetime,
      order_attached double unsigned not null default 0,
    
      primary key ( id_media, tag )
    
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists media_categories (
    
      id_media       bigint unsigned not null default 0,
      id_category    varchar(32) not null default '',
      date_attached  datetime,
      order_attached double unsigned not null default 0,
    
      primary key ( id_media, id_category )
    
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists media_mentions (
    
      id_media       bigint unsigned not null default 0,
      id_account     bigint unsigned not null default 0,
      date_attached  datetime,
      order_attached double unsigned not null default 0,
    
      primary key ( id_media, id_account )
    
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:gallery.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:gallery.enabled'");

#
# Widgets manager
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:widgets_manager.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:widgets_manager.enabled'");

#
# Posts
#

$db->exec("
    create table if not exists posts (
        
        id_post           bigint unsigned not null default 0,
        parent_post       bigint unsigned not null default 0,
        id_author         bigint unsigned not null default 0,
        
        slug              varchar(128) not null default '',
        title             varchar(255) not null default '',
        excerpt           varchar(255) not null default '',
        content           longtext,
        main_category     varchar(32) not null default '',
        
        visibility        enum('public', 'private', 'users', 'friends', 'level_based') not null default 'public',
        status            enum('draft', 'published', 'reviewing', 'hidden', 'trashed') not null default 'draft',
        password          varchar(32) not null default '',
        allow_comments    tinyint unsigned not null default 1,
        
        pin_to_home                tinyint unsigned not null default 0,
        pin_to_main_category_index tinyint unsigned not null default 0,
        
        creation_date     datetime default null,
        creation_ip       varchar(15) not null default '',
        creation_host     varchar(255) not null default '',
        creation_location varchar(255) not null default '',
        
        publishing_date   datetime default null,
        expiration_date   datetime default null,
        comments_count    int unsigned not null default 0,
        
        last_update       datetime default null,
        last_commented    datetime default null,
        
        id_featured_image bigint unsigned not null default 0,
        
        primary key        ( id_post ),
        index   posts_tree ( id_post, parent_post ),
        index   by_slug    ( slug(5) ),
        index   by_author  ( id_author ),
        index   by_ip      ( creation_ip(7) )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists post_views (
        id_post           bigint unsigned not null default 0,
        views             int unsigned not null default 0,
        last_viewed       datetime default null,
        
        primary key        ( id_post )
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists post_media (
        
        id_post        bigint unsigned not null default 0,
        id_media       bigint unsigned not null default 0,
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_post, id_media )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists post_tags (
        
        id_post        bigint unsigned not null default 0,
        tag            varchar(100) not null default '',
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_post, tag )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists post_categories (
        
        id_post        bigint unsigned not null default 0,
        id_category    varchar(32) not null default '',
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_post, id_category )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists post_mentions (
        
        id_post        bigint unsigned not null default 0,
        id_account     bigint unsigned not null default 0,
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_post, id_account )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists post_meta (
      id_post bigint unsigned not null default 0,
      name    varchar(128) not null default '',
      value   longtext,
      
      primary key (id_post, name)
      
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:posts.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:posts.enabled'");
$db->exec("insert ignore into settings set value = '250'  , name = 'modules:posts.excerpt_length'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:posts.meta_table_created_v2'");
$db->exec("insert ignore into settings set value = '200'  , name = 'modules:posts.level_allowed_to_edit_custom_fields'");

#
# Search
#

$db->exec("
    create table if not exists search_history (
        
        terms    varchar(100) not null default '',
        hits     bigint unsigned not null default 0,
        last_hit date,
        
        primary key ( terms, last_hit )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:search.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:search.enabled'");

#
# Moderation
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:moderation.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:moderation.enabled'");

#
# Comments
#

$db->exec("
    create table if not exists comments (
        
        id_post             bigint unsigned not null default 0,
        id_comment          bigint unsigned not null default 0,
        parent_comment      bigint unsigned not null default 0,
        parent_author       bigint unsigned not null default 0,
        indent_level        tinyint unsigned not null default 0,
        
        id_author           bigint unsigned not null default 0,
        author_display_name varchar(100) not null default '',
        author_email        varchar(100) not null default '',
        author_url          varchar(100) not null default '',
        
        content             longtext,
        status              enum('published', 'reviewing', 'rejected', 'spam', 'hidden', 'trashed') not null default 'published',
        
        creation_date       datetime default null,
        creation_ip         varchar(15) not null default '',
        creation_host       varchar(255) not null default '',
        creation_location   varchar(255) not null default '',
        
        karma               int not null default 0,
        last_update         datetime default null,
        
        primary key              ( id_comment ),
        index   comments_tree    ( id_comment, parent_comment ),
        index   by_author        ( id_author ),
        index   by_post          ( id_post, status ),
        index   by_ip            ( creation_ip(7) ),
        index   by_parent_author ( parent_author )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists comment_media (
        
        id_comment     bigint unsigned not null default 0,
        id_media       bigint unsigned not null default 0,
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_comment, id_media )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists comment_tags (
        
        id_comment     bigint unsigned not null default 0,
        tag            varchar(100) not null default '',
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_comment, tag )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("
    create table if not exists comment_mentions (
        
        id_comment     bigint unsigned not null default 0,
        id_account     bigint unsigned not null default 0,
        date_attached  datetime,
        order_attached double unsigned not null default 0,
        
        primary key ( id_comment, id_account )
        
    ) engine=InnoDB default charset=utf8mb4 collate='utf8mb4_unicode_ci'
");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:comments.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:comments.enabled'");
$db->exec("insert ignore into settings set value = '20'   , name = 'modules:comments.items_per_page'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:comments.show_in_indexes'");
$db->exec("insert ignore into settings set value = '10'   , name = 'modules:comments.items_per_index_entry'");
$db->exec("insert ignore into settings set value = '90'   , name = 'modules:comments.disable_new_after'");

#
# Emoji One
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:emojione_for_bardcanvas.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:emojione_for_bardcanvas.enabled'");

#
# Giphy
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:giphy_for_bardcanvas.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:giphy_for_bardcanvas.enabled'");

#
# Youtube
#

$db->exec("insert ignore into settings set value = 'true' , name = 'modules:youtube_for_bardcanvas.installed'");
$db->exec("insert ignore into settings set value = 'true' , name = 'modules:youtube_for_bardcanvas.enabled'");

#
# Twitter Cards
#

$db->exec("insert ignore into settings set value = 'true'          , name = 'modules:twitter_cards.installed'");
$db->exec("insert ignore into settings set value = 'true'          , name = 'modules:twitter_cards.enabled'");
$db->exec("insert ignore into settings set value = 'true'          , name = 'modules:twitter_cards.render_on_posts'");
$db->exec("insert ignore into settings set value = 'true'          , name = 'modules:twitter_cards.render_on_media'");
$db->exec("insert ignore into settings set value = 'summary'       , name = 'modules:twitter_cards.card_type'");
$db->exec("insert ignore into settings set value = 'mobile-retina' , name = 'modules:twitter_cards.image_size'");

#
# Contents and stuff
#

$db->exec("insert ignore into settings set name = 'modules:widgets_manager.ls_layout', value = '"
    . "accounts.meta       | ameta0  | Access     | offline | show |\n"
    . "accounts.meta       | ameta1  |            | online  | show |\n"
    . "categories.listing  | clist   | Categories | all     | show |\n"
    . "posts.archives_tree | patree  | Archives   | all     | show |'");
$db->exec("insert ignore into settings set name = 'modules:widgets_manager.rs_layout', value = '" 
    . "widgets_manager.text           | w1 | Customize this area!             | all | show | \n"
    . "accounts.login                 | w3 | Access                           | all | show | \n"
    . "search.search                  | w4 |                                  | all | hide | search_results\n"
    . "posts.other_posts_in_category  | oc | Other posts in this category     | all | show | single_post\n"
    . "search.searches_cloud          | w5 | Popular searches                 | all | show | \n"
    . "search.tags_cloud              | w6 | Popular tags                     | all | show | \n"
    . "#posts.popular_posts_fortnight  | pq | Popular posts                    | all | show | home,search_results\n"
    . "widgets_manager.text           | w2 | Customize this area!             | all | show |'");

if( ! is_dir("data/widgets") ) mkdir("data/widgets");
chmod("data/widgets", 0777);
if( ! file_exists("data/widgets/left_sidebar-archives_tree-patree.dat"       ) ) file_put_contents("data/widgets/left_sidebar-archives_tree-patree.dat",        "a:2:{s:9:\"cache_ttl\";s:1:\"1\";s:13:\"cache_version\";s:1:\"1\";}");
if( ! file_exists("data/widgets/left_sidebar-listing-clist.dat"              ) ) file_put_contents("data/widgets/left_sidebar-listing-clist.dat",               "a:1:{s:13:\"cache_version\";s:1:\"1\";}");
if( ! file_exists("data/widgets/right_sidebar-other_posts_in_category-oc.dat") ) file_put_contents("data/widgets/right_sidebar-other_posts_in_category-oc.dat", "a:3:{s:5:\"limit\";s:1:\"5\";s:5:\"order\";s:4:\"desc\";s:13:\"cache_version\";s:1:\"1\";}");
if( ! file_exists("data/widgets/right_sidebar-popular_posts_fortnight-pq.dat") ) file_put_contents("data/widgets/right_sidebar-popular_posts_fortnight-pq.dat", "a:2:{s:5:\"limit\";s:1:\"5\";s:13:\"cache_version\";s:1:\"1\";}");
if( ! file_exists("data/widgets/right_sidebar-searches_cloud-w5.dat"         ) ) file_put_contents("data/widgets/right_sidebar-searches_cloud-w5.dat",          "a:2:{s:8:\"min_hits\";s:2:\"10\";s:13:\"cache_version\";s:1:\"1\";}");
if( ! file_exists("data/widgets/right_sidebar-tags_cloud-w6.dat"             ) ) file_put_contents("data/widgets/right_sidebar-tags_cloud-w6.dat",              "a:2:{s:8:\"min_hits\";s:2:\"10\";s:13:\"cache_version\";s:1:\"1\";}");
if( ! file_exists("data/widgets/right_sidebar-text-w1.dat"                   ) ) file_put_contents("data/widgets/right_sidebar-text-w1.dat",                    "a:1:{s:8:\"contents\";s:191:\"This is a right sidebar widget called \"Text W1\".<br>\nUse the widgets manager to disable this widget, remove it\nor edit the contents and add\nsome banner code or an image or something cooler :)\";}");
if( ! file_exists("data/widgets/right_sidebar-text-w2.dat"                   ) ) file_put_contents("data/widgets/right_sidebar-text-w2.dat",                    "a:1:{s:8:\"contents\";s:191:\"This is a right sidebar widget called \"Text W2\".<br>\nUse the widgets manager to disable this widget, remove it\nor edit the contents and add\nsome banner code or an image or something cooler :)\";}");
chmod("data/widgets/left_sidebar-archives_tree-patree.dat",        0666);
chmod("data/widgets/left_sidebar-listing-clist.dat",               0666);
chmod("data/widgets/right_sidebar-other_posts_in_category-oc.dat", 0666);
chmod("data/widgets/right_sidebar-popular_posts_fortnight-pq.dat", 0666);
chmod("data/widgets/right_sidebar-searches_cloud-w5.dat",          0666);
chmod("data/widgets/right_sidebar-tags_cloud-w6.dat",              0666);
chmod("data/widgets/right_sidebar-text-w1.dat",                    0666);
chmod("data/widgets/right_sidebar-text-w2.dat",                    0666);

$now   = date("Y-m-d H:i");
$query = <<<EOQ
    INSERT IGNORE INTO `posts`
    (
        `id_post`, `parent_post`, `id_author`, `slug`, `title`,
        `excerpt`, `content`,
        `main_category`, `visibility`, `status`, `password`, `allow_comments`, `pin_to_home`, `pin_to_main_category_index`,
        `creation_date`, `creation_ip`, `creation_host`, `creation_location`,
        `publishing_date`, `expiration_date`, `comments_count`,
        `last_update`, `last_commented`, `id_featured_image`
    ) VALUES (
        5011490054417265, 0, 100000000000000, 'define-your-categories', 'Define your categories!',
        'Login as admin and get to the Categories Editor and define categories for your contents. Check this post for more details.',
        '<p>Login as admin and get to the <a href="/categories/">Categories Editor</a> and define categories for your contents.
            Just be patient with the list on the left sidebar: it has a long cache time to live to improve database performance.
            It is a small cost that you\'ll find rewarding on high loads.</p>',
        '0000000000000', 'public', 'published', '', 1, 0, 0,
        '$now:00', '192.168.1.205', '192.168.1.205', 'n/a; n/a; n/a; n/a',
        '$now:00', '0000-00-00 00:00:00', 0,
        '$now:00', NULL, 0
    ), (
        5011490054864936, 0, 100000000000000, 'tune-the-settings', 'Tune the settings!',
        'Pay a visit to the Settings Page and give yourself some time tuning your BardCanvas website. Chech this post for more details.',
        '<p>Pay a visit to the <a href="/settings/">Settings Page</a> and give yourself some time tuning your BardCanvas website.
            This page is part of the BardCanvas philosophy of keeping things as simple as possible and avoid you wasting time
            trying to figure out where is some thing\'s configuration. You\'ll findÂ <strong>everything</strong> there.</p>',
        '0000000000000', 'public', 'published', '', 1, 0, 0,
        '$now:01', '192.168.1.205', '192.168.1.205', 'n/a; n/a; n/a; n/a',
        '$now:01', '0000-00-00 00:00:00', 0,
        '$now:01', NULL, 0
    ), (
        5011490055007816, 0, 100000000000000, 'thank-you-for-trying-us-out', 'Thank you for trying us out!',
        'We\'re glad to know that our effort is being rewarded with your time. We hope your experience with BardCanvas is good enough for you to keep using it. If you get stuck, don\'t hesitate on going to bardcanvas.com and ask for help.',
        '<p>We\'re glad to know that our effort is being rewarded with your time. We hope your experience with BardCanvas
            is good enough for you to keep using it.</p>\n<p>If you get stuck, don\'t hesitate on going to
            <a href="https://bardcanvas.com" target="_blank">bardcanvas.com</a> and ask for help.</p>',
        '0000000000000', 'public', 'published', '', 1, 0, 0,
        '$now:02', '192.168.1.205', '192.168.1.205', 'n/a; n/a; n/a; n/a',
        '$now:02', '0000-00-00 00:00:00', 0,
        '$now:02', NULL, 0
    ), (
        5011490054242058, 0, 100000000000000, 'welcome-to-bardcanvas', 'Welcome to BardCanvas!',
        'You can easily post stuff by clicking on the Quick Post form (the "What\'s on your mind" link at the top). You can turn it off on the settings editor when logged in as admin or coadmin.',
        '<p>You can easily post stuff by clicking on the Quick Post form (the "What\'s on your mind" link at the top).
            You can turn it off on the <a href="/settings/">settings editor</a> when logged in as admin or coadmin.</p>',
        '0000000000000', 'public', 'published', '', 1, 0, 0,
        '$now:03', '192.168.1.205', '192.168.1.205', 'n/a; n/a; n/a; n/a',
        '$now:03', '0000-00-00 00:00:00', 0,
        '$now:03', NULL, 0
    )
EOQ;
$db->exec($query);
