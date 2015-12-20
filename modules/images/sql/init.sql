SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP TABLE IF EXISTS `gallery`;
CREATE TABLE `gallery` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8_czech_ci NOT NULL,
  `description` text COLLATE utf8_czech_ci,
  `author` int(10) unsigned NOT NULL,
  `path` varchar(255) COLLATE utf8_czech_ci NOT NULL COMMENT 'System path to images (from ROOT_PATH)',
  `resizedWidth` smallint(5) unsigned DEFAULT NULL COMMENT 'If not set, the original width will be used',
  `resizedHeight` smallint(5) unsigned DEFAULT NULL COMMENT 'If not set, the original height will be used',
  `thumbnailWidth` smallint(5) unsigned NOT NULL,
  `thumbnailHeight` smallint(5) unsigned NOT NULL,
  `cropThumbnails` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Allow to crop thumbnails to provide the same dimensions for all thumbnails',
  `titlesInMatrixPosition` enum('none','top','bottom') COLLATE utf8_czech_ci NOT NULL DEFAULT 'bottom' COMMENT 'Whether and where to display image titles in index matrix',
  `coverImage` int(10) unsigned DEFAULT NULL COMMENT 'Reference to the image from gallery which will be used as cover',
  `coverSpecial` varchar(128) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Filename of the image which is is not in gallery. It will be used as cover and will be stored in "cover" subdirectory',
  `coverWidth` smallint(5) DEFAULT NULL,
  `coverHeight` smallint(5) unsigned DEFAULT NULL,
  `cropCover` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Allow to crop cover to the given dimensions',
  `datetime` datetime NOT NULL COMMENT 'Date of photos in this gallery',
  `publish` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Images gallery';

DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `id` int(10) unsigned NOT NULL,
  `galleryId` int(10) unsigned DEFAULT NULL COMMENT 'Gallery ID for IG images, else NULL',
  `rank` smallint(5) unsigned NOT NULL,
  `path` varchar(255) COLLATE utf8_czech_ci NOT NULL COMMENT 'Cannot be NULL because of unique key',
  `filename` varchar(128) COLLATE utf8_czech_ci NOT NULL COMMENT 'File name (without path)',
  `title` varchar(64) COLLATE utf8_czech_ci DEFAULT NULL,
  `description` text COLLATE utf8_czech_ci,
  `visits` int(10) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Common image';

DROP TABLE IF EXISTS `imageVisit`;
CREATE TABLE `imageVisit` (
  `id` int(10) unsigned NOT NULL,
  `visitId` int(10) unsigned NOT NULL,
  `imageId` int(10) unsigned NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


ALTER TABLE `gallery`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `path` (`path`),
  ADD KEY `author` (`author`),
  ADD KEY `coverImage` (`coverImage`);

ALTER TABLE `image`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `filenamePathAndGallery` (`galleryId`,`filename`,`path`),
  ADD UNIQUE KEY `galleryAndRank` (`galleryId`,`rank`),
  ADD KEY `galleryId` (`galleryId`);

ALTER TABLE `imageVisit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `imageId` (`imageId`),
  ADD KEY `visitId` (`visitId`);


ALTER TABLE `gallery`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `image`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `imageVisit`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;

ALTER TABLE `gallery`
  ADD CONSTRAINT `gallery_ibfk_1` FOREIGN KEY (`author`) REFERENCES `user` (`pid`),
  ADD CONSTRAINT `gallery_ibfk_2` FOREIGN KEY (`coverImage`) REFERENCES `image` (`id`) ON DELETE SET NULL;

ALTER TABLE `image`
  ADD CONSTRAINT `image_ibfk_1` FOREIGN KEY (`galleryId`) REFERENCES `gallery` (`id`);

ALTER TABLE `imageVisit`
  ADD CONSTRAINT `imageVisit_ibfk_1` FOREIGN KEY (`visitId`) REFERENCES `visit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `imageVisit_ibfk_2` FOREIGN KEY (`imageId`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
