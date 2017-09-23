<?php
/**
 * Custom HTML for posts
 *
 * @package    BardCanvas
 * @subpackage custom_html_for_posts
 * @author     Alejandro Caballero - lava.caballero@gmail.com
 */

global $config, $template, $post;

if( $template->layout != "main" ) return;
if( $template->get("page_tag") != "single_post" ) return;
if( empty($post) ) return;

$key   = "custom:" . str_replace(".inc", "", basename(__FILE__));
$metas = $post->fetch_all_metas();
if( empty($metas[$key]) ) return;
?>

<!-- BEGIN Custom HTML for posts: <?= $key ?> -->
<?= $metas[$key] ?>

<!-- END Custom HTML for posts: <?= $key ?> -->

