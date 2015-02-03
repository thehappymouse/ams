# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 192.168.1.5 (MySQL 5.5.8)
# Database: power
# Generation Time: 2014-12-01 10:30:58 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table Arrears
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Arrears`;

CREATE TABLE `Arrears` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '欠费信息表',
  `YearMonth` char(6) DEFAULT NULL COMMENT '欠费年月',
  `CustomerNumber` varchar(45) NOT NULL COMMENT '用户编号',
  `CustomerName` varchar(45) DEFAULT NULL COMMENT '用户名称',
  `Money` float DEFAULT NULL COMMENT '欠费金额',
  `PressCount` int(11) DEFAULT '0' COMMENT '催费次数',
  `Charge` varchar(11) DEFAULT NULL COMMENT '收费员ID',
  `ChargeDate` varchar(19) DEFAULT NULL COMMENT '收费日期',
  `IsClean` char(1) DEFAULT NULL COMMENT '结清标识   0 未结清 1 结清  2，预期转余期',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段编号',
  `SegUser` varchar(45) DEFAULT NULL COMMENT '抄表员',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `YearMonth` (`YearMonth`,`CustomerNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Arrears` WRITE;
/*!40000 ALTER TABLE `Arrears` DISABLE KEYS */;

INSERT INTO `Arrears` (`ID`, `YearMonth`, `CustomerNumber`, `CustomerName`, `Money`, `PressCount`, `Charge`, `ChargeDate`, `IsClean`, `Segment`, `SegUser`)
VALUES
	(3276,'201410','1','1',20,0,'sf','2014-12-03 02:55:23','1','a','a'),
	(3277,'201409','1','1',30,1,'sf','2014-12-03 03:57:58','1','a','a'),
	(3278,'201408','1','1',10,1,'sf','2014-12-03 02:31:23','1','a','3a'),
	(3279,'201410','2','2',10,0,'','','0','a','a'),
	(3280,'201409','2','2',10,0,'','','0','a','a'),
	(3281,'201408','2','2',10,0,'','','0','a','a'),
	(3282,'201410','3','3',10,2,NULL,NULL,'0','b','b'),
	(3283,'201409','3','3',10,1,NULL,NULL,'0','b','b'),
	(3284,'201408','3','3',10,0,NULL,NULL,'0','b','3b'),
	(3285,'201410','4','4',10,1,NULL,NULL,'0','b','b'),
	(3286,'201409','4','4',10,0,NULL,NULL,'0','b','b'),
	(3287,'201408','4','4',10,1,NULL,NULL,'0','b','b'),
	(3288,'201410','5','5',10,0,'sf','2014-12-01 15:52:29','1','c','c'),
	(3301,'201407','000000002','yy2',20,0,NULL,NULL,'0','mb2','3a'),
	(3289,'201409','5','5',10,2,NULL,NULL,'0','c','c'),
	(3290,'201408','5','5',10,2,NULL,NULL,'0','c','c'),
	(3291,'201410','6','6',10,3,NULL,NULL,'0','c','c'),
	(3292,'201409','6','6',10,2,NULL,NULL,'0','c','c'),
	(3293,'201408','6','6',10,2,NULL,NULL,'0','c','c'),
	(3294,'201410','7','7',10,1,NULL,NULL,'0','d','d'),
	(3295,'201409','7','7',10,0,NULL,NULL,'0','d','d'),
	(3296,'201408','7','7',10,0,'sf','2014-12-01 23:00:19','1','d','d'),
	(3297,'201410','8','8',10,0,NULL,NULL,'0','d','d'),
	(3298,'201409','8','8',10,0,NULL,NULL,'0','d','d'),
	(3299,'201408','8','8',10,0,NULL,NULL,'0','d','d'),
	(3300,'201407','000000001','yy1',20,0,NULL,NULL,'0','mb1','3a'),
	(3302,'201407','000000003','yy3',20,0,NULL,NULL,'0','mb3','3b'),
	(3303,'201407','000000004','yy4',20,0,NULL,NULL,'0','mb4','3b'),
	(3304,'201407','000000005','yy9',20,0,NULL,NULL,'0','mb9','4a'),
	(3305,'201407','000000006','yy10',20,0,NULL,NULL,'0','mb10','4a'),
	(3306,'201407','000000007','yy11',20,0,NULL,NULL,'0','mb11','4b'),
	(3307,'201407','000000008','yy12',20,0,NULL,NULL,'0','mb12','4b'),
	(3308,'201408','000000010','yy6',20,0,NULL,NULL,'0','mb6','3a'),
	(3309,'201408','000000012','yy8',20,0,NULL,NULL,'0','mb8','3b'),
	(3310,'201408','000000013','yy13',20,0,NULL,NULL,'0','mb13','4a'),
	(3311,'201408','000000014','yy14',20,0,NULL,NULL,'0','mb14','4a'),
	(3312,'201408','000000015','yy15',20,0,NULL,NULL,'0','mb15','4b'),
	(3313,'201408','000000016','yy16',20,0,NULL,NULL,'0','mb16','4b'),
	(3314,'201407','0380900001','yy1',20,2,'2s1','2014-12-03 08:37:00','1','mb1','5a'),
	(3315,'201407','0380900002','yy2',20,1,'2s1','2014-12-03 08:42:46','1','mb2','5a'),
	(3316,'201407','0380900003','yy3',20,0,NULL,NULL,'0','mb3','5b'),
	(3317,'201407','0380900004','yy4',20,0,NULL,NULL,'0','mb4','5b'),
	(3318,'201407','0380900005','yy9',20,0,NULL,NULL,'0','mb9','6a'),
	(3319,'201407','0380900006','yy10',20,0,NULL,NULL,'0','mb10','6a'),
	(3320,'201407','0380900007','yy11',20,0,NULL,NULL,'0','mb11','6b'),
	(3321,'201407','0380900008','yy12',20,0,NULL,NULL,'0','mb12','6b'),
	(3322,'201408','0380900009','yy1',20,0,NULL,NULL,'0','mb1','5a'),
	(3323,'201408','0380900010','yy6',20,0,NULL,NULL,'0','mb6','5a'),
	(3324,'201408','0380900011','yy3',20,0,NULL,NULL,'0','mb3','5b'),
	(3325,'201408','0380900012','yy8',20,0,NULL,NULL,'0','mb8','5b'),
	(3326,'201408','0380900013','yy13',20,0,NULL,NULL,'0','mb13','6a'),
	(3327,'201408','0380900014','yy14',20,0,NULL,NULL,'0','mb14','6a'),
	(3328,'201408','0380900015','yy15',20,0,NULL,NULL,'0','mb15','6b'),
	(3329,'201408','0380900016','yy16',20,0,NULL,NULL,'0','mb16','6b');

/*!40000 ALTER TABLE `Arrears` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Charge`;

CREATE TABLE `Charge` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerNumber` varchar(25) NOT NULL,
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `SegUser` varchar(25) DEFAULT NULL COMMENT '抄表员',
  `Year` char(4) DEFAULT NULL COMMENT '收费年',
  `YearMonth` int(11) NOT NULL,
  `Money` float NOT NULL,
  `UserID` int(11) NOT NULL COMMENT '收费人ID',
  `UserName` varchar(25) NOT NULL COMMENT '收费人',
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IsRent` char(1) NOT NULL DEFAULT '' COMMENT '是否出租房',
  `LandlordPhone` varchar(12) DEFAULT '' COMMENT '房东电话',
  `RenterPhone` varchar(12) DEFAULT '' COMMENT '租客电话',
  `IsControl` char(1) DEFAULT NULL COMMENT '签定费控协议',
  `ChargeTeam` int(11) DEFAULT NULL COMMENT '收费班ID',
  `ManageTeam` int(11) DEFAULT NULL COMMENT '催费班ID',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='收费信息表';

LOCK TABLES `Charge` WRITE;
/*!40000 ALTER TABLE `Charge` DISABLE KEYS */;

INSERT INTO `Charge` (`ID`, `CustomerNumber`, `Segment`, `SegUser`, `Year`, `YearMonth`, `Money`, `UserID`, `UserName`, `Time`, `IsRent`, `LandlordPhone`, `RenterPhone`, `IsControl`, `ChargeTeam`, `ManageTeam`)
VALUES
	(100,'1','a','a','2014',201408,10,107,'sf','2014-12-03 02:22:29','0','1','','0',57,54),
	(109,'0380900001','mb1','5a','2014',201407,20,121,'2s1','2014-12-03 08:37:00','0','0531-8902257','','0',61,62),
	(96,'5','c','c','2014',201410,10,107,'sf','2014-12-01 15:52:29','0','5','','0',57,56),
	(110,'0380900002','mb2','5a','2014',201407,20,121,'2s1','2014-12-03 08:42:46','0','','','0',61,62),
	(97,'7','d','d','2014',201408,10,107,'sf','2014-12-01 23:00:19','0','7','','0',57,56),
	(102,'1','a','a','2014',201410,20,107,'sf','2014-12-03 02:53:31','0','1','','0',57,54),
	(107,'1','a','a','2014',201409,30,107,'sf','2014-12-03 03:57:58','0','1','','0',57,54);

/*!40000 ALTER TABLE `Charge` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Config`;

CREATE TABLE `Config` (
  `Key` varchar(15) NOT NULL DEFAULT '',
  `Value` varchar(100) DEFAULT NULL,
  `Desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Config` WRITE;
/*!40000 ALTER TABLE `Config` DISABLE KEYS */;

INSERT INTO `Config` (`Key`, `Value`, `Desc`)
VALUES
	('IndexLine','123','指标线');

