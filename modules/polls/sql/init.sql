SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


DROP TABLE IF EXISTS `poll`;
CREATE TABLE `poll` (
  `id` int(10) unsigned NOT NULL,
  `category` int(10) unsigned DEFAULT NULL,
  `title` varchar(48) COLLATE utf8_czech_ci NOT NULL,
  `text` text COLLATE utf8_czech_ci,
  `from` datetime NOT NULL,
  `to` datetime DEFAULT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Can vote not-logged user?',
  `displayResults` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'If true, result will be displayed just before voting'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `pollCategory`;
CREATE TABLE `pollCategory` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(48) COLLATE utf8_czech_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `pollOption`;
CREATE TABLE `pollOption` (
  `id` int(10) unsigned NOT NULL,
  `pollId` int(10) unsigned NOT NULL,
  `title` varchar(48) COLLATE utf8_czech_ci NOT NULL,
  `rank` smallint(5) unsigned DEFAULT '0' COMMENT 'Rank of this option in the poll'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `pollVote`;
CREATE TABLE `pollVote` (
  `id` int(10) unsigned NOT NULL,
  `optionId` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned DEFAULT NULL,
  `ip` varchar(39) COLLATE utf8_czech_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Ove vote from unique user identified by PID+IP or IP';


ALTER TABLE `poll`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`);

ALTER TABLE `pollCategory`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pollOption`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pollId` (`pollId`);

ALTER TABLE `pollVote`
  ADD PRIMARY KEY (`id`),
  ADD KEY `optionId` (`optionId`,`pid`);


ALTER TABLE `poll`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `pollCategory`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `pollOption`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `pollVote`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;

ALTER TABLE `poll`
  ADD CONSTRAINT `poll_ibfk_1` FOREIGN KEY (`category`) REFERENCES `pollCategory` (`id`) ON UPDATE CASCADE;

ALTER TABLE `pollOption`
  ADD CONSTRAINT `pollOption_ibfk_1` FOREIGN KEY (`pollId`) REFERENCES `poll` (`id`) ON UPDATE CASCADE;

ALTER TABLE `pollVote`
  ADD CONSTRAINT `pollVote_ibfk_1` FOREIGN KEY (`optionId`) REFERENCES `pollOption` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
