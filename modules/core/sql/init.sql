SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(10) unsigned NOT NULL,
  `type` enum('page','article','gallery','ticket','rand-photo') COLLATE utf8_czech_ci NOT NULL DEFAULT 'page' COMMENT 'Type of the comment: to page, gallery, article... (determines the sense of the next column - ref)',
  `ref` int(10) unsigned DEFAULT NULL COMMENT 'Points to the ID of section, article, gallery, page...',
  `pid` int(10) unsigned DEFAULT NULL COMMENT 'Author of this article',
  `author` varchar(31) COLLATE utf8_czech_ci DEFAULT NULL,
  `title` varchar(31) COLLATE utf8_czech_ci DEFAULT NULL,
  `content` text COLLATE utf8_czech_ci NOT NULL,
  `dateInserted` datetime NOT NULL COMMENT 'Datetime of insertion',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tmpClanek` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Table for all types of comments';

DROP TABLE IF EXISTS `error404`;
CREATE TABLE `error404` (
  `id` int(10) unsigned NOT NULL,
  `url` varchar(127) COLLATE utf8_czech_ci NOT NULL,
  `sectionId` int(10) unsigned NOT NULL,
  `ip` char(41) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'IP adress of visit',
  `browser` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Logging the 404 error';

DROP TABLE IF EXISTS `errorLog`;
CREATE TABLE `errorLog` (
  `id` int(10) NOT NULL,
  `timestamp` datetime NOT NULL COMMENT 'Date and time of the error',
  `title` tinytext COLLATE utf8_czech_ci NOT NULL COMMENT 'Error title',
  `detail` tinytext COLLATE utf8_czech_ci COMMENT 'Other parameter and description',
  `priority` smallint(1) NOT NULL COMMENT '1-lowest, 5-highest',
  `backtrace` text COLLATE utf8_czech_ci COMMENT 'Calls stack with calling files, lines, classes and functions. Calls in Error and ErrorHandler classes are excluded',
  `queryDump` text COLLATE utf8_czech_ci NOT NULL COMMENT 'Dump of all queries of this page',
  `request` text COLLATE utf8_czech_ci COMMENT '$_REQUEST array from PHP',
  `visitId` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `id` int(10) unsigned NOT NULL,
  `type` enum('insert','update','delete') COLLATE utf8_czech_ci NOT NULL DEFAULT 'insert' COMMENT 'Type of preformed action',
  `table` varchar(31) COLLATE utf8_czech_ci NOT NULL,
  `recordId` varchar(31) COLLATE utf8_czech_ci NOT NULL,
  `pid` int(10) unsigned DEFAULT NULL COMMENT 'Person who made this change',
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of change - but not timestamp of this record!'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Main history table';

DROP TABLE IF EXISTS `historyRecord`;
CREATE TABLE `historyRecord` (
  `historyId` int(10) unsigned NOT NULL,
  `column` varchar(31) COLLATE utf8_czech_ci NOT NULL,
  `value` text COLLATE utf8_czech_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `menuItem`;
CREATE TABLE `menuItem` (
  `id` int(10) unsigned NOT NULL,
  `pageId` int(10) unsigned NOT NULL,
  `websiteId` int(10) unsigned NOT NULL COMMENT 'Website in wich this page is placed',
  `url` varchar(255) COLLATE utf8_czech_ci NOT NULL COMMENT 'Path in the website menu structure + name',
  `rank` tinyint(3) NOT NULL DEFAULT '1' COMMENT 'The rank of this page in the list of subitems of the parent menu'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Menu items in the website';

DROP TABLE IF EXISTS `page`;
CREATE TABLE `page` (
  `id` int(10) unsigned NOT NULL,
  `title` char(255) COLLATE utf8_czech_ci NOT NULL DEFAULT '',
  `menuTitle` varchar(32) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Short title, used for the menu title etc.',
  `perex` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Short page''s content description.',
  `content` mediumtext COLLATE utf8_czech_ci,
  `metaDescription` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Page description for META HTML tag',
  `linkOutside` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'If this flag is selected, this page ill be redirected to the selected URL',
  `sectionId` int(10) unsigned DEFAULT NULL COMMENT 'Section in which this page belongs',
  `controller` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Path to the controller. NULL means the BasicController',
  `mainController` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Path to the main controller. NULL means dafualt.',
  `readPermission` tinyint(1) unsigned DEFAULT NULL,
  `writePermission` tinyint(1) unsigned DEFAULT NULL,
  `params` varchar(127) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Optional parametres for controllers (Discussion ID etc.)',
  `visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Invisible pages aren''t visible in the menu, but they are accessible',
  `accessible` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Inaccessiblee pages aren''t visible in the menu and they aren''t accessible through URL',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Pages - URLs (menu items)';

DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `id` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `sectionId` int(10) unsigned DEFAULT NULL COMMENT 'Superadmin has only one record for all websites automatically',
  `permission` tinyint(1) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `person`;
CREATE TABLE `person` (
  `pid` int(10) unsigned NOT NULL COMMENT 'main person ID in the evidence',
  `name` varchar(127) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Typically surename',
  `secondaryName` varchar(127) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Typically given name',
  `titleBefore` varchar(10) COLLATE utf8_czech_ci DEFAULT NULL,
  `titleAfter` varchar(10) COLLATE utf8_czech_ci DEFAULT NULL,
  `email` varchar(127) COLLATE utf8_czech_ci DEFAULT NULL,
  `type` enum('normal','testing','dummy') COLLATE utf8_czech_ci NOT NULL DEFAULT 'normal' COMMENT 'Type of the person - normal, testing, dummy',
  `dataSource` int(10) unsigned NOT NULL DEFAULT '50' COMMENT 'Type of data source',
  `sourceWebsite` int(10) unsigned DEFAULT NULL COMMENT 'Web from which was person registered (when dataSource is ''registration'')',
  `insertionDate` datetime NOT NULL,
  `profileViews` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of views of user''''s profile page',
  `systemState` enum('active','inactive','deleted') COLLATE utf8_czech_ci NOT NULL DEFAULT 'active' COMMENT 'System state',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci ROW_FORMAT=COMPACT;

DROP TABLE IF EXISTS `personDetail`;
CREATE TABLE `personDetail` (
  `pid` int(10) unsigned NOT NULL DEFAULT '0',
  `correspondentNumber` int(10) unsigned DEFAULT NULL COMMENT 'Dopisovatelske cislo a zaroven ID ze stare databze clenu SPJF',
  `memberNumber` int(10) unsigned DEFAULT NULL COMMENT 'SPJF member number',
  `dateOfBirth` date DEFAULT NULL,
  `sex` enum('M','W') COLLATE utf8_czech_ci DEFAULT NULL,
  `image` varchar(512) COLLATE utf8_czech_ci DEFAULT NULL,
  `description` text COLLATE utf8_czech_ci,
  `nicks` varchar(128) COLLATE utf8_czech_ci DEFAULT NULL,
  `city` varchar(63) COLLATE utf8_czech_ci DEFAULT NULL,
  `street` varchar(63) COLLATE utf8_czech_ci DEFAULT NULL,
  `houseNumber` varchar(7) COLLATE utf8_czech_ci DEFAULT NULL,
  `zip` varchar(5) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Post code',
  `country` char(3) COLLATE utf8_czech_ci DEFAULT 'ČR',
  `phone` varchar(16) COLLATE utf8_czech_ci DEFAULT NULL,
  `facebook` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Facebook address',
  `im` varchar(63) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'ICQ or jabber etc.',
  `skype` varchar(31) COLLATE utf8_czech_ci DEFAULT NULL,
  `website` varchar(127) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Person homepage',
  `secondaryEmail` varchar(128) COLLATE utf8_czech_ci DEFAULT NULL,
  `BScount` tinyint(4) DEFAULT NULL COMMENT 'Number of BS journals to deliver',
  `BStoDate` date DEFAULT NULL COMMENT 'Date until BS should be delivered (independent from membership)',
  `money` mediumint(7) DEFAULT NULL COMMENT 'Aktualni preplatek',
  `donation` mediumint(7) unsigned DEFAULT NULL COMMENT 'Penezni dar, ktery osoba SPJF venovala',
  `tmpLastVisit` datetime DEFAULT NULL COMMENT 'Las visit date from iKlubovna',
  `tmpClub` int(11) DEFAULT NULL COMMENT 'Club number from old iKlubovna',
  `note` text COLLATE utf8_czech_ci,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `personSetting`;
CREATE TABLE `personSetting` (
  `id` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `key` varchar(32) COLLATE utf8_czech_ci NOT NULL COMMENT 'Setting name',
  `value` text COLLATE utf8_czech_ci COMMENT 'Setting value'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Stores personal settings';
DROP VIEW IF EXISTS `personView`;
CREATE TABLE `personView` (
`pid` int(10) unsigned
,`username` char(127)
,`fullName` varchar(255)
,`name` varchar(127)
,`secondaryName` varchar(127)
,`titleBefore` varchar(10)
,`titleAfter` varchar(10)
,`email` varchar(127)
,`dataSource` varchar(63)
,`sourceWebsite` char(255)
,`insertionDate` datetime
,`profileViews` int(10) unsigned
,`systemState` enum('active','inactive','deleted')
,`city` varchar(63)
,`street` varchar(63)
,`houseNumber` varchar(7)
,`zip` varchar(5)
,`country` char(3)
,`description` text
,`note` text
,`urlName` varchar(64)
,`registrationDate` datetime
,`correspondentNumber` int(10) unsigned
,`memberNumber` int(10) unsigned
,`sex` enum('M','W')
,`dateOfBirth` date
,`nicks` varchar(128)
,`secondaryEmail` varchar(128)
,`phone` varchar(16)
,`facebook` varchar(256)
,`im` varchar(63)
,`skype` varchar(31)
,`website` varchar(127)
,`image` varchar(512)
);

DROP TABLE IF EXISTS `section`;
CREATE TABLE `section` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(32) COLLATE utf8_czech_ci NOT NULL,
  `description` varchar(512) COLLATE utf8_czech_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Permissions are related to sections. To sections belongs pag';

DROP TABLE IF EXISTS `TOK`;
CREATE TABLE `TOK` (
  `key` int(10) unsigned NOT NULL,
  `value` varchar(63) COLLATE utf8_czech_ci NOT NULL,
  `type` char(2) COLLATE utf8_czech_ci NOT NULL COMMENT 'Bref of the corresponding group'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Table of keys';

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `pid` int(10) unsigned NOT NULL,
  `username` char(127) COLLATE utf8_czech_ci NOT NULL COMMENT 'User login name',
  `urlName` varchar(64) COLLATE utf8_czech_ci NOT NULL COMMENT 'Unique identifier for URL',
  `password` char(40) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'User password',
  `systemPassword` varchar(40) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Password for the system (admin) server',
  `registrationDate` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='RS user';

DROP TABLE IF EXISTS `visit`;
CREATE TABLE `visit` (
  `id` int(10) unsigned NOT NULL COMMENT 'ID of visit',
  `pid` int(10) unsigned DEFAULT NULL COMMENT 'Person wich has logged-in',
  `realPid` int(10) unsigned DEFAULT NULL COMMENT 'PID of real admin-user who is masked',
  `websiteId` int(10) unsigned NOT NULL,
  `ip` char(41) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'IP adress of visit',
  `browser` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time of last page loaded'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Table of persons log-ins to the system';

DROP TABLE IF EXISTS `visitByDay`;
CREATE TABLE `visitByDay` (
  `date` date NOT NULL,
  `pageId` int(10) unsigned NOT NULL,
  `visits` int(10) NOT NULL COMMENT 'Visit count'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Data cube for page visits by day';

DROP TABLE IF EXISTS `visitByUser`;
CREATE TABLE `visitByUser` (
  `timestamp` datetime NOT NULL,
  `websiteId` int(10) unsigned NOT NULL DEFAULT '0',
  `pid` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `visitPage`;
CREATE TABLE `visitPage` (
  `visitId` int(10) unsigned NOT NULL COMMENT 'Reference visit.id',
  `menuItemId` int(10) unsigned NOT NULL,
  `tailAndSpice` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Meaningful end of URL (tail and spice parameters)',
  `request` text COLLATE utf8_czech_ci COMMENT 'Dump of GET, POST and SESSION variables',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `website`;
CREATE TABLE `website` (
  `id` int(10) unsigned NOT NULL,
  `name` char(255) COLLATE utf8_czech_ci NOT NULL,
  `protocol` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 means http; 1 https protocol',
  `title` varchar(64) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Title of website will be displayed as the end fragment of each page',
  `systemMail` varchar(64) COLLATE utf8_czech_ci NOT NULL COMMENT 'System mail for contacting administrators and from which all system e-mails will be send',
  `googleAnalyticsId` varchar(16) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'ID from Google Analytics for automatic inclusion of GA measuring code.',
  `controllers` text COLLATE utf8_czech_ci COMMENT 'Available cotrollers in website (separated by "\\n"). Autogenerated from PageEditor class'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Web section (ex. "admin.domain.com")';
DROP TABLE IF EXISTS `personView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`a8095_niwi`@`%` SQL SECURITY DEFINER VIEW `personView` AS select `p`.`pid` AS `pid`,`u`.`username` AS `username`,(concat_ws(' ',if((`p`.`secondaryName` = ''),NULL,`p`.`secondaryName`),if((`p`.`name` = ''),NULL,`p`.`name`)) collate utf8_czech_ci) AS `fullName`,`p`.`name` AS `name`,`p`.`secondaryName` AS `secondaryName`,`p`.`titleBefore` AS `titleBefore`,`p`.`titleAfter` AS `titleAfter`,`p`.`email` AS `email`,`t`.`value` AS `dataSource`,`w`.`name` AS `sourceWebsite`,`p`.`insertionDate` AS `insertionDate`,`p`.`profileViews` AS `profileViews`,`p`.`systemState` AS `systemState`,`d`.`city` AS `city`,`d`.`street` AS `street`,`d`.`houseNumber` AS `houseNumber`,`d`.`zip` AS `zip`,`d`.`country` AS `country`,`d`.`description` AS `description`,`d`.`note` AS `note`,`u`.`urlName` AS `urlName`,`u`.`registrationDate` AS `registrationDate`,`d`.`correspondentNumber` AS `correspondentNumber`,`d`.`memberNumber` AS `memberNumber`,`d`.`sex` AS `sex`,`d`.`dateOfBirth` AS `dateOfBirth`,`d`.`nicks` AS `nicks`,`d`.`secondaryEmail` AS `secondaryEmail`,`d`.`phone` AS `phone`,`d`.`facebook` AS `facebook`,`d`.`im` AS `im`,`d`.`skype` AS `skype`,`d`.`website` AS `website`,`d`.`image` AS `image` from ((((`person` `p` left join `user` `u` on((`p`.`pid` = `u`.`pid`))) left join `personDetail` `d` on((`p`.`pid` = `d`.`pid`))) left join `TOK` `t` on((`p`.`dataSource` = `t`.`key`))) left join `website` `w` on((`p`.`sourceWebsite` = `w`.`id`)));


ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid` (`pid`),
  ADD KEY `ref` (`ref`);

ALTER TABLE `error404`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sectionId` (`sectionId`);

ALTER TABLE `errorLog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `visitId` (`visitId`),
  ADD KEY `timestamp` (`timestamp`);

ALTER TABLE `history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `table` (`table`);

ALTER TABLE `historyRecord`
  ADD UNIQUE KEY `idAndColumn` (`historyId`,`column`),
  ADD KEY `historyId` (`historyId`);

ALTER TABLE `menuItem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `urlOnWebsite` (`url`,`websiteId`),
  ADD KEY `websiteId` (`websiteId`),
  ADD KEY `pageId` (`pageId`);

ALTER TABLE `page`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sectionId` (`sectionId`);

ALTER TABLE `permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pid` (`pid`,`sectionId`),
  ADD UNIQUE KEY `pidAndSection` (`pid`,`sectionId`),
  ADD KEY `sectionId` (`sectionId`);

ALTER TABLE `person`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `name` (`name`,`secondaryName`),
  ADD KEY `dataSource` (`dataSource`),
  ADD KEY `sourceWebsite` (`sourceWebsite`),
  ADD KEY `systemState` (`systemState`);

ALTER TABLE `personDetail`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `memberNumber` (`memberNumber`),
  ADD UNIQUE KEY `correspondentNumber` (`correspondentNumber`);

ALTER TABLE `personSetting`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pidAndKey` (`pid`,`key`),
  ADD KEY `pid` (`pid`);

ALTER TABLE `section`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `TOK`
  ADD PRIMARY KEY (`key`);

ALTER TABLE `user`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `urlUsername` (`urlName`);

ALTER TABLE `visit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sectionId` (`websiteId`);

ALTER TABLE `visitByDay`
  ADD PRIMARY KEY (`date`,`pageId`),
  ADD KEY `pageId` (`pageId`);

ALTER TABLE `visitByUser`
  ADD PRIMARY KEY (`timestamp`,`websiteId`,`pid`),
  ADD KEY `pid` (`pid`),
  ADD KEY `websiteId` (`websiteId`);

ALTER TABLE `visitPage`
  ADD KEY `visitId` (`visitId`);

ALTER TABLE `website`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);


ALTER TABLE `comment`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `error404`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `errorLog`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
ALTER TABLE `history`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `menuItem`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `page`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `permission`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `person`
  MODIFY `pid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'main person ID in the evidence';
ALTER TABLE `personSetting`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `section`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `TOK`
  MODIFY `key` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `visit`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID of visit';
ALTER TABLE `website`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;

ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE `errorLog`
  ADD CONSTRAINT `errorLog_ibfk_1` FOREIGN KEY (`visitId`) REFERENCES `visit` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE `historyRecord`
  ADD CONSTRAINT `historyRecord_ibfk_1` FOREIGN KEY (`historyId`) REFERENCES `history` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `menuItem`
  ADD CONSTRAINT `menuItem_ibfk_1` FOREIGN KEY (`websiteId`) REFERENCES `website` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `menuItem_ibfk_2` FOREIGN KEY (`pageId`) REFERENCES `page` (`id`) ON UPDATE CASCADE;

ALTER TABLE `page`
  ADD CONSTRAINT `page_ibfk_1` FOREIGN KEY (`sectionId`) REFERENCES `section` (`id`) ON UPDATE CASCADE;

ALTER TABLE `permission`
  ADD CONSTRAINT `permission_ibfk_1` FOREIGN KEY (`sectionId`) REFERENCES `section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permission_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `person`
  ADD CONSTRAINT `person_ibfk_1` FOREIGN KEY (`dataSource`) REFERENCES `TOK` (`key`) ON UPDATE CASCADE,
  ADD CONSTRAINT `person_ibfk_2` FOREIGN KEY (`sourceWebsite`) REFERENCES `website` (`id`) ON UPDATE CASCADE;

ALTER TABLE `personDetail`
  ADD CONSTRAINT `personDetail_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `personSetting`
  ADD CONSTRAINT `personSetting_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`) ON UPDATE CASCADE;

ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE `visitByUser`
  ADD CONSTRAINT `visitByUser_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`),
  ADD CONSTRAINT `visitByUser_ibfk_2` FOREIGN KEY (`websiteId`) REFERENCES `website` (`id`);

ALTER TABLE `visitPage`
  ADD CONSTRAINT `visitPage_ibfk_1` FOREIGN KEY (`visitId`) REFERENCES `visit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

INSERT INTO `TOK` (`key`, `value`, `type`) VALUES
(0,	'Nepřihlášený',	'pe'),
(1,	'Přihlášený uživatel',	'pe'),
(2,	'Čtenář',	'pe'),
(3,	'Redaktor',	'pe'),
(4,	'Hlavní redaktor',	'pe'),
(5,	'Administrátor',	'pe'),
(6,	'Superadministrátor',	'pe'),
(10,	'Nový',	'ts'),
(11,	'Akceptovaný',	'ts'),
(12,	'Odložený',	'ts'),
(13,	'Duplicitní',	'ts'),
(14,	'Vyřešený',	'ts'),
(15,	'Uzavřený',	'ts'),
(16,	'Zamítnutý',	'ts'),
(20,	'systém',	'tt'),
(21,	'administrace webu',	'tt'),
(30,	'Nejnižší',	'pr'),
(31,	'Nízká',	'pr'),
(32,	'Normální',	'pr'),
(33,	'Vysoká',	'pr'),
(34,	'Nejvyšší',	'pr'),
(40,	'Nejnižší',	'ep'),
(41,	'Nízká',	'ep'),
(42,	'Střední',	'ep'),
(50,	'manuální',	'ds'),
(51,	'registrace přes web',	'ds'),
(60,	'Veřejné informace o systému',	'dc'),
(61,	'Interní informace o sysému',	'dc');