/*!40000 ALTER TABLE `Config` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Customer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Customer`;

CREATE TABLE `Customer` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL DEFAULT '' COMMENT '客户名称',
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Number` varchar(45) DEFAULT NULL COMMENT '客户编号',
  `Address` varchar(255) DEFAULT NULL COMMENT '用电地址',
  `Balance` float NOT NULL DEFAULT '0' COMMENT '预收金额',
  `Money` float NOT NULL DEFAULT '0' COMMENT '欠费金额',
  `IsRent` char(1) NOT NULL DEFAULT '0' COMMENT '是否出租房',
  `LandlordPhone` varchar(45) DEFAULT NULL COMMENT '房东电话',
  `RenterPhone` varchar(45) DEFAULT NULL COMMENT '租客电话',
  `Cause` varchar(200) DEFAULT NULL COMMENT '欠费原因',
  `IsSpecial` char(1) DEFAULT NULL COMMENT '是否特殊客户',
  `IsCut` char(1) NOT NULL DEFAULT '0' COMMENT '停电标识 0 未停；1已停',
  `CanCut` char(1) DEFAULT NULL COMMENT '能否停电标识',
  `IsClean` char(1) NOT NULL DEFAULT '0' COMMENT '结清标识   0 未结清 1 结清  2，预期转余期',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `SegmentID` int(11) DEFAULT NULL COMMENT '抄表段ID',
  `SegUser` varchar(25) DEFAULT NULL COMMENT '抄表员名称',
  `IsControl` char(1) NOT NULL DEFAULT '0' COMMENT '是否费控用户',
  `Desc` text COMMENT '备注',
  `AssetNumber` varchar(45) DEFAULT NULL COMMENT '电表资产号',
  `ArrearsCount` int(11) NOT NULL DEFAULT '0' COMMENT '当前所有欠费笔数',
  `AllArrearCount` int(11) DEFAULT NULL COMMENT '累计欠费次数 只增不减',
  `CutCount` int(11) NOT NULL DEFAULT '0' COMMENT '累计停电次数',
  `PressCount` int(11) NOT NULL DEFAULT '0' COMMENT '催费次数',
  `FirstDate` char(6) DEFAULT NULL COMMENT '欠费最早月',
  `LastDate` char(6) DEFAULT NULL COMMENT '最近欠费月',
  `CutStyle` varchar(20) DEFAULT NULL COMMENT '停电方式',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;

INSERT INTO `Customer` (`ID`, `Name`, `CreateTime`, `Number`, `Address`, `Balance`, `Money`, `IsRent`, `LandlordPhone`, `RenterPhone`, `Cause`, `IsSpecial`, `IsCut`, `CanCut`, `IsClean`, `Segment`, `SegmentID`, `SegUser`, `IsControl`, `Desc`, `AssetNumber`, `ArrearsCount`, `AllArrearCount`, `CutCount`, `PressCount`, `FirstDate`, `LastDate`, `CutStyle`)
VALUES
	(2876,'1','2014-11-29 20:42:15','1','1',60,0,'0','1','','','0','0','0','1','a',NULL,'a','0','','',0,3,2,0,'','','远程停电'),
	(2877,'2','2014-11-29 20:42:15','2','2',0,30,'0','2','','','1','0','0','0','a',NULL,'a','0','','',3,3,0,0,'201408','201410',''),
	(2878,'3','2014-11-29 20:42:15','3','3',0,30,'0','3','',NULL,'0','1','0','0','b',NULL,'b','0',NULL,NULL,3,3,6,3,'201408','201410','远程停电'),
	(2879,'4','2014-11-29 20:42:15','4','4',0,30,'0','4','',NULL,'0','0','0','0','b',NULL,'b','0',NULL,NULL,3,3,0,2,'201408','201410',''),
	(2880,'5','2014-12-01 15:39:39','5','1',0,20,'0','5','',NULL,'0','0','0','0','c',NULL,'c','0',NULL,NULL,2,3,0,4,'201408','201409',''),
	(2881,'6','2014-12-01 15:39:39','6','2',0,30,'0','6','',NULL,'0','0','0','0','c',NULL,'c','0',NULL,NULL,3,3,0,7,'201408','201410',''),
	(2882,'7','2014-12-01 15:39:39','7','3',0,20,'0','7','',NULL,'0','0','0','0','d',NULL,'d','0',NULL,NULL,2,3,0,1,'201409','201410',''),
	(2883,'8','2014-12-01 15:39:39','8','4',0,30,'0','8','',NULL,'0','0','0','0','d',NULL,'d','0',NULL,NULL,3,3,0,0,'201408','201410',''),
	(2884,'yy1','2014-12-03 07:47:24','000000001','经二纬一44#-东-202',0,20,'0','0531-89022573','',NULL,'0','0','0','0','mb1',NULL,'3a','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2885,'yy2','2014-12-03 07:47:24','000000002','小纬四路51号103户',0,20,'0','','',NULL,'0','0','0','0','mb2',NULL,'3a','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2886,'yy3','2014-12-03 07:47:24','000000003','小纬四路49号2单元503户',0,20,'0','13011722627','',NULL,'0','0','0','0','mb3',NULL,'3b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2887,'yy4','2014-12-03 07:47:24','000000004','经二纬一44#-东-402',0,20,'0',NULL,'',NULL,'0','0','0','0','mb4',NULL,'3b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2888,'yy9','2014-12-03 07:47:24','000000005','经二纬一44#-东-504',0,20,'0','0531-89022573','',NULL,'0','0','0','0','mb9',NULL,'4a','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2889,'yy10','2014-12-03 07:47:24','000000006','舜玉南区75号楼307户',0,20,'0','','',NULL,'0','0','0','0','mb10',NULL,'4a','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2890,'yy11','2014-12-03 07:47:24','000000007','纬一路后街2号1号楼西单元303户',0,20,'0','13011722627','',NULL,'0','0','0','0','mb11',NULL,'4b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2891,'yy12','2014-12-03 07:47:24','000000008','纬一路后街2号1号楼西单元204户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb12',NULL,'4b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2892,'yy6','2014-12-03 07:47:24','000000010','舜玉南区75号楼306户',0,20,'0','8973126015069064292','',NULL,'0','0','0','0','mb6',NULL,'3a','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2893,'yy8','2014-12-03 07:47:24','000000012','纬一路后街2号1号楼西单元402户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb8',NULL,'3b','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2894,'yy13','2014-12-03 07:47:24','000000013','经二纬一44#-东-505',0,20,'0',NULL,'',NULL,'0','0','0','0','mb13',NULL,'4a','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2895,'yy14','2014-12-03 07:47:24','000000014','舜玉南区75号楼308户',0,20,'0','8973126015069064292','',NULL,'0','0','0','0','mb14',NULL,'4a','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2896,'yy15','2014-12-03 07:47:24','000000015','纬一路后街2号1号楼西单元105户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb15',NULL,'4b','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2897,'yy16','2014-12-03 07:47:24','000000016','纬一路后街2号1号楼西单元6户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb16',NULL,'4b','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2898,'yy1','2014-12-03 08:01:27','0380900001','经二纬一44#-东-202',0,0,'0','0531-89022573','',NULL,'0','0','0','1','mb1',NULL,'5a','0',NULL,NULL,0,1,1,0,'','','远程停电'),
	(2899,'yy2','2014-12-03 08:01:27','0380900002','小纬四路51号103户',0,0,'0','','',NULL,'0','0','0','1','mb2',NULL,'5a','0',NULL,NULL,0,1,0,0,'','',''),
	(2900,'yy3','2014-12-03 08:01:27','0380900003','小纬四路49号2单元503户',0,20,'0','13011722627','',NULL,'0','0','0','0','mb3',NULL,'5b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2901,'yy4','2014-12-03 08:01:27','0380900004','经二纬一44#-东-402',0,20,'0',NULL,'',NULL,'0','0','0','0','mb4',NULL,'5b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2902,'yy9','2014-12-03 08:01:27','0380900005','经二纬一44#-东-504',0,20,'0','0531-89022573','',NULL,'0','0','0','0','mb9',NULL,'6a','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2903,'yy10','2014-12-03 08:01:27','0380900006','舜玉南区75号楼307户',0,20,'0','','',NULL,'0','0','0','0','mb10',NULL,'6a','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2904,'yy11','2014-12-03 08:01:27','0380900007','纬一路后街2号1号楼西单元303户',0,20,'0','13011722627','',NULL,'0','0','0','0','mb11',NULL,'6b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2905,'yy12','2014-12-03 08:01:27','0380900008','纬一路后街2号1号楼西单元204户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb12',NULL,'6b','0',NULL,NULL,1,1,0,0,'201407','201407',''),
	(2906,'yy1','2014-12-03 08:01:27','0380900009','经二纬一44#-东-202',0,20,'0','0531-89022573','',NULL,'0','0','0','0','mb1',NULL,'5a','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2907,'yy6','2014-12-03 08:01:27','0380900010','舜玉南区75号楼306户',0,20,'0','8973126015069064292','',NULL,'0','0','0','0','mb6',NULL,'5a','0',NULL,NULL,1,1,1,0,'201408','201408','远程停电'),
	(2908,'yy3','2014-12-03 08:01:27','0380900011','小纬四路49号2单元503户',0,20,'0','13011722627','',NULL,'0','0','0','0','mb3',NULL,'5b','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2909,'yy8','2014-12-03 08:01:27','0380900012','纬一路后街2号1号楼西单元402户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb8',NULL,'5b','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2910,'yy13','2014-12-03 08:01:27','0380900013','经二纬一44#-东-505',0,20,'0',NULL,'',NULL,'0','0','0','0','mb13',NULL,'6a','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2911,'yy14','2014-12-03 08:01:27','0380900014','舜玉南区75号楼308户',0,20,'0','8973126015069064292','',NULL,'0','0','0','0','mb14',NULL,'6a','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2912,'yy15','2014-12-03 08:01:27','0380900015','纬一路后街2号1号楼西单元105户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb15',NULL,'6b','0',NULL,NULL,1,1,0,0,'201408','201408',''),
	(2913,'yy16','2014-12-03 08:01:27','0380900016','纬一路后街2号1号楼西单元6户',0,20,'0',NULL,'',NULL,'0','0','0','0','mb16',NULL,'6b','0',NULL,NULL,1,1,0,0,'201408','201408','');

/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table CutInfo
# ------------------------------------------------------------

DROP TABLE IF EXISTS `CutInfo`;

CREATE TABLE `CutInfo` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '停电信息表',
  `Arrear` int(11) DEFAULT NULL COMMENT '欠费表ID',
  `CustomerNumber` varchar(25) DEFAULT NULL COMMENT '客户编号',
  `CutStyle` varchar(25) DEFAULT NULL COMMENT '停电方式',
  `CutTime` varchar(16) DEFAULT NULL COMMENT '停电时间',
  `CutUser` int(11) DEFAULT NULL COMMENT '停电人员',
  `CutUserName` varchar(25) DEFAULT '' COMMENT '抄表员、停电人员名称',
  `ResetTime` varchar(16) DEFAULT NULL COMMENT '复电时间',
  `ResetUser` int(11) DEFAULT NULL COMMENT '复电员',
  `ResetPhone` varchar(12) DEFAULT NULL COMMENT '复电电话',
  `ResetStyle` varchar(25) DEFAULT NULL COMMENT '复电方式',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `YearMonth` char(6) DEFAULT NULL,
  `Money` float DEFAULT NULL,
  `SegUser` varchar(25) DEFAULT NULL COMMENT '客户的抄表员',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `CutInfo` WRITE;
/*!40000 ALTER TABLE `CutInfo` DISABLE KEYS */;

