SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

DROP TABLE IF EXISTS `ticket`;
CREATE TABLE `ticket` (
  `id` int(10) unsigned NOT NULL,
  `title` varchar(48) COLLATE utf8_czech_ci NOT NULL,
  `reporter` int(10) unsigned NOT NULL,
  `description` text COLLATE utf8_czech_ci,
  `priority` int(10) unsigned NOT NULL COMMENT 'Task priority',
  `points` float unsigned DEFAULT NULL COMMENT 'Number of estimated SCRUM points to finish this task',
  `progress` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Completness in percents',
  `state` int(10) unsigned NOT NULL COMMENT 'State of the ticket - new, assigned, closed...',
  `type` int(10) unsigned DEFAULT NULL,
  `versionId` int(10) unsigned DEFAULT NULL COMMENT 'Version of project to which ticket is assigned',
  `tmpOwner` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='System tasks tickets';

DROP TABLE IF EXISTS `ticketAssignement`;
CREATE TABLE `ticketAssignement` (
  `id` int(10) unsigned NOT NULL,
  `ticketId` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `working` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Works this user currently on this task?'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Assignements of tickets to persons';

CREATE TABLE `ticket_version` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(127) COLLATE utf8_czech_ci NOT NULL,
  `description` text COLLATE utf8_czech_ci,
  `creationDate` datetime DEFAULT NULL,
  `pid` int(10) unsigned NOT NULL COMMENT 'Reporter of this version',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  CONSTRAINT `ticket_version_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `ticketWork`;
CREATE TABLE `ticketWork` (
  `id` int(10) unsigned NOT NULL,
  `ticketId` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `points` float unsigned NOT NULL COMMENT 'Number of points done this day',
  `comment` varchar(256) COLLATE utf8_czech_ci DEFAULT NULL COMMENT 'Short comment for the work',
  `date` date NOT NULL COMMENT 'Day when worked'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci COMMENT='Points which person worked on some ticket in the day';

ALTER TABLE `ticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `priority` (`priority`,`state`),
  ADD KEY `type` (`type`,`versionId`),
  ADD KEY `tmpOwner` (`tmpOwner`),
  ADD KEY `reporter` (`reporter`),
  ADD KEY `state` (`state`),
  ADD KEY `versionId` (`versionId`);

ALTER TABLE `ticketAssignement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticketId` (`ticketId`,`pid`),
  ADD KEY `working` (`working`);

ALTER TABLE `ticketWork`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticketPidDayUnique` (`ticketId`,`pid`,`date`),
  ADD KEY `ticketId` (`ticketId`,`pid`),
  ADD KEY `pid` (`pid`);


ALTER TABLE `ticket`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `ticketAssignement`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `ticketWork`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;

ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`priority`) REFERENCES `TOK` (`key`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`state`) REFERENCES `TOK` (`key`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_4` FOREIGN KEY (`reporter`) REFERENCES `user` (`pid`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_5` FOREIGN KEY (`type`) REFERENCES `TOK` (`key`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_6` FOREIGN KEY (`versionId`) REFERENCES `ticket_version` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_7` FOREIGN KEY (`tmpOwner`) REFERENCES `person` (`pid`) ON UPDATE CASCADE;

ALTER TABLE `ticketAssignement`
  ADD CONSTRAINT `ticketAssignement_ibfk_1` FOREIGN KEY (`ticketId`) REFERENCES `ticket` (`id`);

ALTER TABLE `ticketWork`
  ADD CONSTRAINT `ticketWork_ibfk_1` FOREIGN KEY (`ticketId`) REFERENCES `ticket` (`id`),
  ADD CONSTRAINT `ticketWork_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `person` (`pid`);
COMMIT;

