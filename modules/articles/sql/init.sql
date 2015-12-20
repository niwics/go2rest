SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(10) unsigned NOT NULL,
  `category` int(10) unsigned DEFAULT NULL,
  `zone` int(10) unsigned DEFAULT NULL COMMENT 'Comment should lay to the category or to the zone',
  `title` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `perex` text COLLATE utf8_czech_ci COMMENT 'Short page description',
  `text` mediumtext COLLATE utf8_czech_ci,
  `tags` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Tags separated by comma',
  `image1` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL,
  `image2` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL,
  `author` int(10) unsigned NOT NULL,
  `readers` int(11) NOT NULL DEFAULT '0' COMMENT 'Number of views on public website',
  `ratings` int(11) NOT NULL DEFAULT '0' COMMENT 'Number of ratings',
  `ratingsSum` int(11) NOT NULL DEFAULT '0' COMMENT 'Total sum of all ratings',
  `publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Is it visible on the public website?',
  `private` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Private articles are shown on special cases only (based on implemantation details)',
  `datePublished` datetime NOT NULL COMMENT 'Date what will be displayed with this article',
  `dateInserted` datetime NOT NULL COMMENT 'Data of creation of this article',
  `tmpCas` int(30) NOT NULL COMMENT 'Tmp int of timestamp of creation - for pairing with comments',
  `tmpAuthor` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `articlesCategory`;
CREATE TABLE `articlesCategory` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL COMMENT 'Name (title) od the category',
  `allowComments` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Allow comments in articles'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Definition of categories of articles';

DROP TABLE IF EXISTS `pageArticle`;
CREATE TABLE `pageArticle` (
  `id` int(10) unsigned NOT NULL,
  `pageId` int(10) unsigned NOT NULL,
  `articleId` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Reference table between pages and articles';


ALTER TABLE `article`
  ADD PRIMARY KEY (`id`),
  ADD KEY `author` (`author`),
  ADD KEY `category` (`category`),
  ADD KEY `zoneId` (`zone`);

ALTER TABLE `articlesCategory`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pageArticle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `articleId` (`articleId`),
  ADD KEY `pageId_unique` (`pageId`,`articleId`),
  ADD KEY `pageId` (`pageId`);


ALTER TABLE `article`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `articlesCategory`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `pageArticle`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;

ALTER TABLE `article`
  ADD CONSTRAINT `article_ibfk_1` FOREIGN KEY (`author`) REFERENCES `person` (`pid`) ON UPDATE CASCADE,
  ADD CONSTRAINT `article_ibfk_2` FOREIGN KEY (`category`) REFERENCES `articlesCategory` (`id`) ON UPDATE CASCADE;

ALTER TABLE `pageArticle`
  ADD CONSTRAINT `pageArticle_ibfk_1` FOREIGN KEY (`pageId`) REFERENCES `page` (`id`),
  ADD CONSTRAINT `pageArticle_ibfk_2` FOREIGN KEY (`articleId`) REFERENCES `article` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