INSERT INTO `CutInfo` (`ID`, `Arrear`, `CustomerNumber`, `CutStyle`, `CutTime`, `CutUser`, `CutUserName`, `ResetTime`, `ResetUser`, `ResetPhone`, `ResetStyle`, `Segment`, `YearMonth`, `Money`, `SegUser`)
VALUES
	(54,2878,'3','远程停电','2014-11-30 14:40',NULL,'b','2014-11-30 14:40',0,'3','远程复电','b',NULL,30,'b'),
	(55,2878,'3','远程停电','2014-11-30 14:40',NULL,'b',NULL,NULL,NULL,NULL,'b',NULL,30,'b'),
	(56,2898,'0380900001','远程停电','2014-11-30 20:49',NULL,'5a','2014-11-30 20:50',5,'0531-8902257','远程复电','mb1',NULL,20,'5a'),
	(53,2878,'3','远程停电','2014-11-30 14:36',NULL,'b','2014-11-30 14:37',0,'3','远程复电','b',NULL,30,'b'),
	(57,2907,'0380900010','远程停电','2014-12-01 12:00',NULL,'5a','2014-12-01 12:00',5,'897312601506','远程复电','mb6',NULL,20,'5a');

/*!40000 ALTER TABLE `CutInfo` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Message
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Message`;

CREATE TABLE `Message` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户消息表',
  `ToUserID` int(11) DEFAULT NULL,
  `FromUserID` int(11) DEFAULT NULL,
  `Sender` varchar(25) DEFAULT NULL COMMENT '发件人的姓名',
  `Content` text COMMENT '消息内容',
  `SendTime` datetime DEFAULT NULL COMMENT '发送时间',
  `IsRead` char(1) DEFAULT '0' COMMENT '是否已读',
  `ReadTime` datetime DEFAULT NULL COMMENT '阅读时间',
  `IsImportant` char(1) DEFAULT NULL COMMENT '是否为紧急状态 紧急时可跳转到复电界面',
  `RefCustomer` varchar(45) DEFAULT NULL COMMENT '相关客户',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Message` WRITE;
/*!40000 ALTER TABLE `Message` DISABLE KEYS */;

INSERT INTO `Message` (`ID`, `ToUserID`, `FromUserID`, `Sender`, `Content`, `SendTime`, `IsRead`, `ReadTime`, `IsImportant`, `RefCustomer`)
VALUES
	(99,104,107,'sf','1  已交费','2014-11-29 21:53:55','1',NULL,'1','1'),
	(100,106,107,'sf','1  已交费','2014-11-29 21:53:55','1',NULL,'1','1'),
	(101,104,107,'sf','2  已交费','2014-11-29 21:54:08','1',NULL,'0','2'),
	(102,106,107,'sf','2  已交费','2014-11-29 21:54:08','1',NULL,'0','2'),
	(103,108,107,'sf','5  已交费','2014-12-01 15:52:29','1',NULL,'0','5'),
	(104,110,107,'sf','5  已交费','2014-12-01 15:52:29','1',NULL,'0','5'),
	(105,109,107,'sf','7  已交费','2014-12-01 23:00:19',NULL,NULL,'0','7'),
	(106,110,107,'sf','7  已交费','2014-12-01 23:00:19','1',NULL,'0','7'),
	(107,104,107,'sf','1  已交费','2014-12-03 02:22:29','1',NULL,'0','1'),
	(108,106,107,'sf','1  已交费','2014-12-03 02:22:29','1',NULL,'0','1'),
	(109,104,107,'sf','1  已交费','2014-12-03 02:31:23','1',NULL,'0','1'),
	(110,106,107,'sf','1  已交费','2014-12-03 02:31:23','1',NULL,'0','1'),
	(111,104,107,'sf','1  已交费','2014-12-03 02:53:31','1',NULL,'0','1'),
	(112,106,107,'sf','1  已交费','2014-12-03 02:53:31','1',NULL,'0','1'),
	(113,104,107,'sf','1  已交费','2014-12-03 02:53:43','1',NULL,'0','1'),
	(114,106,107,'sf','1  已交费','2014-12-03 02:53:43','1',NULL,'0','1'),
	(115,104,107,'sf','1  已交费','2014-12-03 02:54:01','1',NULL,'0','1'),
	(116,106,107,'sf','1  已交费','2014-12-03 02:54:01','1',NULL,'0','1'),
	(117,104,107,'sf','1  已交费','2014-12-03 02:54:17','1',NULL,'0','1'),
	(118,106,107,'sf','1  已交费','2014-12-03 02:54:17','1',NULL,'0','1'),
	(119,104,107,'sf','1  已交费','2014-12-03 02:55:23','1',NULL,'0','1'),
	(120,106,107,'sf','1  已交费','2014-12-03 02:55:23','1',NULL,'0','1'),
	(121,109,107,'sf','7  已交费','2014-12-01 23:00:19',NULL,NULL,'0','7'),
	(122,104,107,'sf','1  已交费','2014-12-03 03:57:58',NULL,NULL,'0','1'),
	(123,106,107,'sf','1  已交费','2014-12-03 03:57:58','1',NULL,'0','1'),
	(124,104,107,'sf','2  已交费','2014-12-03 03:59:00','0',NULL,'0','2'),
	(125,106,107,'sf','2  已交费','2014-12-03 03:59:00','1',NULL,'0','2'),
	(126,123,121,'2s1','yy1  已交费','2014-12-03 08:37:00','0',NULL,'0','0380900001'),
	(127,125,121,'2s1','yy1  已交费','2014-12-03 08:37:00','1',NULL,'0','0380900001'),
	(128,123,121,'2s1','yy2  已交费','2014-12-03 08:42:46','0',NULL,'0','0380900002'),
	(129,125,121,'2s1','yy2  已交费','2014-12-03 08:42:46','1',NULL,'0','0380900002');

/*!40000 ALTER TABLE `Message` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Module
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Module`;

CREATE TABLE `Module` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '操作模块表',
  `Name` varchar(25) DEFAULT NULL,
  `Url` varchar(200) DEFAULT NULL,
  `Icon` varchar(200) DEFAULT NULL,
  `ParentID` int(11) NOT NULL,
  `Sort` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Module` WRITE;
/*!40000 ALTER TABLE `Module` DISABLE KEYS */;

INSERT INTO `Module` (`ID`, `Name`, `Url`, `Icon`, `ParentID`, `Sort`)
VALUES
	(1,'收费模块','charges',NULL,-1,0),
	(2,'催费模块','reminder',NULL,-1,0),
	(3,'统计查询','count',NULL,-1,0),
	(4,'各种报表','report',NULL,-1,0),
	(5,'数据导入','import',NULL,-1,0),
	(6,'收费','charges/charges',NULL,1,0),
	(7,'撤销收费','charges/withdrawn',NULL,1,0),
	(8,'催费','reminder/reminder',NULL,2,1),
	(9,'停电','reminder/powerfailure',NULL,2,3),
	(10,'复电','reminder/restoration',NULL,2,4),
	(32,'预收转逾期','reminder/receipts',NULL,2,5),
	(12,'单户查询','count/singleinquiries',NULL,3,0),
	(13,'对账查询','count/reconciliationinquiry',NULL,3,0),
	(14,'对账（财务）','count/reconciliation',NULL,3,0),
	(15,'电费回收明细','count/charges',NULL,3,0),
	(16,'催费明细','count/press',NULL,3,0),
	(17,'停电明细','count/cut',NULL,3,0),
	(18,'复电明细','count/reset',NULL,3,0),
	(19,'客户分类统计','count/customer',NULL,3,0),
	(20,'电费回收报表','report/electricity',NULL,4,0),
	(21,'催费情况报表','report/press',NULL,4,0),
	(22,'每日工作报表','report/work',NULL,4,0),
	(23,'数据库更新','import/arrears',NULL,5,0),
	(24,'预存电费导入','import/advance',NULL,5,0),
	(25,'管理','manager',NULL,-1,0),
	(26,'班组管理','manager/group',NULL,25,0),
	(29,'用户管理','manager/user',NULL,25,0),
	(31,'系统日志','manager/systemlog',NULL,25,0),
	(11,'撤销催费','reminder/cancel',NULL,2,2),
	(33,'概况','site/index',NULL,2,0),
	(34,'欠费数据修改','import/editarrear',NULL,25,0),
	(35,'应收费用管理','user/money',NULL,25,0);

/*!40000 ALTER TABLE `Module` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Press
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Press`;

CREATE TABLE `Press` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '催费信息表',
  `Arrear` int(11) DEFAULT NULL COMMENT '欠费ID',
  `PressTime` varchar(16) DEFAULT NULL COMMENT '催费时间',
  `PressStyle` varchar(20) DEFAULT NULL COMMENT '催费方式',
  `PhotoLocation` varchar(200) DEFAULT NULL COMMENT '照片拍照位置',
  `Photo` varchar(200) DEFAULT NULL COMMENT '照片存放路径',
  `PhoneType` varchar(10) DEFAULT NULL COMMENT '催费电话。房东|房客',
  `Phone` varchar(12) DEFAULT NULL COMMENT '催费电话',
  `UserID` int(11) DEFAULT NULL,
  `SegUser` varchar(25) DEFAULT '' COMMENT '抄表员',
  `CustomerNumber` varchar(25) NOT NULL COMMENT '客房编号',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `YearMonth` char(6) DEFAULT NULL,
  `Money` float DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Press` WRITE;
/*!40000 ALTER TABLE `Press` DISABLE KEYS */;

