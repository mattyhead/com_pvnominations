SET FOREIGN_KEY_CHECKS=0;

/* ==================== constants ==================== */
SET @tnow = NOW();
SET @tnl  = '0000-00-00 00:00:00';
SET @tns  = '0000-00-00';
SET @db   = DATABASE();

/* ==================== tables ==================== */

DROP TABLE IF EXISTS `#__pv_office_nomination_data`;
DROP TABLE IF EXISTS `#__pv_office_nomination_display`;
DROP TABLE IF EXISTS `#__pv_nominations`;

CREATE TABLE IF NOT EXISTS `#__pv_nomination_data` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `office_id` int(11) NOT NULL DEFAULT 0,
  `signatures` int(5) NOT NULL DEFAULT 0,
  `fees` float(10,4) NOT NULL DEFAULT 0.00,
  `published` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `show_precincts` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `description` varchar(255) NOT NULL DEFAULT '',
  `checked_out` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `pv_nomination_data_office_id` (`office_id`)
);

CREATE TABLE IF NOT EXISTS `#__pv_nomination_displays` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_id` int(11) NOT NULL DEFAULT 0,
  `signing_start` date NOT NULL DEFAULT '0000-00-00',
  `signing_stop` date NOT NULL DEFAULT '0000-00-00',
  `display_start` date NOT NULL DEFAULT '0000-00-00',
  `display_stop` date NOT NULL DEFAULT '0000-00-00',
  `election_type` enum ('general', 'primary', 'special'),
  `election_date` date NOT NULL DEFAULT '0000-00-00',
  `description` varchar(255) NOT NULL DEFAULT '',
  `published` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `checked_out` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `pv_nomination_display_data_id` (`data_id`)
);

CREATE TABLE IF NOT EXISTS `#__pv_nominations` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hash` varchar(100) NOT NULL DEFAULT '',
  `display_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `candidate_name` varchar(100) NOT NULL DEFAULT '',
  `candidate_address` varchar(100) NOT NULL DEFAULT '',
  `candidate_occupation` varchar(100) NOT NULL DEFAULT '',
  `candidate_party` varchar(100) NOT NULL DEFAULT '',
  `candidate_precinct` varchar(20) NOT NULL DEFAULT '',
  `user_ip` varchar(16) NOT NULL DEFAULT '',
  `published` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `checked_out` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `pv_nominations_display_id` (`display_id`),
  UNIQUE KEY `pv_nominations_hash` (`hash`)
  );

INSERT INTO `#__pv_tables` 
  (`name`, `created`) 
  SELECT 
  `table_name` AS `name`, 
  @tnow AS `created` 
  FROM `information_schema`.`tables` 
  WHERE `table_schema`=@db AND `table_name` LIKE "%_pv_%" AND `table_name` NOT IN (SELECT `name` FROM `#__pv_tables`);

INSERT INTO `#__pv_nomination_data`
(`office_id`, `signatures`, `fees`, `created`)
VALUES
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Committeeperson'), '10', '0', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Inspector of Election'), '5', '0', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Judge of Election'), '10', '0', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Mayor'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='District Attorney'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='City Council At-Large'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='District City Council'), '750', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='City Commissioner'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='City Controller'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Register of Wills'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Sheriff'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Governor'), '2000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Lieutenant Governor'), '2000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Attorney General'), '1000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Auditor General'), '1000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='State Treasurer'), '1000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='State Representative'), '300', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='State Senator'), '500', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Judge of the Commonwealth Court'), '1000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Judge of the Court of Common Pleas'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Judge of the Municipal Court'), '1000', '100', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Judge of the Superior Court'), '1000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Justice of the Supreme Court'), '1000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Member of State Committee'), '100', '25', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Delegate'), '250', '25', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='Alternate Delegate'), '250', '25', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='President of the United States'), '2000', '200', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='U.S. Representative'), '1000', '150', @tnow ),
((SELECT `id` FROM `#__pv_offices` WHERE `name`='U.S. Senate'), '2000', '200', @tnow );

UPDATE `#__pv_nomination_data` `a`, `#__pv_offices` `o` SET `a`.`show_precincts`=1 WHERE `o`.`level` IN ('local', 'ward');

/* for testing, we need to publish some */
UPDATE `#__pv_nomination_data` `a`, `#__pv_offices` `o` SET `a`.`published`=1 WHERE `o`.`level` IN ('local', 'ward') AND `a`.`office_id`=`o`.`id`;

/*some testing displays data - this *must* be junked */
INSERT INTO `jos_pv_nomination_displays` (`data_id`, `signing_start`, `signing_stop`, `display_start`, `display_stop`, `election_type`, `election_date`, `description`, `published`, `checked_out`, `checked_out_time`, `created`, `updated`) VALUES
(5, '2017-02-14', '2017-03-07', '2017-02-06', '2017-03-07', 'primary', '2017-05-08', '', 1, 0, @tnl, '2016-12-31 09:28:41', @tnl),
(9, '2017-02-14', '2017-03-07', '2017-02-06', '2017-03-07', 'primary', '2017-05-08', '', 1, 0, @tnl, '2016-12-31 09:29:16', @tnl),
(1, '2017-09-04', '2017-09-12', '2017-08-24', '2017-09-24', 'general', '2017-11-07', '', 1, 0, @tnl, @tnow, $tnl);
-- ALTER TABLE `#__pv_nomination_data`
--   ADD CONSTRAINT `fk_pv_nominations_data_office_id`
--   FOREIGN KEY (`office_id`) REFERENCES `#__pv_offices`(`id`)
--   ON DELETE SET NULL
--   ON UPDATE CASCADE;
-- ALTER TABLE `#__pv_nomination_displays`
--   ADD CONSTRAINT `fk_pv_nominations_display_data_id`
--   FOREIGN KEY (`data_id`) REFERENCES `#__pv_nominations_data`(`id`)
--   ON DELETE SET NULL
--   ON UPDATE CASCADE;
-- ALTER TABLE `#__pv_nominations`
--   ADD CONSTRAINT `fk_pv_nominations_display_id`
--   FOREIGN KEY (`display_id`) REFERENCES `#__pv_nominations_displays`(`id`)
--   ON DELETE SET NULL
--   ON UPDATE CASCADE;
