-- MySQL dump 10.13  Distrib 5.5.57, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: site
-- ------------------------------------------------------
-- Server version	5.5.57-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `user_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'MD5 hash of password',
  `display_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `alt_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `birthdate` date DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `profile_banner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `signature` text COLLATE utf8mb4_unicode_ci,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `homepage_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `country` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ISO code',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `state` enum('new','enabled','disabled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `creation_host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL,
  `last_update` datetime NOT NULL,
  `changelog` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_account`),
  KEY `user_name` (`user_name`(5)),
  KEY `email` (`email`(5)),
  KEY `alt_email` (`alt_email`(5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (100000000000000,'admin','21232f297a57a5a743894a0e4a801fc3','Administrator','nobody@localhost','',NULL,'','',NULL,NULL,'','us',255,'enabled','127.0.0.1; localhost','2017-09-23 02:22:38','2017-09-23 02:22:38','Created on installation\n\n');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_devices`
--

DROP TABLE IF EXISTS `account_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_devices` (
  `id_device` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `device_label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `device_header` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL,
  `state` enum('unregistered','enabled','disabled','deleted') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unregistered',
  `last_activity` datetime NOT NULL,
  PRIMARY KEY (`id_device`),
  KEY `id_account` (`id_account`),
  KEY `account_device` (`id_account`,`id_device`),
  KEY `account_agent` (`id_account`,`device_header`(8))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_devices`
--

LOCK TABLES `account_devices` WRITE;
/*!40000 ALTER TABLE `account_devices` DISABLE KEYS */;
INSERT INTO `account_devices` VALUES (1111506134373491,100000000000000,'N/A','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36','2017-09-23 02:39:33','enabled','2017-09-23 02:54:03');
/*!40000 ALTER TABLE `account_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_engine_prefs`
--

DROP TABLE IF EXISTS `account_engine_prefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_engine_prefs` (
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_account`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_engine_prefs`
--

LOCK TABLES `account_engine_prefs` WRITE;
/*!40000 ALTER TABLE `account_engine_prefs` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_engine_prefs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_logins`
--

DROP TABLE IF EXISTS `account_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_logins` (
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_device` bigint(20) unsigned NOT NULL DEFAULT '0',
  `login_date` datetime NOT NULL,
  `ip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hostname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id_account`,`id_device`,`login_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_logins`
--

LOCK TABLES `account_logins` WRITE;
/*!40000 ALTER TABLE `account_logins` DISABLE KEYS */;
INSERT INTO `account_logins` VALUES (100000000000000,1111506134373491,'2017-09-23 02:39:33','10.0.2.2','10.0.2.2','');
/*!40000 ALTER TABLE `account_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id_category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `parent_category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slug` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `visibility` enum('public','users','level_based') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `min_level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_category`),
  KEY `category_tree` (`id_category`,`parent_category`),
  KEY `by_slug` (`slug`(5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES ('0000000000000','','default','Default category','Uncategorized items','public',0);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_media`
--

DROP TABLE IF EXISTS `comment_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_media` (
  `id_comment` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_comment`,`id_media`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_media`
--

LOCK TABLES `comment_media` WRITE;
/*!40000 ALTER TABLE `comment_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_mentions`
--

DROP TABLE IF EXISTS `comment_mentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_mentions` (
  `id_comment` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_comment`,`id_account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_mentions`
--

LOCK TABLES `comment_mentions` WRITE;
/*!40000 ALTER TABLE `comment_mentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_mentions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_tags`
--

DROP TABLE IF EXISTS `comment_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_tags` (
  `id_comment` bigint(20) unsigned NOT NULL DEFAULT '0',
  `tag` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_comment`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_tags`
--

LOCK TABLES `comment_tags` WRITE;
/*!40000 ALTER TABLE `comment_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_comment` bigint(20) unsigned NOT NULL DEFAULT '0',
  `parent_comment` bigint(20) unsigned NOT NULL DEFAULT '0',
  `parent_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `indent_level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `id_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `author_display_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `author_email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `author_url` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `status` enum('published','reviewing','rejected','spam','hidden','trashed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `creation_date` datetime DEFAULT NULL,
  `creation_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `karma` int(11) NOT NULL DEFAULT '0',
  `last_update` datetime DEFAULT NULL,
  PRIMARY KEY (`id_comment`),
  KEY `comments_tree` (`id_comment`,`parent_comment`),
  KEY `by_author` (`id_author`),
  KEY `by_post` (`id_post`,`status`),
  KEY `by_ip` (`creation_ip`(7)),
  KEY `by_parent_author` (`parent_author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `alpha_2` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `alpha_3` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`alpha_2`),
  KEY `alpha_3` (`alpha_3`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES ('Andorra','ad','and'),('United Arab Emirates','ae','are'),('Afghanistan','af','afg'),('Antigua and Barbuda','ag','atg'),('Anguilla','ai','aia'),('Albania','al','alb'),('Armenia','am','arm'),('Angola','ao','ago'),('Antarctica','aq',''),('Argentina','ar','arg'),('American Samoa','as','asm'),('Austria','at','aut'),('Australia','au','aus'),('Aruba','aw','abw'),('Aland Islands','ax','ala'),('Azerbaijan','az','aze'),('Bosnia and Herzegovina','ba','bih'),('Barbados','bb','brb'),('Bangladesh','bd','bgd'),('Belgium','be','bel'),('Burkina Faso','bf','bfa'),('Bulgaria','bg','bgr'),('Bahrain','bh','bhr'),('Burundi','bi','bdi'),('Benin','bj','ben'),('Saint Barthelemy','bl','blm'),('Bermuda','bm','bmu'),('Brunei Darussalam','bn','brn'),('Bolivia, Plurinational State of','bo','bol'),('Bonaire, Sint Eustatius and Saba','bq','bes'),('Brazil','br','bra'),('Bahamas','bs','bhs'),('Bhutan','bt','btn'),('Bouvet Island','bv',''),('Botswana','bw','bwa'),('Belarus','by','blr'),('Belize','bz','blz'),('Canada','ca','can'),('Cocos (Keeling) Islands','cc',''),('Congo, The Democratic Republic of the','cd','cod'),('Central African Republic','cf','caf'),('Congo','cg','cog'),('Switzerland','ch','che'),('Cote d\'Ivoire','ci','civ'),('Cook Islands','ck','cok'),('Chile','cl','chl'),('Cameroon','cm','cmr'),('China','cn','chn'),('Colombia','co','col'),('Costa Rica','cr','cri'),('Cuba','cu','cub'),('Cape Verde','cv','cpv'),('Curacao','cw','cuw'),('Christmas Island','cx',''),('Cyprus','cy','cyp'),('Czech Republic','cz','cze'),('Germany','de','deu'),('Djibouti','dj','dji'),('Denmark','dk','dnk'),('Dominica','dm','dma'),('Dominican Republic','do','dom'),('Algeria','dz','dza'),('Ecuador','ec','ecu'),('Estonia','ee','est'),('Egypt','eg','egy'),('Western Sahara','eh','esh'),('Eritrea','er','eri'),('Spain','es','esp'),('Ethiopia','et','eth'),('Finland','fi','fin'),('Fiji','fj','fji'),('Falkland Islands (Malvinas)','fk','flk'),('Micronesia, Federated States of','fm','fsm'),('Faroe Islands','fo','fro'),('France','fr','fra'),('Gabon','ga','gab'),('United Kingdom','gb','gbr'),('Grenada','gd','grd'),('Georgia','ge','geo'),('French Guiana','gf','guf'),('Guernsey','gg','ggy'),('Ghana','gh','gha'),('Gibraltar','gi','gib'),('Greenland','gl','grl'),('Gambia','gm','gmb'),('Guinea','gn','gin'),('Guadeloupe','gp','glp'),('Equatorial Guinea','gq','gnq'),('Greece','gr','grc'),('South Georgia and The South Sandwich Islands','gs',''),('Guatemala','gt','gtm'),('Guam','gu','gum'),('Guinea-Bissau','gw','gnb'),('Guyana','gy','guy'),('Hong Kong','hk','hkg'),('Heard Island and McDonald Islands','hm',''),('Honduras','hn','hnd'),('Croatia','hr','hrv'),('Haiti','ht','hti'),('Hungary','hu','hun'),('Indonesia','id','idn'),('Ireland','ie','irl'),('Israel','il','isr'),('Isle of Man','im','imn'),('India','in','ind'),('British Indian Ocean Territory','io',''),('Iraq','iq','irq'),('Iran, Islamic Republic of','ir','irn'),('Iceland','is','isl'),('Italy','it','ita'),('Jersey','je','jey'),('Jamaica','jm','jam'),('Jordan','jo','jor'),('Japan','jp','jpn'),('Kenya','ke','ken'),('Kyrgyzstan','kg','kgz'),('Cambodia','kh','khm'),('Kiribati','ki','kir'),('Comoros','km','com'),('Saint Kitts and Nevis','kn','kna'),('Korea, Democratic People\'s Republic of','kp','prk'),('Korea, Republic of','kr','kor'),('Kuwait','kw','kwt'),('Cayman Islands','ky','cym'),('Kazakhstan','kz','kaz'),('Lao People\'s Democratic Republic','la','lao'),('Lebanon','lb','lbn'),('Saint Lucia','lc','lca'),('Liechtenstein','li','lie'),('Sri Lanka','lk','lka'),('Liberia','lr','lbr'),('Lesotho','ls','lso'),('Lithuania','lt','ltu'),('Luxembourg','lu','lux'),('Latvia','lv','lva'),('Libyan Arab Jamahiriya','ly','lby'),('Morocco','ma','mar'),('Monaco','mc','mco'),('Moldova, Republic of','md','mda'),('Montenegro','me','mne'),('Saint Martin (French Part)','mf','maf'),('Madagascar','mg','mdg'),('Marshall Islands','mh','mhl'),('Macedonia, The former Yugoslav Republic of','mk','mkd'),('Mali','ml','mli'),('Myanmar','mm','mmr'),('Mongolia','mn','mng'),('Macao','mo','mac'),('Northern Mariana Islands','mp','mnp'),('Martinique','mq','mtq'),('Mauritania','mr','mrt'),('Montserrat','ms','msr'),('Malta','mt','mlt'),('Mauritius','mu','mus'),('Maldives','mv','mdv'),('Malawi','mw','mwi'),('Mexico','mx','mex'),('Malaysia','my','mys'),('Mozambique','mz','moz'),('Namibia','na','nam'),('New Caledonia','nc','ncl'),('Niger','ne','ner'),('Norfolk Island','nf','nfk'),('Nigeria','ng','nga'),('Nicaragua','ni','nic'),('Netherlands','nl','nld'),('Norway','no','nor'),('Nepal','np','npl'),('Nauru','nr','nru'),('Niue','nu','niu'),('New Zealand','nz','nzl'),('Oman','om','omn'),('Panama','pa','pan'),('Peru','pe','per'),('French Polynesia','pf','pyf'),('Papua New Guinea','pg','png'),('Philippines','ph','phl'),('Pakistan','pk','pak'),('Poland','pl','pol'),('Saint Pierre and Miquelon','pm','spm'),('Pitcairn','pn','pcn'),('Puerto Rico','pr','pri'),('Palestinian Territory, Occupied','ps','pse'),('Portugal','pt','prt'),('Palau','pw','plw'),('Paraguay','py','pry'),('Qatar','qa','qat'),('Reunion','re','reu'),('Romania','ro','rou'),('Serbia','rs','srb'),('Russian Federation','ru','rus'),('Rwanda','rw','rwa'),('Saudi Arabia','sa','sau'),('Solomon Islands','sb','slb'),('Seychelles','sc','syc'),('Sudan','sd','sdn'),('Sweden','se','swe'),('Singapore','sg','sgp'),('Saint Helena, Ascension and Tristan Da Cunha','sh','shn'),('Slovenia','si','svn'),('Svalbard and Jan Mayen','sj','sjm'),('Slovakia','sk','svk'),('Sierra Leone','sl','sle'),('San Marino','sm','smr'),('Senegal','sn','sen'),('Somalia','so','som'),('Suriname','sr','sur'),('South Sudan','ss','ssd'),('Sao Tome and Principe','st','stp'),('El Salvador','sv','slv'),('Sint Maarten (Dutch Part)','sx','sxm'),('Syrian Arab Republic','sy','syr'),('Swaziland','sz','swz'),('Turks and Caicos Islands','tc','tca'),('Chad','td','tcd'),('French Southern Territories','tf',''),('Togo','tg','tgo'),('Thailand','th','tha'),('Tajikistan','tj','tjk'),('Tokelau','tk','tkl'),('Timor-Leste','tl','tls'),('Turkmenistan','tm','tkm'),('Tunisia','tn','tun'),('Tonga','to','ton'),('Turkey','tr','tur'),('Trinidad and Tobago','tt','tto'),('Tuvalu','tv','tuv'),('Taiwan, Province of China','tw',''),('Tanzania, United Republic of','tz','tza'),('Ukraine','ua','ukr'),('Uganda','ug','uga'),('United States Minor Outlying Islands','um',''),('United States','us','usa'),('Uruguay','uy','ury'),('Uzbekistan','uz','uzb'),('Holy See (Vatican City State)','va','vat'),('Saint Vincent and The Grenadines','vc','vct'),('Venezuela, Bolivarian Republic of','ve','ven'),('Virgin Islands, British','vg','vgb'),('Virgin Islands, U.S.','vi','vir'),('Viet Nam','vn','vnm'),('Vanuatu','vu','vut'),('Wallis and Futuna','wf','wlf'),('Samoa','ws','wsm'),('Yemen','ye','yem'),('Mayotte','yt','myt'),('South Africa','za','zaf'),('Zambia','zm','zmb'),('Zimbabwe','zw','zwe');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mime_type` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dimensions` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `size` int(10) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_unicode_ci,
  `main_category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `visibility` enum('public','private','users','friends','level_based') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `status` enum('draft','published','reviewing','hidden','trashed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `allow_comments` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `creation_date` datetime DEFAULT NULL,
  `creation_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `publishing_date` datetime DEFAULT NULL,
  `comments_count` int(10) unsigned NOT NULL DEFAULT '0',
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_update` datetime DEFAULT NULL,
  `last_commented` datetime DEFAULT NULL,
  PRIMARY KEY (`id_media`),
  KEY `by_path` (`path`(5)),
  KEY `by_author` (`id_author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_categories`
--

DROP TABLE IF EXISTS `media_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_categories` (
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_media`,`id_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_categories`
--

LOCK TABLES `media_categories` WRITE;
/*!40000 ALTER TABLE `media_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_mentions`
--

DROP TABLE IF EXISTS `media_mentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_mentions` (
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_media`,`id_account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_mentions`
--

LOCK TABLES `media_mentions` WRITE;
/*!40000 ALTER TABLE `media_mentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_mentions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_tags`
--

DROP TABLE IF EXISTS `media_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_tags` (
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `tag` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_media`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_tags`
--

LOCK TABLES `media_tags` WRITE;
/*!40000 ALTER TABLE `media_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_views`
--

DROP TABLE IF EXISTS `media_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_views` (
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `views` int(10) unsigned NOT NULL DEFAULT '0',
  `last_viewed` datetime DEFAULT NULL,
  PRIMARY KEY (`id_media`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_views`
--

LOCK TABLES `media_views` WRITE;
/*!40000 ALTER TABLE `media_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_categories`
--

DROP TABLE IF EXISTS `post_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_categories` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_post`,`id_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_categories`
--

LOCK TABLES `post_categories` WRITE;
/*!40000 ALTER TABLE `post_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_media`
--

DROP TABLE IF EXISTS `post_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_media` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_media` bigint(20) unsigned NOT NULL DEFAULT '0',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_post`,`id_media`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_media`
--

LOCK TABLES `post_media` WRITE;
/*!40000 ALTER TABLE `post_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_mentions`
--

DROP TABLE IF EXISTS `post_mentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_mentions` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_account` bigint(20) unsigned NOT NULL DEFAULT '0',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_post`,`id_account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_mentions`
--

LOCK TABLES `post_mentions` WRITE;
/*!40000 ALTER TABLE `post_mentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_mentions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_meta`
--

DROP TABLE IF EXISTS `post_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_meta` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_post`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_meta`
--

LOCK TABLES `post_meta` WRITE;
/*!40000 ALTER TABLE `post_meta` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_tags`
--

DROP TABLE IF EXISTS `post_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_tags` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `tag` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_attached` datetime DEFAULT NULL,
  `order_attached` double unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_post`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_tags`
--

LOCK TABLES `post_tags` WRITE;
/*!40000 ALTER TABLE `post_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_views`
--

DROP TABLE IF EXISTS `post_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_views` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `views` int(10) unsigned NOT NULL DEFAULT '0',
  `last_viewed` datetime DEFAULT NULL,
  PRIMARY KEY (`id_post`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_views`
--

LOCK TABLES `post_views` WRITE;
/*!40000 ALTER TABLE `post_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `parent_post` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `slug` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `excerpt` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `main_category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `visibility` enum('public','private','users','friends','level_based') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `status` enum('draft','published','reviewing','hidden','trashed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `allow_comments` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `pin_to_home` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `pin_to_main_category_index` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `creation_date` datetime DEFAULT NULL,
  `creation_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creation_location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `publishing_date` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `comments_count` int(10) unsigned NOT NULL DEFAULT '0',
  `last_update` datetime DEFAULT NULL,
  `last_commented` datetime DEFAULT NULL,
  `id_featured_image` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_post`),
  KEY `posts_tree` (`id_post`,`parent_post`),
  KEY `by_slug` (`slug`(5)),
  KEY `by_author` (`id_author`),
  KEY `by_ip` (`creation_ip`(7))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (5011490054242058,0,100000000000000,'welcome-to-bardcanvas','Welcome to BardCanvas!','You can easily post stuff by clicking on the Quick Post form (the \"What\'s on your mind\" link at the top). You can turn it off on the settings editorÂ when logged in as admin or coadmin.','<p>You can easily post stuff by clicking on the Quick Post form (the \"What\'s on your mind\" link at the top).\n            You can turn it off on the <a href=\"/settings/\">settings editor</a>Â when logged in as admin or coadmin.</p>','0000000000000','public','published','',1,0,0,'2017-09-23 02:22:03','192.168.1.205','192.168.1.205','n/a; n/a; n/a; n/a','2017-09-23 02:22:03','0000-00-00 00:00:00',0,'2017-09-23 02:22:03',NULL,0),(5011490054417265,0,100000000000000,'define-your-categories','Define your categories!','Login as admin and get to the Categories Editor and define categories for your contents. Check this post for more details.','<p>Login as admin and get to the <a href=\"/categories/\">Categories Editor</a>Â and define categories for your contents.\n            Just be patient with the list on the left sidebar: it has a long cache time to live to improve database performance.\n            It is a small cost that you\'ll find rewarding on high loads.</p>','0000000000000','public','published','',1,0,0,'2017-09-23 02:22:00','192.168.1.205','192.168.1.205','n/a; n/a; n/a; n/a','2017-09-23 02:22:00','0000-00-00 00:00:00',0,'2017-09-23 02:22:00',NULL,0),(5011490054864936,0,100000000000000,'tune-the-settings','Tune the settings!','Pay a visit to the Settings Page and give yourself some time tuning your BardCanvas website. Chech this post for more details.','<p>Pay a visit to the <a href=\"/settings/\">Settings Page</a> and give yourself some time tuning your BardCanvas website.\n            This page is part of the BardCanvas philosophy of keeping things as simple as possible and avoid you wasting time\n            trying to figure out where is some thing\'s configuration. You\'ll findÃ‚Â <strong>everything</strong> there.</p>','0000000000000','public','published','',1,0,0,'2017-09-23 02:22:01','192.168.1.205','192.168.1.205','n/a; n/a; n/a; n/a','2017-09-23 02:22:01','0000-00-00 00:00:00',0,'2017-09-23 02:22:01',NULL,0),(5011490055007816,0,100000000000000,'thank-you-for-trying-us-out','Thank you for trying us out!','We\'re glad to know that our effort is being rewarded with your time. We hope your experience with BardCanvas is good enough for you to keep using it. If you get stuck, don\'t hesitate on going to bardcanvas.com and ask for help.','<p>We\'re glad to know that our effort is being rewarded with your time. We hope your experience with BardCanvas\n            is good enough for you to keep using it.</p>\n<p>If you get stuck, don\'t hesitate on going to\n            <a href=\"https://bardcanvas.com\" target=\"_blank\">bardcanvas.com</a> and ask for help.</p>','0000000000000','public','published','',1,0,0,'2017-09-23 02:22:02','192.168.1.205','192.168.1.205','n/a; n/a; n/a; n/a','2017-09-23 02:22:02','0000-00-00 00:00:00',0,'2017-09-23 02:22:02',NULL,0);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_history`
--

DROP TABLE IF EXISTS `search_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_history` (
  `terms` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hits` bigint(20) unsigned NOT NULL DEFAULT '0',
  `last_hit` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`terms`,`last_hit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_history`
--

LOCK TABLES `search_history` WRITE;
/*!40000 ALTER TABLE `search_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `search_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` mediumtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('engine.default_language','en_US'),('engine.enabled','true'),('engine.mail_sender_email','nobody@localhost'),('engine.mail_sender_name','BardCanvas Notifier'),('engine.template','base'),('engine.user_levels','0 - Unregistered\n1 - Unconfirmed\n10 - Newcomer\n100 - Author\n150 - VIP\n200 - Editor\n240 - Coadmin\n255 - Admin'),('engine.user_online_cookie','_BCOC618'),('engine.user_session_cookie','_BCSC618'),('engine.website_name','New BardCanvas Website'),('modules:accounts.disable_registrations_widget','false'),('modules:accounts.enabled','true'),('modules:accounts.enforce_device_registration','false'),('modules:accounts.installed','true'),('modules:accounts.register_enabled','false'),('modules:basic_ad_injections.enabled','true'),('modules:basic_ad_injections.installed','true'),('modules:bc_customizable_header.enabled','true'),('modules:bc_customizable_header.icon_caption','My BC Website'),('modules:bc_customizable_header.installed','true'),('modules:bc_customizable_header.site_legend','A place for those that seek<br>The Answer to the Great Question of Life,<br>the Universe and Everything'),('modules:categories.enabled','true'),('modules:categories.installed','true'),('modules:comments.disable_new_after','90'),('modules:comments.enabled','true'),('modules:comments.installed','true'),('modules:comments.items_per_index_entry','10'),('modules:comments.items_per_page','20'),('modules:comments.show_in_indexes','true'),('modules:contact.enabled','true'),('modules:contact.installed','true'),('modules:emojione_for_bardcanvas.enabled','true'),('modules:emojione_for_bardcanvas.installed','true'),('modules:gallery.enabled','true'),('modules:gallery.installed','true'),('modules:giphy_for_bardcanvas.enabled','true'),('modules:giphy_for_bardcanvas.installed','true'),('modules:log_viewer.enabled','true'),('modules:log_viewer.for_admins_only','true'),('modules:log_viewer.installed','true'),('modules:moderation.enabled','true'),('modules:moderation.installed','true'),('modules:modules_manager.disable_cache','true'),('modules:modules_manager.enabled','true'),('modules:modules_manager.installed','true'),('modules:posts.enabled','true'),('modules:posts.excerpt_length','250'),('modules:posts.installed','true'),('modules:posts.level_allowed_to_edit_custom_fields','200'),('modules:posts.meta_table_created_v2','true'),('modules:search.enabled','true'),('modules:search.installed','true'),('modules:settings.enabled','true'),('modules:settings.installed','true'),('modules:twitter_cards.card_type','summary'),('modules:twitter_cards.enabled','true'),('modules:twitter_cards.image_size','mobile-retina'),('modules:twitter_cards.installed','true'),('modules:twitter_cards.render_on_media','true'),('modules:twitter_cards.render_on_posts','true'),('modules:updates_client.enabled','true'),('modules:updates_client.installed','true'),('modules:widgets_manager.enabled','true'),('modules:widgets_manager.installed','true'),('modules:widgets_manager.ls_layout','accounts.meta       | ameta0  | Access     | offline | show |\naccounts.meta       | ameta1  |            | online  | show |\ncategories.listing  | clist   | Categories | all     | show |\nposts.archives_tree | patree  | Archives   | all     | show |'),('modules:widgets_manager.rs_layout','widgets_manager.text           | w1 | Customize this area!             | all | show | \naccounts.login                 | w3 | Access                           | all | show | \nsearch.search                  | w4 |                                  | all | hide | search_results\nposts.other_posts_in_category  | oc | Other posts in this category     | all | show | single_post\nsearch.searches_cloud          | w5 | Popular searches                 | all | show | \nsearch.tags_cloud              | w6 | Popular tags                     | all | show | \n#posts.popular_posts_fortnight  | pq | Popular posts                    | all | show | home,search_results\nwidgets_manager.text           | w2 | Customize this area!             | all | show |'),('modules:youtube_for_bardcanvas.enabled','true'),('modules:youtube_for_bardcanvas.installed','true');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-09-23  2:54:05
