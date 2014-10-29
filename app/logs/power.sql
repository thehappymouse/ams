# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 192.168.1.5 (MySQL 5.5.8)
# Database: power
# Generation Time: 2014-10-29 01:42:48 +0000
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
  PRIMARY KEY (`ID`),
  UNIQUE KEY `YearMonth` (`YearMonth`,`CustomerNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table Charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Charge`;

CREATE TABLE `Charge` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerNumber` varchar(25) NOT NULL,
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
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
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



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
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `CutInfo` WRITE;
/*!40000 ALTER TABLE `CutInfo` DISABLE KEYS */;

INSERT INTO `CutInfo` (`ID`, `Arrear`, `CustomerNumber`, `CutStyle`, `CutTime`, `CutUser`, `CutUserName`, `ResetTime`, `ResetUser`, `ResetPhone`, `ResetStyle`, `Segment`, `YearMonth`, `Money`)
VALUES
	(1,1,'0271170668','远程停电','2014-10-27 15:38',NULL,'范明杰','2014-10-27 18:09',0,NULL,'远程复电','QC5DA201','201301',1),
	(2,2,'0268490881','远程停电','2014-10-27 15:38',NULL,'王军','2014-10-27 17:20',0,'','远程复电','QC5DA152','201301',3),
	(3,3,'0270401503','远程停电','2014-10-27 15:38',NULL,'姜恒','2014-10-27 18:09',0,NULL,'远程复电','QC5DG101','201301',3),
	(4,4,'0269389902','远程停电','2014-10-27 15:41',NULL,'刘成军','2014-10-27 18:10',0,NULL,'远程复电','QC5DC181','201301',5),
	(5,5,'0268476438','远程停电','2014-10-27 15:41',NULL,'刘成军','2014-10-27 18:21',0,NULL,'远程复电','QC5YH175','201301',62),
	(6,6,'0268476438','远程停电','2014-10-27 15:41',NULL,'刘成军','2014-10-27 18:21',0,NULL,'远程复电','QC5YH175','201302',51),
	(7,4,'0269389902','远程停电','2014-10-27 15:41',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5DC181','201301',5),
	(8,5,'0268476438','远程停电','2014-10-27 15:41',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201301',62),
	(9,6,'0268476438','远程停电','2014-10-27 15:41',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(10,75,'0268476438','远程停电','2014-10-27 16:23',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201310',37),
	(11,75,'0268476438','远程停电','2014-10-27 16:23',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201310',37),
	(12,75,'0268476438','远程停电','2014-10-27 16:28',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201310',37),
	(13,75,'0268476438','远程停电','2014-10-16 16:29',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201310',37),
	(14,6,'0268476438','表前开关上锁','2014-10-16 16:29',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(15,6,'0268476438','表前开关上锁','2014-10-16 16:29',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(16,6,'0268476438','表前开关上锁','2014-10-16 16:29',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(17,6,'0268476438','表前开关上锁','2014-10-16 16:29',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(18,6,'0268476438','表前开关上锁','2014-10-16 16:29',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(19,6,'0268476438','远程停电','2014-10-27 16:33',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5YH175','201302',51),
	(20,6,'0268564926','远程停电','2014-10-27 16:33',NULL,'姜恒','2014-10-27 18:28',0,NULL,'远程复电','QC5DG152',NULL,215),
	(21,8,'0273353719','表前开关上锁','2014-10-27 16:38',NULL,'王玉敬','2014-10-27 18:32',0,NULL,'远程复电','QC5DG226',NULL,325),
	(22,12,'0269121270','拆表','2014-10-27 16:54',NULL,'王军',NULL,NULL,NULL,NULL,'QC5SC181',NULL,2),
	(23,13,'0269195400','远程停电','2014-10-27 17:12',NULL,'刘珂',NULL,NULL,NULL,NULL,'QC5SB141',NULL,3),
	(24,11,'0268429009','远程停电','2014-10-27 17:12',NULL,'王军',NULL,NULL,NULL,NULL,'QC5SC171',NULL,3),
	(25,10,'0626434034','远程停电','2014-10-27 17:12',NULL,'葛超',NULL,NULL,NULL,NULL,'0000830057',NULL,10),
	(26,7,'0488891480','远程停电','2014-10-27 17:20',NULL,'王军',NULL,NULL,NULL,NULL,'QC5DA101',NULL,145),
	(27,9,'0270714078','远程停电','2014-10-27 17:20',NULL,'武国','2014-10-27 18:32',0,NULL,'远程复电','QC5DD131',NULL,519),
	(28,14,'0268626703','远程停电','2014-10-27 17:20',NULL,'姜恒','2014-10-28 09:46',0,'053187063217','远程复电','QC5SE113',NULL,2),
	(29,18,'0271234047','远程停电','2014-10-27 18:18',NULL,'王玉敬','2014-10-27 18:19',0,NULL,'远程复电','QC5SF111',NULL,47),
	(30,4,'0269389902','远程停电','2014-10-28 15:05',NULL,'刘成军',NULL,NULL,NULL,NULL,'QC5DC181',NULL,5),
	(31,26,'0269389898','拆表','2014-10-28 15:13',NULL,'刘成军','2014-10-28 15:14',0,'053186051980','拆表','QC5DH103',NULL,3),
	(32,26,'0269389898','远程停电','2014-10-28 15:14',NULL,'刘成军','2014-10-28 15:15',0,'053186051980','远程复电','QC5DH103',NULL,3),
	(33,26,'0269389898','远程停电','2014-10-28 15:25',NULL,'刘成军','2014-10-28 15:25',0,'13901234567','远程复电','QC5DH103',NULL,3);

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
  `IsRead` char(1) DEFAULT NULL COMMENT '是否已读',
  `ReadTime` datetime DEFAULT NULL COMMENT '阅读时间',
  `IsImportant` char(1) DEFAULT NULL COMMENT '是否为紧急状态 紧急时可跳转到复电界面',
  `RefCustomer` varchar(45) DEFAULT NULL COMMENT '相关客户',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Message` WRITE;
/*!40000 ALTER TABLE `Message` DISABLE KEYS */;

INSERT INTO `Message` (`ID`, `ToUserID`, `FromUserID`, `Sender`, `Content`, `SendTime`, `IsRead`, `ReadTime`, `IsImportant`, `RefCustomer`)
VALUES
	(1,71,50,'百度','省公安厅  已交费','2014-10-27 15:24:29',NULL,NULL,'0','0270401503'),
	(2,63,50,'百度','省公安厅  已交费','2014-10-27 15:24:29',NULL,NULL,'0','0270401503'),
	(3,70,50,'百度','刘长兴  已交费','2014-10-27 15:46:19',NULL,NULL,'1','0271170668'),
	(4,63,50,'百度','刘长兴  已交费','2014-10-27 15:46:19',NULL,NULL,'1','0271170668'),
	(5,67,50,'百度','李玉琳  已交费','2014-10-27 15:51:19',NULL,NULL,'0','0268007227'),
	(6,63,50,'百度','李玉琳  已交费','2014-10-27 15:51:19',NULL,NULL,'0','0268007227'),
	(7,67,50,'百度','李玉琳  已交费','2014-10-27 15:52:27',NULL,NULL,'0','0268007227'),
	(8,63,50,'百度','李玉琳  已交费','2014-10-27 15:52:27',NULL,NULL,'0','0268007227'),
	(9,67,50,'百度','李玉琳  已交费','2014-10-27 15:52:44',NULL,NULL,'0','0268007227'),
	(10,63,50,'百度','李玉琳  已交费','2014-10-27 15:52:44',NULL,NULL,'0','0268007227'),
	(11,70,50,'百度','刘长兴  已交费','2014-10-27 17:48:56',NULL,NULL,'1','0271170668'),
	(12,63,50,'百度','刘长兴  已交费','2014-10-27 17:48:56',NULL,NULL,'1','0271170668'),
	(13,70,73,'杨敏','刘长兴  已交费','2014-10-27 19:02:58',NULL,NULL,'0','0271170668'),
	(14,63,73,'杨敏','刘长兴  已交费','2014-10-27 19:02:58',NULL,NULL,'0','0271170668'),
	(15,67,73,'杨敏','赵东  已交费','2014-10-27 20:29:28',NULL,NULL,'0','0268490881'),
	(16,63,73,'杨敏','赵东  已交费','2014-10-27 20:29:28',NULL,NULL,'0','0268490881'),
	(17,71,50,'百度','省公安厅  已交费','2014-10-28 14:23:10',NULL,NULL,'0','0270401503'),
	(18,63,50,'百度','省公安厅  已交费','2014-10-28 14:23:10',NULL,NULL,'0','0270401503'),
	(19,68,50,'百度','申廷勇  已交费','2014-10-28 15:31:09',NULL,NULL,'0','0269389898'),
	(20,63,50,'百度','申廷勇  已交费','2014-10-28 15:31:09',NULL,NULL,'0','0269389898'),
	(21,81,50,'百度','魏家庄卫站（刘承坦）  已交费','2014-10-28 16:21:21',NULL,NULL,'0','0268476438'),
	(22,63,50,'百度','魏家庄卫站（刘承坦）  已交费','2014-10-28 16:21:21',NULL,NULL,'0','0268476438'),
	(23,81,50,'百度','魏家庄卫站（刘承坦）  已交费','2014-10-28 16:22:27',NULL,NULL,'0','0268476438'),
	(24,63,50,'百度','魏家庄卫站（刘承坦）  已交费','2014-10-28 16:22:27',NULL,NULL,'0','0268476438'),
	(25,81,50,'百度','魏家庄卫站（刘承坦）  已交费','2014-10-28 16:24:34',NULL,NULL,'0','0268476438'),
	(26,63,50,'百度','魏家庄卫站（刘承坦）  已交费','2014-10-28 16:24:34',NULL,NULL,'0','0268476438');

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
	(11,'撤销催费','reminder/cancel',NULL,2,2);

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
  `UserName` varchar(25) DEFAULT '' COMMENT '抄表员',
  `CustomerNumber` varchar(25) NOT NULL COMMENT '客房编号',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `YearMonth` char(6) DEFAULT NULL,
  `Money` float DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Press` WRITE;
/*!40000 ALTER TABLE `Press` DISABLE KEYS */;

INSERT INTO `Press` (`ID`, `Arrear`, `PressTime`, `PressStyle`, `PhotoLocation`, `Photo`, `PhoneType`, `Phone`, `UserID`, `UserName`, `CustomerNumber`, `Segment`, `YearMonth`, `Money`)
VALUES
	(9,29,'2014-10-27 17:09','电话催费',NULL,'',NULL,'',NULL,'范明杰','0271170668','QC5DA201','201303',1),
	(3,184,'2014-10-27 16:07','电话催费',NULL,'',NULL,'',NULL,'王军','0268007227','QC5SK163','201308',166),
	(4,184,'2014-10-01 16:09','电话催费',NULL,'',NULL,'',NULL,'王军','0268007227','QC5SK163','201308',166),
	(5,184,'2014-10-15 16:09','电话催费',NULL,'',NULL,'',NULL,'王军','0268007227','QC5SK163','201308',166),
	(20,4,'2014-10-28 14:26','电话催费',NULL,'','房东电话','053186612916',NULL,'刘成军','0269389902','QC5DC181','201301',5),
	(10,1,'2014-10-27 17:47','电话催费',NULL,'',NULL,'',NULL,'范明杰','0271170668','QC5DA201','201301',1),
	(8,109,'2014-10-27 16:22','电话催费',NULL,'',NULL,'',NULL,'王军','0268007227','QC5SK163','201306',39),
	(13,7,'2014-10-28 11:01','电话催费',NULL,'','房东电话','053182068768',NULL,'姜恒','0268564926','QC5DG152','201301',129),
	(14,42,'2014-10-28 11:01','电话催费',NULL,'','房东电话','053182068768',NULL,'姜恒','0268564926','QC5DG152','201303',86),
	(15,8,'2014-10-28 11:01','电话催费',NULL,'','房东电话','13789822096',NULL,'王军','0488891480','QC5DA101','201301',145),
	(21,45,'2014-10-28 15:14','电话催费',NULL,'',NULL,NULL,NULL,'葛超','0626427784','0000830058','201304',1),
	(17,5,'2014-10-28 12:03','电话催费',NULL,'',NULL,NULL,NULL,'刘成军','0268476438','QC5YH175','201301',62),
	(18,6,'2014-10-28 12:03','电话催费',NULL,'',NULL,NULL,NULL,'刘成军','0268476438','QC5YH175','201302',51),
	(19,3,'2014-10-28 14:04','电话催费',NULL,'','房东电话','053182628231',NULL,'姜恒','0270401503','QC5DG101','201301',3),
	(22,45,'2014-10-28 15:14','电话催费',NULL,'',NULL,NULL,NULL,'葛超','0626427784','0000830058','201304',1),
	(23,4,'2014-10-28 15:21','电话催费',NULL,'',NULL,NULL,NULL,'刘成军','0269389902','QC5DC181','201301',5),
	(24,4,'2014-10-28 15:24','电话催费',NULL,'',NULL,NULL,NULL,'刘成军','0269389902','QC5DC181','201301',5),
	(25,4,'2014-10-28 15:25','通知单催费',NULL,'',NULL,NULL,NULL,'刘成军','0269389902','QC5DC181','201301',5),
	(30,19,'2014-10-28 15:56','通知单催费',NULL,'/public/upload/201410/10_1414483017.jpg',NULL,NULL,NULL,'姜恒','0269315352','QC5SG181','201302',3);

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
	(1,'抄表员','8,11,9,10,16,17,18,19','/site/index'),
	(2,'抄表员班长','8,11,9,10,11,12,15,16,17,18,19,20,21,22,23,24,32','/report/press'),
	(3,'收费员','6,7','/charges/charges'),
	(4,'收费员班长','6,7,12,13,19','/report/electricity'),
	(5,'对账员','12,13,14,19','/count/Reconciliation'),
	(6,'管理人员','11,12,13,14,15,16,17,18,19,20,21,22,23,31','/manager/systemlog'),
	(7,'Admin','6,7,8,11,9,10,30,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,29,31,32','/manager/systemlog');

/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Segment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Segment`;

CREATE TABLE `Segment` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Number` varchar(25) NOT NULL DEFAULT '' COMMENT '编号',
  `Name` varchar(25) DEFAULT NULL COMMENT '抄表段名称',
  `UserID` int(11) DEFAULT NULL COMMENT '抄表员ID',
  `UserName` varchar(25) DEFAULT NULL COMMENT '抄表员名称',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Segment` WRITE;
/*!40000 ALTER TABLE `Segment` DISABLE KEYS */;

INSERT INTO `Segment` (`ID`, `Number`, `Name`, `UserID`, `UserName`)
VALUES
	(1,'QC5SD152','',83,'丛丽'),
	(2,'QC5SC113','',66,'武国'),
	(3,'QC5SG191','',81,'杨阳'),
	(4,'QC5SG201','',69,'姜汉明'),
	(5,'QC5SC201','',69,'姜汉明'),
	(6,'QC5SB132','',68,'刘成军'),
	(7,'QC5SB182','',68,'刘成军'),
	(8,'QC5SB181','',68,'刘成军'),
	(9,'QC5SC181','',66,'武国'),
	(10,'QC5SC161','',66,'武国'),
	(11,'QC5SC171','',66,'武国'),
	(12,'QC5SC163','',66,'武国'),
	(13,'QC5SC162','',66,'武国'),
	(14,'QC5YH175','',81,'杨阳'),
	(15,'QC5SH163','',69,'姜汉明'),
	(16,'QC5SH153','',83,'丛丽'),
	(17,'QC5SE141','',62,'王玉敬'),
	(18,'QC5SE193','',69,'姜汉明'),
	(19,'QC5SC202','',69,'姜汉明'),
	(20,'QC5SE142','',62,'王玉敬'),
	(21,'QC5DK182','',62,'王玉敬'),
	(22,'QC5SD161','',83,'丛丽'),
	(23,'QC5SA151','',83,'丛丽'),
	(24,'QC5SA152','',83,'丛丽'),
	(25,'QC5DK181','',62,'王玉敬'),
	(26,'QC5DK193','',62,'王玉敬'),
	(27,'QC5SC112','',66,'武国'),
	(28,'QC5DA201','',70,'范明杰'),
	(29,'QC5DA152','',67,'王军'),
	(30,'QC5DG101','',71,'姜恒'),
	(31,'QC5DC181','',68,'刘成军'),
	(32,'QC5DG152','',71,'姜恒'),
	(33,'QC5DA101','',67,'王军'),
	(34,'QC5DG226','',62,'王玉敬'),
	(35,'QC5DD131','',66,'武国'),
	(36,'0000830057','',65,'葛超'),
	(37,'QC5SB141','',64,'刘珂'),
	(38,'QC5SE113','',71,'姜恒'),
	(39,'QC5SA172','',71,'姜恒'),
	(40,'QC5SG181','',71,'姜恒'),
	(41,'QC5SE154','',70,'范明杰'),
	(42,'QC5SF111','',62,'王玉敬'),
	(43,'QC5SA171','',71,'姜恒'),
	(44,'QC5SG171','',71,'姜恒'),
	(45,'QC5DC111','',67,'王军'),
	(46,'QC5DH103','',68,'刘成军'),
	(47,'QC5DH172','',68,'刘成军'),
	(48,'QC5DC121','',67,'王军'),
	(49,'QC5DK141','',66,'武国'),
	(50,'QC5DH122','',70,'范明杰'),
	(51,'0000841055','',66,'武国'),
	(52,'QC5DG029','',64,'刘珂'),
	(53,'0000830058','',65,'葛超'),
	(54,'QC5SK121','',65,'葛超'),
	(55,'QC5DG027','',64,'刘珂'),
	(56,'QC5SG111','',71,'姜恒'),
	(57,'QC5SK111','',65,'葛超'),
	(58,'QC5DC151','',67,'王军'),
	(59,'QC5DB131','',64,'刘珂'),
	(60,'QC5DE161','',68,'刘成军'),
	(61,'QC5DG122','',71,'姜恒'),
	(62,'QC5DE171','',68,'刘成军'),
	(63,'QC5DK111','',65,'葛超'),
	(64,'QC5DJ202','',67,'王军'),
	(65,'0001367739','',69,'姜汉明'),
	(66,'QC5DG141','',71,'姜恒'),
	(67,'QC5SA132','',71,'姜恒'),
	(68,'QC5SA182','',69,'姜汉明'),
	(69,'QC5SH171','',70,'范明杰'),
	(70,'QC5SG151','',71,'姜恒'),
	(71,'QC5SE194','',68,'刘成军'),
	(72,'QC5SE131','',69,'姜汉明'),
	(73,'QC5SB201','',64,'刘珂'),
	(74,'QC5SC132','',67,'王军'),
	(75,'QC5SC141','',67,'王军'),
	(76,'QC5SK163','',67,'王军'),
	(77,'QC5SH112','',64,'刘珂'),
	(78,'QC5SC143','',67,'王军'),
	(79,'QC5DG222','',62,'王玉敬'),
	(80,'QC5YH121','',70,'范明杰'),
	(81,'QC5SG102','',71,'姜恒'),
	(82,'QC5SJ151','',64,'刘珂'),
	(83,'QC5SB131','',64,'刘珂'),
	(84,'QC5DK121','',65,'葛超'),
	(85,'QC5DG113','',71,'姜恒'),
	(86,'QC5DA161','',69,'姜汉明'),
	(87,'QC5DH201','',70,'范明杰'),
	(88,'QC5SD131','',66,'武国'),
	(89,'QC5DE151','',67,'王军'),
	(90,'QC5DA181','',69,'姜汉明'),
	(91,'QC5DJ101','',69,'姜汉明'),
	(92,'QC5DC131','',67,'王军'),
	(93,'QC5DD101','',66,'武国'),
	(94,'QC5DG172','',71,'姜恒'),
	(95,'QC5DG181','',71,'姜恒'),
	(96,'QC5DE126','',64,'刘珂'),
	(97,'QC5DJ161','',62,'王玉敬'),
	(98,'QC5SE181','',68,'刘成军'),
	(99,'QC5SA162','',71,'姜恒'),
	(100,'QC5SE201','',68,'刘成军'),
	(101,'QC5SE182','',68,'刘成军'),
	(102,'QC5SE112','',64,'刘珂'),
	(103,'QC5SH151','',68,'刘成军'),
	(104,'QC5SJ163','',64,'刘珂'),
	(105,'QC5SD162','',68,'刘成军'),
	(106,'QC5SA181','',69,'姜汉明'),
	(107,'QC5SA111','',71,'姜恒'),
	(108,'QC5DG131','',71,'姜恒'),
	(109,'QC5DD141','',66,'武国'),
	(110,'QC5DG034','',62,'王玉敬'),
	(111,'0000929559','',62,'王玉敬'),
	(112,'QC5DJ152','',62,'王玉敬'),
	(113,'QC5DH171','',68,'刘成军'),
	(114,'QC5DK151','',66,'武国'),
	(115,'QC5DE112','',62,'王玉敬'),
	(116,'QC5DH151','',68,'刘成军'),
	(117,'QC5DG151','',71,'姜恒'),
	(118,'QC5DA162','',69,'姜汉明'),
	(119,'QC5DA171','',69,'姜汉明'),
	(120,'QC5DD121','',66,'武国'),
	(121,'QC5DD102','',66,'武国'),
	(122,'QC5DG171','',71,'姜恒'),
	(123,'QC5SK164','',68,'刘成军'),
	(124,'QC5DE127','',71,'姜恒'),
	(125,'QC5SA141','',71,'姜恒'),
	(126,'QC5SH111','',64,'刘珂'),
	(127,'QC5SE161','',70,'范明杰'),
	(128,'QC5SJ142','',69,'姜汉明'),
	(129,'QC5SJ143','',69,'姜汉明'),
	(130,'QC5SB162','',64,'刘珂'),
	(131,'QC5SA142','',71,'姜恒'),
	(132,'QC5SH122','',64,'刘珂'),
	(133,'QC5SA121','',69,'姜汉明'),
	(134,'QC5DC172','',68,'刘成军'),
	(135,'QC5DE132','',69,'姜汉明'),
	(136,'QC5DE201','',67,'王军'),
	(137,'QC5DK161','',70,'范明杰'),
	(138,'0001367124','',66,'武国'),
	(139,'QC5DG092','',71,'姜恒'),
	(140,'QC5DG202','',68,'刘成军'),
	(141,'QC5DD103','',66,'武国'),
	(142,'QC5DH202','',70,'范明杰'),
	(143,'QC5DJ181','',62,'王玉敬'),
	(144,'QC5DE111','',62,'王玉敬'),
	(145,'QC5DD151','',66,'武国'),
	(146,'QC5DH161','',68,'刘成军'),
	(147,'QC5DE121','',64,'刘珂'),
	(148,'QC5DJ111','',69,'姜汉明'),
	(149,'QC5DG121','',71,'姜恒'),
	(150,'QC5DK112','',65,'葛超'),
	(151,'QC5SB191','',69,'姜汉明'),
	(152,'QC5SD171','',68,'刘成军'),
	(153,'QC5DG035','',62,'王玉敬'),
	(154,'QC5SE191','',68,'刘成军'),
	(155,'QC5SJ132','',69,'姜汉明'),
	(156,'QC5SJ133','',69,'姜汉明'),
	(157,'QC5SB151','',64,'刘珂'),
	(158,'QC5SA131','',67,'王军'),
	(159,'QC5SJ111','',64,'刘珂'),
	(160,'QC5SJ122','',64,'刘珂'),
	(161,'QC5SH123','',64,'刘珂'),
	(162,'QC5SB172','',64,'刘珂'),
	(163,'QC5SJ141','',69,'姜汉明'),
	(164,'QC5DG037','',68,'刘成军'),
	(165,'QC5SJ131','',69,'姜汉明'),
	(166,'QC5DJ151','',64,'刘珂'),
	(167,'QC5DH192','',70,'范明杰'),
	(168,'QC5DA121','',69,'姜汉明'),
	(169,'QC5DB151','',70,'范明杰'),
	(170,'QC5DK171','',70,'范明杰'),
	(171,'QC5DJ122','',69,'姜汉明'),
	(172,'QC5DJ121','',69,'姜汉明'),
	(173,'QC5DB171','',70,'范明杰'),
	(174,'QC5DB161','',70,'范明杰'),
	(175,'QC5DK131','',65,'葛超'),
	(176,'QC5SB101','',65,'葛超'),
	(177,'QC5DE192','',67,'王军'),
	(178,'QC5DH193','',70,'范明杰'),
	(179,'QC5DA141','',69,'姜汉明'),
	(180,'QC5DL041','',67,'王军'),
	(181,'QC5SG026','',65,'葛超'),
	(182,'QC5DJ102','',69,'姜汉明'),
	(183,'QC5DG132','',71,'姜恒'),
	(184,'QC5SC142','',67,'王军'),
	(185,'QC5DG028','',69,'姜汉明'),
	(186,'QC5SC203','',67,'王军'),
	(187,'QC5SG092','',71,'姜恒'),
	(188,'QC5SC121','',67,'王军'),
	(189,'QC5SK162','',67,'王军'),
	(190,'QC5SA161','',71,'姜恒'),
	(191,'QC5SE153','',70,'范明杰'),
	(192,'0000583608','',65,'葛超'),
	(193,'QC5DB101','',64,'刘珂'),
	(194,'QC5DE141','',69,'姜汉明'),
	(195,'QC5DJ112','',69,'姜汉明'),
	(196,'QC5DB143','',70,'范明杰'),
	(197,'QC5DD162','',66,'武国'),
	(198,'QC5DG191','',71,'姜恒'),
	(199,'QC5DH121','',70,'范明杰'),
	(200,'QC5DH112','',70,'范明杰'),
	(201,'QC5DA132','',69,'姜汉明'),
	(202,'QC5DA172','',69,'姜汉明'),
	(203,'QC5DJ123','',69,'姜汉明'),
	(204,'QC5DE191','',67,'王军'),
	(205,'QC5SB092','',65,'葛超'),
	(206,'QC5DB121','',62,'王玉敬'),
	(207,'QC5DD111','',66,'武国'),
	(208,'QC5DH184','',68,'刘成军'),
	(209,'QC5SB123','',64,'刘珂'),
	(210,'QC5SB121','',64,'刘珂'),
	(211,'QC5SJ161','',64,'刘珂'),
	(212,'QC5SC131','',67,'王军'),
	(213,'QC5SE122','',69,'姜汉明'),
	(214,'QC5SE121','',69,'姜汉明'),
	(215,'QC5SH131','',70,'范明杰'),
	(216,'QC5SC122','',67,'王军'),
	(217,'QC5SB161','',64,'刘珂'),
	(218,'QC5SG122','',71,'姜恒'),
	(219,'QC5SC152','',67,'王军'),
	(220,'QC5SH121','',64,'刘珂'),
	(221,'QC5SH141','',70,'范明杰'),
	(222,'QC5SE111','',64,'刘珂'),
	(223,'QC5SB192','',69,'姜汉明'),
	(224,'QC5SG161','',71,'姜恒'),
	(225,'QC5SB171','',64,'刘珂'),
	(226,'QC5SK122','',65,'葛超'),
	(227,'QC5SE151','',70,'范明杰'),
	(228,'0000911074','',64,'刘珂'),
	(229,'QC5SG101','',71,'姜恒'),
	(230,'QC5SB122','',64,'刘珂'),
	(231,'QC5SH142','',70,'范明杰'),
	(232,'QC5SG141','',71,'姜恒'),
	(233,'QC5SC192','',67,'王军'),
	(234,'QC5SG121','',71,'姜恒'),
	(235,'QC5DK192','',70,'范明杰'),
	(236,'QC5DG221','',62,'王玉敬'),
	(237,'QC5DH102','',64,'刘珂'),
	(238,'QC5DH131','',68,'刘成军'),
	(239,'QC5DH175','',68,'刘成军'),
	(240,'QC5DC143','',68,'刘成军'),
	(241,'QC5DE122','',64,'刘珂'),
	(242,'QC5DJ192','',62,'王玉敬'),
	(243,'QC5DJ201','',69,'姜汉明'),
	(244,'QC5DC144','',68,'刘成军'),
	(245,'QC5DC152','',67,'王军'),
	(246,'QC5DJ113','',69,'姜汉明'),
	(247,'QC5DH101','',70,'范明杰'),
	(248,'QC5DE202','',67,'王军'),
	(249,'0000930561','',71,'姜恒'),
	(250,'QC5DG112','',71,'姜恒'),
	(251,'QC5DJ162','',62,'王玉敬'),
	(252,'QC5DH141','',68,'刘成军'),
	(253,'QC5DD104','',66,'武国'),
	(254,'QC5DG161','',71,'姜恒'),
	(255,'QC5DG182','',71,'姜恒'),
	(256,'QC5DE152','',67,'王军'),
	(257,'QC5DE124','',64,'刘珂'),
	(258,'QC5DK122','',65,'葛超'),
	(259,'QC5DJ191','',62,'王玉敬'),
	(260,'QC5DA192','',66,'武国'),
	(261,'QC5DC145','',68,'刘成军'),
	(262,'QC5DA131','',69,'姜汉明'),
	(263,'QC5DD161','',66,'武国'),
	(264,'QC5DB111','',64,'刘珂'),
	(265,'QC5SB091','',65,'葛超'),
	(266,'QC5DJ143','',62,'王玉敬'),
	(267,'QC5DC182','',67,'王军'),
	(268,'QC5DA113','',67,'王军'),
	(269,'QC5DA065','',69,'姜汉明'),
	(270,'QC5DJ131','',62,'王玉敬'),
	(271,'QC5SB111','',65,'葛超'),
	(272,'QC5DE125','',64,'刘珂'),
	(273,'QC5DA111','',67,'王军'),
	(274,'QC5SC153','',67,'王军'),
	(275,'QC5SE202','',68,'刘成军'),
	(276,'QC5SE171','',70,'范明杰'),
	(277,'0001367580','',70,'范明杰'),
	(278,'QC5SE152','',70,'范明杰'),
	(279,'0000591280','',70,'范明杰'),
	(280,'QC5SE192','',68,'刘成军'),
	(281,'QC5DK191','',70,'范明杰'),
	(282,'QC5SE132','',67,'王军'),
	(283,'QC5SC151','',67,'王军'),
	(284,'0001376720','',67,'王军'),
	(285,'QC5SE172','',70,'范明杰'),
	(286,'QC5SH132','',70,'范明杰'),
	(287,'QC5SH113','',69,'姜汉明'),
	(288,'QC5SH172','',70,'范明杰'),
	(289,'QC5SG091','',71,'姜恒'),
	(290,'QC5SG131','',71,'姜恒'),
	(291,'QC5SC191','',67,'王军'),
	(292,'QC5SH154','',68,'刘成军'),
	(293,'QC5SK161','',68,'刘成军'),
	(294,'QC5SC111','',67,'王军'),
	(295,'QC5SG028','',62,'王玉敬'),
	(296,'QC5DG224','',62,'王玉敬'),
	(297,'QC5SJ152','',64,'刘珂'),
	(298,'QCKB0005','市中卡表册',62,'王玉敬');

/*!40000 ALTER TABLE `Segment` ENABLE KEYS */;
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



# Dump of table Team
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Team`;

CREATE TABLE `Team` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  `TypeName` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `Team` WRITE;
/*!40000 ALTER TABLE `Team` DISABLE KEYS */;

INSERT INTO `Team` (`ID`, `Name`, `Type`, `TypeName`)
VALUES
	(1,'低压一班',1,'抄表'),
	(2,'低压二班',1,'抄表'),
	(3,'营业一班',2,'收费'),
	(22,'营业二班',2,'收费');

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
	(68,'刘成军','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:14:21',NULL,1),
	(50,'百度','40bd001563085fc35165329ea1ff5c5ecbdbbeef',3,'收费员','2014-06-26 14:33:08',NULL,22),
	(10,'admin','40bd001563085fc35165329ea1ff5c5ecbdbbeef',7,NULL,'2014-06-07 01:05:29',NULL,-1),
	(46,'张烨','40bd001563085fc35165329ea1ff5c5ecbdbbeef',4,'收费员班长','2014-06-26 11:06:34',NULL,22),
	(48,'大明','40bd001563085fc35165329ea1ff5c5ecbdbbeef',5,'对账员','2014-06-26 11:11:11',NULL,NULL),
	(49,'流沙','40bd001563085fc35165329ea1ff5c5ecbdbbeef',6,'管理人员','2014-06-26 11:11:18',NULL,NULL),
	(65,'葛超','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:12:53',NULL,1),
	(44,'温永','40bd001563085fc35165329ea1ff5c5ecbdbbeef',4,'收费员班长','2014-06-26 11:06:20',NULL,3),
	(73,'杨敏','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-07-11 10:58:07',NULL,3),
	(72,'陈曦','356a192b7913b04c54574d18c28d46e6395428ab',4,'收费员班长','2014-07-11 10:57:45',NULL,3),
	(66,'武国','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:13:35',NULL,1),
	(69,'姜汉明','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:14:47',NULL,1),
	(70,'范明杰','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:15:17',NULL,1),
	(80,'123','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员','2014-10-24 17:51:01',NULL,1),
	(67,'王军','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:13:59',NULL,1),
	(62,'王玉敬','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员','2014-07-09 11:01:54',NULL,1),
	(63,'许进','40bd001563085fc35165329ea1ff5c5ecbdbbeef',2,'抄表员班长','2014-07-11 10:11:31',NULL,1),
	(64,'刘珂','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员','2014-07-11 10:12:09',NULL,1),
	(71,'姜恒','356a192b7913b04c54574d18c28d46e6395428ab',1,'抄表员','2014-07-11 10:15:36',NULL,1),
	(74,'苗壮','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-07-11 10:58:26',NULL,3),
	(81,'杨阳','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员','2014-10-25 12:31:23',NULL,1),
	(76,'刘香花','356a192b7913b04c54574d18c28d46e6395428ab',3,'收费员','2014-07-13 15:07:36',NULL,3),
	(79,'321','5f6955d227a320c7f1f6c7da2a6d96a851a8118f',1,'抄表员','2014-10-24 17:50:26',NULL,1),
	(82,'12344','420df50a0a436cabe48e1597a9508a2b5449d35e',2,'抄表员班长','2014-10-25 18:10:25',NULL,3),
	(83,'丛丽','40bd001563085fc35165329ea1ff5c5ecbdbbeef',1,'抄表员','2014-10-27 13:54:30',NULL,2);

/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table UserModule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `UserModule`;

CREATE TABLE `UserModule` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户权限表',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