INSERT INTO `Press` (`ID`, `Arrear`, `PressTime`, `PressStyle`, `PhotoLocation`, `Photo`, `PhoneType`, `Phone`, `UserID`, `SegUser`, `CustomerNumber`, `Segment`, `YearMonth`, `Money`)
VALUES
	(109,3293,'2014-11-30 14:01','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201408',10),
	(108,3292,'2014-11-30 14:01','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201409',10),
	(107,3291,'2014-11-30 14:01','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201410',10),
	(106,3293,'2014-11-30 14:01','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201408',10),
	(105,3292,'2014-11-30 14:01','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201409',10),
	(104,3291,'2014-11-30 14:01','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201410',10),
	(103,3290,'2014-11-30 13:59','电话催费',NULL,'','房东电话','5',NULL,'c','5','c','201408',10),
	(102,3289,'2014-11-30 13:59','电话催费',NULL,'','房东电话','5',NULL,'c','5','c','201409',10),
	(101,3290,'2014-11-30 13:59','电话催费',NULL,'','房东电话','5',NULL,'c','5','c','201408',10),
	(100,3289,'2014-11-30 13:59','电话催费',NULL,'','房东电话','5',NULL,'c','5','c','201409',10),
	(112,3314,'2014-11-30 20:44','电话催费',NULL,'','房东电话','0531-8902257',NULL,'5a','0380900001','mb1','201407',20),
	(113,3315,'2014-11-30 20:44','通知单催费',NULL,'/public/upload/201412/123_1417565247.jpg',NULL,NULL,NULL,'5a','0380900002','mb2','201407',20),
	(111,3314,'2014-11-30 20:43','电话催费',NULL,'','房东电话','0531-8902257',NULL,'5a','0380900001','mb1','201407',20),
	(96,3294,'2014-11-30 13:41','电话催费',NULL,'','房东电话','7',NULL,'d','7','d','201410',10),
	(95,3291,'2014-11-30 13:35','电话催费',NULL,'','房东电话','6',NULL,'c','6','c','201410',10),
	(94,3285,'2014-11-30 13:31','电话催费',NULL,'','房东电话','4',NULL,'b','4','b','201410',10),
	(93,3282,'2014-11-30 12:53','电话催费',NULL,'','房东电话','38',NULL,'b','3','b','201410',10),
	(90,3282,'2014-11-28 16:59','电话催费',NULL,'','房东电话','3',NULL,'b','3','b','201410',10),
	(110,3287,'2014-11-30 14:45','电话催费',NULL,'','房东电话','4',NULL,'b','4','b','201408',10),
	(89,3283,'2014-11-28 16:59','电话催费',NULL,'','房东电话','3',NULL,'b','3','b','201409',10),
	(87,3277,'2014-11-28 16:53','电话催费',NULL,'','房东电话','1',NULL,'a','1','a','201409',10),
	(84,3278,'2014-11-28 16:37','电话催费',NULL,'','房东电话','1',NULL,'a','1','a','201408',10);

/*!40000 ALTER TABLE `Press` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Role`;

CREATE TABLE `Role` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色表',
  `Name` varchar(25) DEFAULT NULL,
  `Modules` varchar(255) DEFAULT NULL,
  `IndexPage` varchar(100) DEFAULT NULL COMMENT '角色登录的首页面',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;

INSERT INTO `Role` (`ID`, `Name`, `Modules`, `IndexPage`)
VALUES
	(1,'抄表员','33,8,11,12,9,10,15,16,17,18,19,20,21,22,32','/site/index'),
	(2,'抄表员班长','33,8,11,9,10,12,15,16,17,18,19,20,21,22,24,32','/site/index'),
	(3,'收费员','6,7,12,13','/charges/charges'),
	(4,'收费员班长','6,7,12,13,19','/count/reconciliationinquiry'),
	(5,'对账员','12,14','/count/Reconciliation'),
	(6,'管理人员','12,13,14,15,16,17,18,19,20,21,22,35','/manager/systemlog'),
	(7,'Admin','33,6,7,8,11,9,10,30,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,29,31,32,34,35','/manager/systemlog');

/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table SegmentLog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `SegmentLog`;

CREATE TABLE `SegmentLog` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Number` varchar(25) NOT NULL DEFAULT '' COMMENT '编号',
  `Name` varchar(25) DEFAULT NULL COMMENT '抄表段名称',
  `UserID` int(11) DEFAULT NULL COMMENT '抄表员ID',
  `UserName` varchar(25) DEFAULT NULL COMMENT '抄表员名称',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `SegmentLog` WRITE;
/*!40000 ALTER TABLE `SegmentLog` DISABLE KEYS */;

INSERT INTO `SegmentLog` (`ID`, `Number`, `Name`, `UserID`, `UserName`)
VALUES
	(356,'a','',99,'a'),
	(357,'b','',100,'b'),
	(358,'c','',108,'c'),
	(359,'d','',109,'d'),
	(360,'mb1','',115,'3a'),
	(361,'mb2','',115,'3a'),
	(362,'mb3','',116,'3b'),
	(363,'mb4','',116,'3b'),
	(364,'mb9','',111,'4a'),
	(365,'mb10','',111,'4a'),
	(366,'mb11','',112,'4b'),
	(367,'mb12','',112,'4b'),
	(368,'mb6','',115,'3a'),
	(369,'mb8','',116,'3b'),
	(370,'mb13','',111,'4a'),
	(371,'mb14','',111,'4a'),
	(372,'mb15','',112,'4b'),
	(373,'mb16','',112,'4b'),
	(374,'mb1','',123,'5a'),
	(375,'mb2','',123,'5a'),
	(376,'mb3','',124,'5b'),
	(377,'mb4','',124,'5b'),
	(378,'mb9','',127,'6a'),
	(379,'mb10','',127,'6a'),
	(380,'mb11','',128,'6b'),
	(381,'mb12','',128,'6b'),
	(382,'mb1','',123,'5a'),
	(383,'mb6','',123,'5a'),
	(384,'mb3','',124,'5b'),
	(385,'mb8','',124,'5b'),
	(386,'mb13','',127,'6a'),
	(387,'mb14','',127,'6a'),
	(388,'mb15','',128,'6b'),
	(389,'mb16','',128,'6b');

/*!40000 ALTER TABLE `SegmentLog` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table SystemLog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `SystemLog`;

CREATE TABLE `SystemLog` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL COMMENT '操作员',
  `UserName` varchar(25) DEFAULT NULL,
  `Action` varchar(11) DEFAULT NULL COMMENT '操作名称',
  `Success` char(1) DEFAULT NULL,
  `Result` varchar(25) DEFAULT NULL COMMENT '操作结果',
  `Time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间',
  `Data` varchar(255) DEFAULT NULL COMMENT '其它数据',
  `IP` varchar(15) DEFAULT NULL COMMENT '登录IP',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `SystemLog` WRITE;
/*!40000 ALTER TABLE `SystemLog` DISABLE KEYS */;

INSERT INTO `SystemLog` (`ID`, `UserID`, `UserName`, `Action`, `Success`, `Result`, `Time`, `Data`, `IP`)
VALUES
	(965,92,'a','退出系统',NULL,NULL,'2014-11-29 19:41:34',NULL,'192.168.1.100'),
	(966,NULL,'admin','登录',NULL,'登录成功','2014-11-29 19:41:42','admin','192.168.1.100'),
	(967,10,'admin','修改用户',NULL,'操作成功','2014-11-29 20:42:33','a','192.168.1.100'),
	(968,10,'admin','修改用户',NULL,'操作成功','2014-11-29 20:42:41','b','192.168.1.100'),
	(969,10,'admin','修改用户',NULL,'操作成功','2014-11-29 20:42:45','a','192.168.1.100'),
	(970,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:44:52','低压二班','192.168.1.100'),
	(971,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:44:54','营业一班','192.168.1.100'),
	(972,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:45:03','营业二班','192.168.1.100'),
	(973,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:45:05','低压三班','192.168.1.100'),
	(974,10,'admin','删除用户',NULL,'操作成功','2014-11-29 20:47:34','a','192.168.1.100'),
	(975,10,'admin','删除用户',NULL,'操作成功','2014-11-29 20:47:37','b','192.168.1.100'),
	(976,94,'c','退出系统',NULL,NULL,'2014-11-29 20:48:31',NULL,'192.168.1.133'),
	(977,NULL,'admin','登录',NULL,'登录成功','2014-11-29 20:48:42','admin','192.168.1.133'),
	(978,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:50:16','低压一班','192.168.1.133'),
	(979,10,'admin','创建班组',NULL,'操作成功','2014-11-29 20:52:34','a|抄表','192.168.1.133'),
	(980,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:52:38','a','192.168.1.133'),
	(981,10,'admin','创建班组',NULL,'操作成功','2014-11-29 20:53:38','aa|抄表','192.168.1.133'),
	(982,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:53:42','aa','192.168.1.133'),
	(983,10,'admin','创建班组',NULL,'操作成功','2014-11-29 20:53:53','21|抄表','192.168.1.133'),
	(984,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:54:03','21','192.168.1.133'),
	(985,10,'admin','创建班组',NULL,'操作成功','2014-11-29 20:55:33','a|抄表','192.168.1.133'),
	(986,10,'admin','创建班组',NULL,'操作成功','2014-11-29 20:56:08','a|抄表','192.168.1.133'),
	(987,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:56:17','a','192.168.1.133'),
	(988,10,'admin','删除班组',NULL,'操作成功','2014-11-29 20:56:19','a','192.168.1.133'),
	(989,10,'admin','创建用户',NULL,'操作成功','2014-11-29 20:59:44','s','192.168.1.133'),
	(990,10,'admin','删除用户',NULL,'操作成功','2014-11-29 20:59:54','s','192.168.1.133'),
	(991,10,'admin','创建班组',NULL,'操作成功','2014-11-29 21:00:20','a|抄表','192.168.1.133'),
	(992,10,'admin','创建用户',NULL,'操作成功','2014-11-29 21:00:29','a','192.168.1.133'),
	(993,10,'admin','创建班组',NULL,'操作成功','2014-11-29 21:00:33','b|抄表','192.168.1.133'),
	(994,10,'admin','修改用户',NULL,'操作成功','2014-11-29 21:02:10','a','192.168.1.133'),
	(995,10,'admin','删除用户',NULL,'操作成功','2014-11-29 21:05:06','a','192.168.1.133'),
	(996,10,'admin','删除用户',NULL,'操作成功','2014-11-29 21:05:08','b','192.168.1.133'),
	(997,10,'admin','删除班组',NULL,'操作成功','2014-11-29 21:06:29','a','192.168.1.100'),
	(998,10,'admin','删除班组',NULL,'操作成功','2014-11-29 21:06:31','b','192.168.1.100'),
	(999,10,'admin','创建班组',NULL,'操作成功','2014-11-29 21:06:44','低压一班|抄表','192.168.1.100'),
	(1000,10,'admin','创建班组',NULL,'操作成功','2014-11-29 21:06:49','低压一班|抄表','192.168.1.100'),
	(1001,10,'admin','删除班组',NULL,'操作成功','2014-11-29 21:06:55','低压一班','192.168.1.100'),
	(1002,10,'admin','创建班组',NULL,'操作成功','2014-11-29 21:07:01','低压二班|抄表','192.168.1.100'),
	(1003,10,'admin','修改用户',NULL,'操作成功','2014-11-29 21:07:18','a','192.168.1.100'),
	(1004,10,'admin','修改用户',NULL,'操作成功','2014-11-29 21:07:26','b','192.168.1.100'),
	(1005,10,'admin','创建用户',NULL,'操作成功','2014-11-29 21:07:48','a0','192.168.1.100'),
	(1006,10,'admin','退出系统',NULL,NULL,'2014-11-29 21:08:02',NULL,'192.168.1.100'),
	(1007,NULL,'a','登录',NULL,'登录成功','2014-11-29 21:08:05','a','192.168.1.100'),
	(1008,104,'a','退出系统',NULL,NULL,'2014-11-29 21:08:47',NULL,'192.168.1.100'),
	(1009,NULL,'b','登录',NULL,'登录成功','2014-11-29 21:08:49','b','192.168.1.100'),
	(1010,105,'b','退出系统',NULL,NULL,'2014-11-29 21:10:10',NULL,'192.168.1.100'),
	(1011,NULL,'a0','登录',NULL,'登录成功','2014-11-29 21:10:15','a0','192.168.1.100'),
	(1012,106,'a0','催费','1','操作成功','2014-11-29 21:14:53','电话催费|1|1|201408|￥10','192.168.1.100'),
	(1013,106,'a0','催费','1','操作成功','2014-11-29 21:16:42','电话催费|2|2|201408|￥10','192.168.1.100'),
	(1014,106,'a0','撤销催费',NULL,NULL,'2014-11-29 21:17:49','撤销()于(2014-11-28 16:39)的(电话催费)','192.168.1.100'),
	(1015,106,'a0','催费','1','操作成功','2014-11-29 21:18:09','电话催费|2|2|201410|￥10','192.168.1.100'),
	(1016,10,'admin','退出系统',NULL,NULL,'2014-11-29 21:21:18',NULL,'192.168.1.133'),
	(1017,NULL,'a0','登录',NULL,'登录成功','2014-11-29 21:21:45','a0','192.168.1.133'),
	(1018,106,'a0','催费','1','操作成功','2014-11-29 21:30:21','电话催费|1|1|201409|￥10','192.168.1.100'),
	(1019,106,'a0','催费','1','操作成功','2014-11-29 21:35:54','电话催费|3|3|201408|￥10','192.168.1.100'),
	(1020,106,'a0','催费','1','操作成功','2014-11-29 21:35:54','电话催费|3|3|201409|￥10','192.168.1.100'),
	(1021,106,'a0','催费','1','操作成功','2014-11-29 21:35:54','电话催费|3|3|201410|￥10','192.168.1.100'),
	(1022,106,'a0','停电','1','操作成功','2014-11-29 21:36:17','||(￥)','192.168.1.100'),
	(1023,NULL,'a0','登录',NULL,'登录成功','2014-11-29 21:36:28','a0','192.168.1.133'),
	(1024,106,'a0','停电','1','操作成功','2014-11-29 21:36:30','||(￥)','192.168.1.100'),
	(1025,106,'a0','停电','1','操作成功','2014-11-29 21:38:05','||(￥)','192.168.1.133'),
	(1026,106,'a0','退出系统',NULL,NULL,'2014-11-29 21:39:39',NULL,'192.168.1.100'),
	(1027,NULL,'admin','登录',NULL,'登录成功','2014-11-29 21:39:45','admin','192.168.1.100'),
	(1028,106,'a0','复电','1','操作成功','2014-11-29 21:43:40','1|1','192.168.1.133'),
	(1029,106,'a0','退出系统',NULL,NULL,'2014-11-29 21:44:40',NULL,'192.168.1.133'),
	(1030,NULL,'admin','登录',NULL,'登录成功','2014-11-29 21:44:44','admin','192.168.1.133'),
	(1031,10,'admin','创建班组',NULL,'操作成功','2014-11-29 21:50:53','收费组|收费','192.168.1.133'),
	(1032,10,'admin','退出系统',NULL,NULL,'2014-11-29 21:52:53',NULL,'192.168.1.100'),
	(1033,NULL,'admin','登录',NULL,'登录成功','2014-11-29 21:53:07','admin','192.168.1.100'),
	(1034,10,'admin','创建用户',NULL,'操作成功','2014-11-29 21:53:32','sf','192.168.1.100'),
	(1035,10,'admin','退出系统',NULL,NULL,'2014-11-29 21:53:35',NULL,'192.168.1.100'),
	(1036,NULL,'sf','登录',NULL,'登录成功','2014-11-29 21:53:37','sf','192.168.1.100'),
	(1037,107,'sf','收费','1','操作成功','2014-11-29 21:53:55','1|1|201410|￥10','192.168.1.100'),
	(1038,107,'sf','收费','1','操作成功','2014-11-29 21:53:55','1|1|201409|￥10','192.168.1.100'),
	(1039,107,'sf','收费','1','操作成功','2014-11-29 21:53:55','1|1|201408|￥10','192.168.1.100'),
	(1040,107,'sf','收费','1','操作成功','2014-11-29 21:54:08','2|2|201409|￥10','192.168.1.100'),
	(1041,107,'sf','收费','1','操作成功','2014-11-29 21:54:08','2|2|201408|￥10','192.168.1.100'),
	(1042,107,'sf','退出系统',NULL,NULL,'2014-11-29 21:54:12',NULL,'192.168.1.100'),
	(1043,NULL,'admin','登录',NULL,'登录成功','2014-11-29 21:54:16','admin','192.168.1.100'),
	(1044,10,'admin','退出系统',NULL,NULL,'2014-11-29 21:54:28',NULL,'192.168.1.100'),
	(1045,NULL,'a','登录',NULL,'登录成功','2014-11-29 21:54:41','a','192.168.1.100'),
	(1046,106,'a0','退出系统',NULL,NULL,'2014-11-29 21:57:25',NULL,'192.168.1.133'),
	(1047,NULL,'a0','登录',NULL,'登录成功','2014-11-29 21:57:31','a0','192.168.1.133'),
	(1048,106,'a0','退出系统',NULL,NULL,'2014-11-29 21:58:05',NULL,'192.168.1.133'),
	(1049,NULL,'a','登录',NULL,'登录成功','2014-11-29 21:58:36','a','192.168.1.133'),
	(1050,10,'admin','退出系统',NULL,NULL,'2014-11-29 21:58:51',NULL,'192.168.1.133'),
	(1051,NULL,'a','登录',NULL,'登录成功','2014-11-29 21:58:55','a','192.168.1.133'),
	(1052,104,'a','退出系统',NULL,NULL,'2014-11-29 22:01:12',NULL,'192.168.1.100'),
	(1053,NULL,'a0','登录',NULL,'登录成功','2014-11-29 22:01:16','a0','192.168.1.100'),
	(1054,106,'a0','退出系统',NULL,NULL,'2014-11-29 22:03:29',NULL,'192.168.1.100'),
	(1055,NULL,'a','登录',NULL,'登录成功','2014-11-29 22:03:31','a','192.168.1.100'),
	(1056,104,'a','退出系统',NULL,NULL,'2014-11-29 22:04:02',NULL,'192.168.1.100'),
	(1057,NULL,'admin','登录',NULL,'登录成功','2014-11-29 22:04:07','admin','192.168.1.100'),
	(1058,10,'admin','退出系统',NULL,NULL,'2014-11-29 22:08:22',NULL,'192.168.1.100'),
	(1059,NULL,'a','登录',NULL,'登录成功','2014-11-29 22:08:27','a','192.168.1.100'),
	(1060,104,'a','退出系统',NULL,NULL,'2014-11-29 22:08:55',NULL,'192.168.1.100'),
	(1061,NULL,'admin','登录',NULL,'登录成功','2014-11-29 22:09:00','admin','192.168.1.100'),
	(1062,10,'admin','退出系统',NULL,NULL,'2014-11-29 22:10:53',NULL,'192.168.1.100'),
	(1063,NULL,'a','登录',NULL,'登录成功','2014-11-29 22:10:59','a','192.168.1.100'),
	(1064,104,'a','退出系统',NULL,NULL,'2014-11-29 22:58:50',NULL,'192.168.1.100'),
	(1065,NULL,'admin','登录',NULL,'登录成功','2014-11-29 22:58:55','admin','192.168.1.100'),
	(1066,10,'admin','退出系统',NULL,NULL,'2014-11-29 23:03:02',NULL,'192.168.1.100'),
	(1067,NULL,'admin','登录',NULL,'登录成功','2014-11-29 23:03:07','admin','192.168.1.100'),
	(1068,10,'admin','催费','1','操作成功','2014-12-01 15:00:18','通知单催费|3|3|201410|￥10','192.168.1.100'),
	(1069,NULL,'admin','登录',NULL,'登录成功','2014-12-01 15:06:45','admin','192.168.1.133'),
	(1070,10,'admin','退出系统',NULL,NULL,'2014-12-01 15:11:30',NULL,'192.168.1.100'),
	(1071,NULL,'a','登录',NULL,'登录成功','2014-12-01 15:11:38','a','192.168.1.100'),
	(1072,104,'a','退出系统',NULL,NULL,'2014-12-01 15:14:55',NULL,'192.168.1.100'),
	(1073,NULL,'sf','登录',NULL,'登录成功','2014-12-01 15:15:06','sf','192.168.1.100'),
	(1074,10,'admin','催费','1','操作成功','2014-12-01 15:15:21','电话催费|3|3|201408|￥10','192.168.1.133'),
	(1075,10,'admin','退出系统',NULL,NULL,'2014-12-01 15:16:19',NULL,'192.168.1.133'),
	(1076,NULL,'sf','登录',NULL,'登录成功','2014-12-01 15:16:22','sf','192.168.1.133'),
	(1077,107,'sf','退出系统',NULL,NULL,'2014-12-01 15:17:29',NULL,'192.168.1.100'),
	(1078,NULL,'a','登录',NULL,'登录成功','2014-12-01 15:17:34','a','192.168.1.100'),
	(1079,104,'a','复电','1','操作成功','2014-12-01 15:22:55','1|1','192.168.1.100'),
	(1080,104,'a','退出系统',NULL,NULL,'2014-12-01 15:25:11',NULL,'192.168.1.100'),
	(1081,NULL,'sf','登录',NULL,'登录成功','2014-12-01 15:25:15','sf','192.168.1.100'),
	(1082,107,'sf','撤销收费',NULL,'操作成功','2014-12-01 15:25:29','2|2|201409|￥10','192.168.1.100'),
	(1083,107,'sf','退出系统',NULL,NULL,'2014-12-01 15:25:34',NULL,'192.168.1.100'),
	(1084,NULL,'a','登录',NULL,'登录成功','2014-12-01 15:25:41','a','192.168.1.100'),
	(1085,107,'sf','退出系统',NULL,NULL,'2014-12-01 15:28:53',NULL,'192.168.1.133'),
	(1086,NULL,'admin','登录',NULL,'登录成功','2014-12-01 15:29:02','admin','192.168.1.133'),
	(1087,104,'a','退出系统',NULL,NULL,'2014-12-01 15:29:14',NULL,'192.168.1.100'),
	(1088,NULL,'admin','登录',NULL,'登录成功','2014-12-01 15:29:18','admin','192.168.1.100'),
	(1089,10,'admin','创建用户',NULL,'操作成功','2014-12-01 15:29:48','c','192.168.1.100'),
	(1090,10,'admin','创建用户',NULL,'操作成功','2014-12-01 15:30:12','d','192.168.1.100'),
	(1091,10,'admin','创建用户',NULL,'操作成功','2014-12-01 15:30:35','a1','192.168.1.100'),
	(1092,10,'admin','退出系统',NULL,NULL,'2014-12-01 15:30:44',NULL,'192.168.1.100'),
	(1093,10,'admin','复电','1','操作成功','2014-12-01 15:30:49','3|3','192.168.1.133'),
	(1094,NULL,'a0','登录',NULL,'登录成功','2014-12-01 15:30:50','a0','192.168.1.100'),
	(1095,106,'a0','退出系统',NULL,NULL,'2014-12-01 15:32:10',NULL,'192.168.1.100'),
	(1096,NULL,'a','登录',NULL,'登录成功','2014-12-01 15:32:14','a','192.168.1.100'),
	(1097,10,'admin','撤销催费',NULL,NULL,'2014-12-01 15:35:29','撤销()于(2014-11-30 10:23)的(通知单催费)','192.168.1.133'),
	(1098,104,'a','退出系统',NULL,NULL,'2014-12-01 15:38:03',NULL,'192.168.1.100'),
	(1099,NULL,'admin','登录',NULL,'登录成功','2014-12-01 15:38:07','admin','192.168.1.100'),
	(1100,10,'admin','退出系统',NULL,NULL,'2014-12-01 15:40:43',NULL,'192.168.1.100'),
	(1101,NULL,'a','登录',NULL,'登录成功','2014-12-01 15:40:46','a','192.168.1.100'),
	(1102,104,'a','退出系统',NULL,NULL,'2014-12-01 15:41:03',NULL,'192.168.1.100'),
	(1103,NULL,'a0','登录',NULL,'登录成功','2014-12-01 15:41:09','a0','192.168.1.100'),
	(1104,10,'admin','退出系统',NULL,NULL,'2014-12-01 15:42:03',NULL,'192.168.1.133'),
	(1105,NULL,'a0','登录',NULL,'登录成功','2014-12-01 15:42:13','a0','192.168.1.133'),
	(1106,106,'a0','退出系统',NULL,NULL,'2014-12-01 15:45:31',NULL,'192.168.1.100'),
	(1107,NULL,'a1','登录',NULL,'登录成功','2014-12-01 15:45:37','a1','192.168.1.100'),
	(1108,110,'a1','退出系统',NULL,NULL,'2014-12-01 15:51:52',NULL,'192.168.1.100'),
	(1109,NULL,'sf','登录',NULL,'登录成功','2014-12-01 15:51:54','sf','192.168.1.100'),
	(1110,107,'sf','收费','1','操作成功','2014-12-01 15:52:29','5|5|201410|￥10','192.168.1.100'),
	(1111,107,'sf','退出系统',NULL,NULL,'2014-12-01 15:52:32',NULL,'192.168.1.100'),
	(1112,NULL,'a1','登录',NULL,'登录成功','2014-12-01 15:52:40','a1','192.168.1.100'),
	(1113,110,'a1','退出系统',NULL,NULL,'2014-12-01 15:53:25',NULL,'192.168.1.100'),
	(1114,NULL,'a0','登录',NULL,'登录成功','2014-12-01 15:53:29','a0','192.168.1.100'),
	(1115,NULL,'a0','登录',NULL,'登录成功','2014-12-01 15:55:15','a0','192.168.1.133'),
	(1116,106,'a0','退出系统',NULL,NULL,'2014-12-01 16:07:03',NULL,'192.168.1.100'),
	(1117,NULL,'a1','登录',NULL,'登录成功','2014-12-01 16:07:07','a1','192.168.1.100'),
	(1118,110,'a1','退出系统',NULL,NULL,'2014-12-01 16:07:28',NULL,'192.168.1.100'),
	(1119,NULL,'a0','登录',NULL,'登录成功','2014-12-01 16:07:31','a0','192.168.1.100'),
	(1120,106,'a0','退出系统',NULL,NULL,'2014-11-30 23:00:57',NULL,'192.168.1.100'),
	(1121,NULL,'sf','登录',NULL,'登录成功','2014-11-30 23:01:00','sf','192.168.1.100'),
	(1122,107,'sf','退出系统',NULL,NULL,'2014-11-30 23:03:13',NULL,'192.168.1.100'),
	(1123,NULL,'a1','登录',NULL,'登录成功','2014-11-30 23:03:21','a1','192.168.1.100'),
	(1124,110,'a1','退出系统',NULL,NULL,'2014-12-01 23:00:01',NULL,'192.168.1.100'),
	(1125,NULL,'sf','登录',NULL,'登录成功','2014-12-01 23:00:05','sf','192.168.1.100'),
	(1126,107,'sf','收费','1','操作成功','2014-12-01 23:00:19','7|7|201408|￥10','192.168.1.100'),
	(1127,107,'sf','退出系统',NULL,NULL,'2014-12-01 23:00:22',NULL,'192.168.1.100'),
	(1128,NULL,'a1','登录',NULL,'登录成功','2014-12-01 23:00:26','a1','192.168.1.100'),
	(1129,110,'a1','退出系统',NULL,NULL,'2014-12-02 23:00:37',NULL,'192.168.1.100'),
	(1130,NULL,'a0','登录',NULL,'登录成功','2014-12-02 23:00:41','a0','192.168.1.100'),
	(1131,106,'a0','退出系统',NULL,NULL,'2014-12-02 23:00:58',NULL,'192.168.1.100'),
	(1132,NULL,'a1','登录',NULL,'登录成功','2014-12-02 23:01:03','a1','192.168.1.100'),
	(1133,110,'a1','退出系统',NULL,NULL,'2014-12-02 23:01:36',NULL,'192.168.1.100'),
	(1134,NULL,'sf','登录',NULL,'登录成功','2014-12-02 23:01:38','sf','192.168.1.100'),
	(1135,106,'a0','退出系统',NULL,NULL,'2014-12-02 23:02:20',NULL,'192.168.1.133'),
	(1136,NULL,'admin','登录',NULL,'登录成功','2014-12-02 23:02:25','admin','192.168.1.133'),
	(1137,107,'sf','退出系统',NULL,NULL,'2014-12-02 23:04:00',NULL,'192.168.1.100'),
	(1138,NULL,'admin','登录',NULL,'登录成功','2014-12-02 23:04:04','admin','192.168.1.100'),
	(1139,10,'admin','撤销催费',NULL,NULL,'2014-12-03 00:14:40','撤销()于(2014-11-30 10:38)的(电话催费)','192.168.1.133'),
	(1140,10,'admin','催费','1','操作成功','2014-12-03 00:14:56','电话催费|3|3|201410|￥10','192.168.1.133'),
	(1141,10,'admin','催费','1','操作成功','2014-12-03 00:53:06','电话催费|4|4|201410|￥10','192.168.1.133'),
	(1142,10,'admin','催费','1','操作成功','2014-12-03 00:57:18','电话催费|6|6|201410|￥10','192.168.1.133'),
	(1143,10,'admin','催费','1','操作成功','2014-12-03 01:02:52','电话催费|7|7|201410|￥10','192.168.1.133'),
	(1144,10,'admin','催费','1','操作成功','2014-12-03 01:17:16','通知单催费|8|8|201410|￥10','192.168.1.100'),
	(1145,10,'admin','催费','1','操作成功','2014-12-03 01:17:16','通知单催费|8|8|201409|￥10','192.168.1.100'),
	(1146,10,'admin','催费','1','操作成功','2014-12-03 01:17:16','通知单催费|8|8|201408|￥10','192.168.1.100'),
	(1147,10,'admin','催费','1','操作成功','2014-12-03 01:20:56','电话催费|5|5|201409|￥10','192.168.1.100'),
	(1148,10,'admin','催费','1','操作成功','2014-12-03 01:20:56','电话催费|5|5|201408|￥10','192.168.1.100'),
	(1149,10,'admin','催费','1','操作成功','2014-12-03 01:21:29','电话催费|5|5|201409|￥10','192.168.1.100'),
	(1150,10,'admin','催费','1','操作成功','2014-12-03 01:21:29','电话催费|5|5|201408|￥10','192.168.1.100'),
	(1151,10,'admin','催费','1','操作成功','2014-12-03 01:23:39','电话催费|6|6|201410|￥10','192.168.1.100'),
	(1152,10,'admin','催费','1','操作成功','2014-12-03 01:23:39','电话催费|6|6|201409|￥10','192.168.1.100'),
	(1153,10,'admin','催费','1','操作成功','2014-12-03 01:23:39','电话催费|6|6|201408|￥10','192.168.1.100'),
	(1154,10,'admin','催费','1','操作成功','2014-12-03 01:23:52','电话催费|6|6|201410|￥10','192.168.1.100'),
	(1155,10,'admin','催费','1','操作成功','2014-12-03 01:23:52','电话催费|6|6|201409|￥10','192.168.1.100'),
	(1156,10,'admin','催费','1','操作成功','2014-12-03 01:23:52','电话催费|6|6|201408|￥10','192.168.1.100'),
	(1157,10,'admin','撤销催费',NULL,NULL,'2014-12-03 01:24:38','撤销()于(2014-11-28 16:41)的(电话催费)','192.168.1.100'),
	(1158,10,'admin','撤销催费',NULL,NULL,'2014-12-03 01:25:08','撤销()于(2014-11-30 13:55)的(通知单催费)撤销()于(2014-11-30 13:55)的(通知单催费)撤销()于(2014-11-30 13:55)的(通知单催费)','192.168.1.100'),
	(1159,10,'admin','退出系统',NULL,NULL,'2014-12-03 01:29:47',NULL,'192.168.1.100'),
	(1160,NULL,'sf','登录',NULL,'登录成功','2014-12-03 01:29:49','sf','192.168.1.100'),
	(1161,107,'sf','退出系统',NULL,NULL,'2014-12-03 01:30:38',NULL,'192.168.1.100'),
	(1162,NULL,'a0','登录',NULL,'登录成功','2014-12-03 01:30:52','a0','192.168.1.100'),
	(1163,106,'a0','复电','1','操作成功','2014-12-03 01:35:05','3|3','192.168.1.100'),
	(1164,106,'a0','复电','1','操作成功','2014-12-03 01:58:58','3|3','192.168.1.100'),
	(1165,106,'a0','复电','1','操作成功','2014-12-03 02:01:51','3|3','192.168.1.100'),
	(1166,106,'a0','撤销催费',NULL,NULL,'2014-12-03 02:05:53','撤销()于(2014-11-28 16:59)的(电话催费)','192.168.1.100'),
	(1167,106,'a0','催费','1','操作成功','2014-12-03 02:07:31','电话催费|4|4|201408|￥10','192.168.1.100'),
	(1168,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:19:39',NULL,'192.168.1.100'),
	(1169,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:19:41','sf','192.168.1.100'),
	(1170,107,'sf','撤销收费',NULL,'操作成功','2014-12-03 02:19:52','1|1|201410|￥10|201409|￥10|201408|￥10','192.168.1.100'),
	(1171,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:19:56',NULL,'192.168.1.100'),
	(1172,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:20:00','a0','192.168.1.100'),
	(1173,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:22:04',NULL,'192.168.1.100'),
	(1174,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:22:09','sf','192.168.1.100'),
	(1175,107,'sf','收费','1','操作成功','2014-12-03 02:22:29','1|1|201410|￥10','192.168.1.100'),
	(1176,107,'sf','收费','1','操作成功','2014-12-03 02:22:29','1|1|201409|￥10','192.168.1.100'),
	(1177,107,'sf','收费','1','操作成功','2014-12-03 02:22:29','1|1|201408|￥10','192.168.1.100'),
	(1178,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:22:36',NULL,'192.168.1.100'),
	(1179,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:22:39','a0','192.168.1.100'),
	(1180,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:26:50',NULL,'192.168.1.100'),
	(1181,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:26:52','sf','192.168.1.100'),
	(1182,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:27:57',NULL,'192.168.1.100'),
	(1183,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:28:00','a0','192.168.1.100'),
	(1184,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:28:10',NULL,'192.168.1.100'),
	(1185,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:28:12','sf','192.168.1.100'),
	(1186,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:30:41',NULL,'192.168.1.100'),
	(1187,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:30:44','a0','192.168.1.100'),
	(1188,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:30:58',NULL,'192.168.1.100'),
	(1189,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:31:00','sf','192.168.1.100'),
	(1190,107,'sf','收费','1','操作成功','2014-12-03 02:31:23','1|1|201408|￥10','192.168.1.100'),
	(1191,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:31:31',NULL,'192.168.1.100'),
	(1192,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:31:36','a0','192.168.1.100'),
	(1193,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:42:24',NULL,'192.168.1.100'),
	(1194,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:42:28','sf','192.168.1.100'),
	(1195,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:42:38','sf','192.168.1.133'),
	(1196,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:43:19',NULL,'192.168.1.100'),
	(1197,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:43:24','a0','192.168.1.100'),
	(1198,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:45:16',NULL,'192.168.1.133'),
	(1199,NULL,'a','登录',NULL,'登录成功','2014-12-03 02:45:25','a','192.168.1.133'),
	(1200,104,'a','退出系统',NULL,NULL,'2014-12-03 02:47:58',NULL,'192.168.1.133'),
	(1201,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:48:06','sf','192.168.1.133'),
	(1202,NULL,'a','登录',NULL,'登录成功','2014-12-03 02:49:02','a','192.168.1.133'),
	(1203,106,'a0','退出系统',NULL,NULL,'2014-12-03 02:53:22',NULL,'192.168.1.100'),
	(1204,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:53:24','sf','192.168.1.100'),
	(1205,107,'sf','收费','1','操作成功','2014-12-03 02:53:31','1|1|201410|￥20','192.168.1.100'),
	(1206,107,'sf','收费','1','操作成功','2014-12-03 02:53:43','1|1|201410|￥20','192.168.1.100'),
	(1207,104,'a','退出系统',NULL,NULL,'2014-12-03 02:53:49',NULL,'192.168.1.133'),
	(1208,NULL,'sf','登录',NULL,'登录成功','2014-12-03 02:53:56','sf','192.168.1.133'),
	(1209,107,'sf','收费','1','操作成功','2014-12-03 02:54:01','1|1|201410|￥20','192.168.1.100'),
	(1210,107,'sf','收费','1','操作成功','2014-12-03 02:54:17','1|1|201409|￥30','192.168.1.133'),
	(1211,107,'sf','收费','1','操作成功','2014-12-03 02:55:23','1|1|201410|￥20','192.168.1.100'),
	(1212,107,'sf','退出系统',NULL,NULL,'2014-12-03 02:55:26',NULL,'192.168.1.100'),
	(1213,NULL,'a0','登录',NULL,'登录成功','2014-12-03 02:55:30','a0','192.168.1.100'),
	(1214,106,'a0','退出系统',NULL,NULL,'2014-12-03 03:20:13',NULL,'192.168.1.100'),
	(1215,NULL,'sf','登录',NULL,'登录成功','2014-12-03 03:20:16','sf','192.168.1.100'),
	(1216,107,'sf','退出系统',NULL,NULL,'2014-12-03 03:20:37',NULL,'192.168.1.100'),
	(1217,NULL,'a','登录',NULL,'登录成功','2014-12-03 03:20:40','a','192.168.1.100'),
	(1218,104,'a','退出系统',NULL,NULL,'2014-12-03 03:20:50',NULL,'192.168.1.100'),
	(1219,NULL,'sf','登录',NULL,'登录成功','2014-12-03 03:20:53','sf','192.168.1.100'),
	(1220,107,'sf','撤销收费',NULL,'操作成功','2014-12-03 03:30:38','1|1|201409|￥30','192.168.1.100'),
	(1221,107,'sf','退出系统',NULL,NULL,'2014-12-03 03:49:48',NULL,'192.168.1.133'),
	(1222,NULL,'c','登录',NULL,'登录成功','2014-12-03 03:50:00','c','192.168.1.133'),
	(1223,107,'sf','退出系统',NULL,NULL,'2014-12-03 03:57:30',NULL,'192.168.1.100'),
	(1224,NULL,'sf','登录',NULL,'登录成功','2014-12-03 03:57:50','sf','192.168.1.100'),
	(1225,107,'sf','收费','1','操作成功','2014-12-03 03:57:58','1|1|201409|￥30','192.168.1.100'),
	(1226,107,'sf','收费','1','操作成功','2014-12-03 03:59:00','2|2|201410|￥10','192.168.1.100'),
	(1227,107,'sf','退出系统',NULL,NULL,'2014-12-03 03:59:27',NULL,'192.168.1.100'),
	(1228,NULL,'a0','登录',NULL,'登录成功','2014-12-03 03:59:31','a0','192.168.1.100'),
	(1229,106,'a0','退出系统',NULL,NULL,'2014-12-03 04:00:25',NULL,'192.168.1.100'),
	(1230,NULL,'sf','登录',NULL,'登录成功','2014-12-03 04:00:28','sf','192.168.1.100'),
	(1231,107,'sf','撤销收费',NULL,'操作成功','2014-12-03 04:00:46','2|2|201408|￥10|201410|￥10','192.168.1.100'),
	(1232,107,'sf','退出系统',NULL,NULL,'2014-12-03 04:00:49',NULL,'192.168.1.100'),
	(1233,NULL,'a0','登录',NULL,'登录成功','2014-12-03 04:00:54','a0','192.168.1.100'),
	(1234,NULL,'admin','登录',NULL,'登录成功','2014-12-03 07:20:03','admin','101.254.18.77'),
	(1235,10,'admin','创建班组',NULL,'操作成功','2014-12-03 07:30:51','低压三班|抄表','101.254.18.77'),
	(1236,10,'admin','创建班组',NULL,'操作成功','2014-12-03 07:30:58','低压四班|抄表','101.254.18.77'),
	(1237,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:31:31','4a','101.254.18.77'),
	(1238,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:31:46','4b','101.254.18.77'),
	(1239,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:31:58','4c','101.254.18.77'),
	(1240,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:32:07','3c','101.254.18.77'),
	(1241,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:32:30','3a','101.254.18.77'),
	(1242,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:32:37','3b','101.254.18.77'),
	(1243,10,'admin','创建班组',NULL,'操作成功','2014-12-03 07:33:12','营业一班|收费','101.254.18.77'),
	(1244,10,'admin','创建班组',NULL,'操作成功','2014-12-03 07:33:17','营业二班|收费','101.254.18.77'),
	(1245,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:33:47','s1','101.254.18.77'),
	(1246,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:33:53','s2','101.254.18.77'),
	(1247,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:34:00','s3','101.254.18.77'),
	(1248,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:34:22','2s3','101.254.18.77'),
	(1249,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:34:38','2s1','101.254.18.77'),
	(1250,10,'admin','创建用户',NULL,'操作成功','2014-12-03 07:34:43','2s2','101.254.18.77'),
	(1251,10,'admin','删除用户',NULL,'操作成功','2014-12-03 07:56:24','3a','101.254.18.77'),
	(1252,10,'admin','创建班组',NULL,'操作成功','2014-12-03 07:59:28','低压5班|抄表','101.254.18.77'),
	(1253,10,'admin','创建班组',NULL,'操作成功','2014-12-03 07:59:33','低压6班|抄表','101.254.18.77'),
	(1254,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:00:16','5a','101.254.18.77'),
	(1255,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:00:21','5b','101.254.18.77'),
	(1256,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:00:29','5c','101.254.18.77'),
	(1257,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:00:40','6c','101.254.18.77'),
	(1258,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:00:50','6a','101.254.18.77'),
	(1259,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:00:54','6b','101.254.18.77'),
	(1260,NULL,'5c','登录',NULL,'登录成功','2014-12-03 08:02:07','5c','101.254.18.77'),
	(1261,NULL,'5a','登录',NULL,'登录成功','2014-12-03 08:03:10','5a','101.254.18.77'),
	(1262,123,'5a','催费','1','操作成功','2014-12-03 08:05:56','电话催费|yy1|0380900001|201407|￥20','101.254.18.77'),
	(1263,123,'5a','催费','1','操作成功','2014-12-03 08:06:36','电话催费|yy1|0380900001|201407|￥20','101.254.18.77'),
	(1264,123,'5a','催费','1','操作成功','2014-12-03 08:07:27','通知单催费|yy2|0380900002|201407|￥20','101.254.18.192'),
	(1265,123,'5a','催费','1','操作成功','2014-12-03 08:09:24','通知单催费|yy2|0380900002|201407|￥20','101.254.18.192'),
	(1266,123,'5a','撤销催费',NULL,NULL,'2014-12-03 08:11:30','撤销()于(2014-11-30 20:46)的(通知单催费)','101.254.18.192'),
	(1267,123,'5a','复电','1','操作成功','2014-12-03 08:12:34','yy1|0380900001','101.254.18.192'),
	(1268,NULL,'2s1','登录',NULL,'登录成功','2014-12-03 08:36:35','2s1','101.254.18.192'),
	(1269,121,'2s1','收费','1','操作成功','2014-12-03 08:37:00','yy1|0380900001|201407|￥20','101.254.18.192'),
	(1270,121,'2s1','收费','1','操作成功','2014-12-03 08:42:46','yy2|0380900002|201407|￥20','101.254.18.192'),
	(1271,10,'admin','创建用户',NULL,'操作成功','2014-12-03 08:52:56','m','101.254.18.192'),
	(1272,NULL,'m','登录',NULL,'登录成功','2014-12-03 08:53:05','m','101.254.18.192'),
	(1273,106,'a0','退出系统',NULL,NULL,'2014-12-03 20:35:23',NULL,'192.168.1.100'),
	(1274,NULL,'admin','登录',NULL,'登录成功','2014-12-03 20:35:31','admin','192.168.1.100'),
	(1275,10,'admin','退出系统',NULL,NULL,'2014-12-03 20:35:54',NULL,'192.168.1.100'),
	(1276,NULL,'5c','登录',NULL,'登录成功','2014-12-03 20:35:57','5c','192.168.1.100'),
	(1277,NULL,'admin','登录',NULL,'登录成功','2014-12-03 22:00:03','admin','192.168.1.140'),
	(1278,108,'c','退出系统',NULL,NULL,'2014-12-03 22:00:46',NULL,'192.168.1.48'),
	(1279,NULL,'5a','登录',NULL,'登录成功','2014-12-03 22:39:31','5a','192.168.1.48'),
	(1280,NULL,'5a','登录',NULL,'登录成功','2014-12-03 22:40:19','5a','192.168.1.48'),
	(1281,123,'5a','退出系统',NULL,NULL,'2014-12-03 22:53:51',NULL,'192.168.1.48'),
	(1282,NULL,'5b','登录',NULL,'登录成功','2014-12-03 22:53:59','5b','192.168.1.48'),
	(1283,123,'5a','退出系统',NULL,NULL,'2014-12-03 23:14:19',NULL,'192.168.1.48'),
	(1284,NULL,'5c','登录',NULL,'登录成功','2014-12-03 23:14:23','5c','192.168.1.48'),
	(1285,125,'5c','退出系统',NULL,NULL,'2014-12-03 23:14:25',NULL,'192.168.1.100'),
	(1286,NULL,'5a','登录',NULL,'登录成功','2014-12-03 23:14:28','5a','192.168.1.100'),
	(1287,NULL,'admin','登录',NULL,'登录成功','2014-12-03 23:21:20','admin','192.168.1.140'),
	(1288,123,'5a','复电','1','操作成功','2014-12-03 23:22:23','yy6|0380900010','192.168.1.100'),
	(1289,125,'5c','退出系统',NULL,NULL,'2014-12-03 23:26:05',NULL,'192.168.1.48'),
	(1290,NULL,'admin','登录',NULL,'登录成功','2014-12-03 23:26:10','admin','192.168.1.48'),
	(1291,123,'5a','退出系统',NULL,NULL,'2014-12-03 23:26:48',NULL,'192.168.1.100'),
	(1292,NULL,'admin','登录',NULL,'登录成功','2014-12-03 23:26:52','admin','192.168.1.100'),
	(1293,10,'admin','退出系统',NULL,NULL,'2014-12-03 23:45:50',NULL,'192.168.1.48');

/*!40000 ALTER TABLE `SystemLog` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Team
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Team`;

CREATE TABLE `Team` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  `TypeName` varchar(25) DEFAULT NULL,
  `LineNumber` int(11) DEFAULT NULL COMMENT '指标线',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Team` WRITE;
/*!40000 ALTER TABLE `Team` DISABLE KEYS */;

INSERT INTO `Team` (`ID`, `Name`, `Type`, `TypeName`, `LineNumber`)
VALUES
	(59,'低压四班',1,'抄表',NULL),
	(54,'低压一班',1,'抄表',60),
	(56,'低压二班',1,'抄表',30),
	(57,'收费组',2,'收费',NULL),
	(58,'低压三班',1,'抄表',NULL),
	(60,'营业一班',2,'收费',NULL),
	(61,'营业二班',2,'收费',NULL),
	(62,'低压5班',1,'抄表',50),
	(63,'低压6班',1,'抄表',NULL);

/*!40000 ALTER TABLE `Team` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table User
# ------------------------------------------------------------

DROP TABLE IF EXISTS `User`;

CREATE TABLE `User` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(25) NOT NULL DEFAULT '',
  `Pass` varchar(50) NOT NULL DEFAULT '',
  `Role` int(11) NOT NULL DEFAULT '1',
  `RoleName` varchar(25) DEFAULT NULL,
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreateUser` int(11) DEFAULT NULL,
  `TeamID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;

INSERT INTO `User` (`ID`, `Name`, `Pass`, `Role`, `RoleName`, `CreateTime`, `CreateUser`, `TeamID`)
VALUES
	(10,'admin','40bd001563085fc35165329ea1ff5c5ecbdbbeef',7,NULL,'2014-06-07 01:05:29',NULL,-1),
	(104,'a','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员',NULL,NULL,54),
	(105,'b','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员',NULL,NULL,54),
	(106,'a0','356a192b7913b04c54574d18c28d46e6395428ab',2,'抄表员班长','2014-11-29 21:07:48',NULL,54),
	(107,'sf','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-11-29 21:53:32',NULL,57),
	(108,'c','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-01 15:29:48',NULL,56),
	(109,'d','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-01 15:30:12',NULL,56),
	(110,'21111','356a192b7913b04c54574d18c28d46e6395428ab',2,'抄表员班长','2014-12-01 15:30:35',NULL,56),
	(111,'4a','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 07:31:31',NULL,59),
	(112,'4b','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 07:31:46',NULL,59),
	(113,'4c','356a192b7913b04c54574d18c28d46e6395428ab',2,'抄表员班长','2014-12-03 07:31:58',NULL,59),
	(114,'3c','356a192b7913b04c54574d18c28d46e6395428ab',2,'抄表员班长','2014-12-03 07:32:07',NULL,58),
	(116,'3b','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 07:32:37',NULL,58),
	(117,'s1','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-12-03 07:33:47',NULL,60),
	(118,'s2','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-12-03 07:33:53',NULL,60),
	(119,'s3','356a192b7913b04c54574d18c28d46e6395428ab',4,'收费员班长','2014-12-03 07:34:00',NULL,60),
	(120,'2s3','356a192b7913b04c54574d18c28d46e6395428ab',4,'收费员班长','2014-12-03 07:34:22',NULL,61),
	(121,'2s1','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-12-03 07:34:38',NULL,61),
	(122,'2s2','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-12-03 07:34:43',NULL,61),
	(123,'5a','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 08:00:16',NULL,62),
	(124,'5b','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 08:00:21',NULL,62),
	(125,'5c','356a192b7913b04c54574d18c28d46e6395428ab',2,'抄表员班长','2014-12-03 08:00:29',NULL,62),
	(126,'6c','356a192b7913b04c54574d18c28d46e6395428ab',2,'抄表员班长','2014-12-03 08:00:40',NULL,63),
	(127,'6a','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 08:00:50',NULL,63),
	(128,'6b','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-12-03 08:00:54',NULL,63),
	(129,'m','356a192b7913b04c54574d18c28d46e6395428ab',6,'管理人员','2014-12-03 08:52:56',NULL,59);

/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table UserModule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `UserModule`;

CREATE TABLE `UserModule` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户权限表',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table UserMoney
# ------------------------------------------------------------

DROP TABLE IF EXISTS `UserMoney`;

CREATE TABLE `UserMoney` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `UserName` varchar(25) DEFAULT NULL,
  `Month` char(6) DEFAULT NULL,
  `Money` float DEFAULT NULL COMMENT '应收电费',
  `House` int(11) DEFAULT NULL COMMENT '应收户数',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `UserMoney` WRITE;
/*!40000 ALTER TABLE `UserMoney` DISABLE KEYS */;

INSERT INTO `UserMoney` (`ID`, `UserID`, `UserName`, `Month`, `Money`, `House`)
VALUES
	(99,104,'a','201411',30,2),
	(100,105,'b','201411',30,2),
	(101,104,'a','201410',30,2),
	(102,105,'b','201410',30,2),
	(103,104,'a','201408',30,2),
	(104,105,'b','201408',30,2),
	(105,104,'a','201409',0,0),
	(106,105,'b','201409',0,0),
	(107,123,'5a','201407',80,4),
	(108,124,'5b','201407',80,4),
	(109,123,'5a','201408',160,8),
	(110,124,'5b','201408',160,8);

/*!40000 ALTER TABLE `UserMoney` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
