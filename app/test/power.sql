# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 192.168.1.7 (MySQL 5.6.16)
# Database: power
# Generation Time: 2014-06-17 09:49:01 +0000
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
  `CutCount` int(11) DEFAULT '0' COMMENT '停电次数',
  `Charge` varchar(11) DEFAULT NULL COMMENT '收费员ID',
  `IsClean` char(1) DEFAULT NULL COMMENT '是否结清 0 未结清 1 结清',
  `IsCut` char(1) DEFAULT NULL COMMENT '是否停电 0 未停  1 停止',
  `ChargeDate` varchar(19) DEFAULT NULL COMMENT '收费日期',
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
  `IsRent` char(1) DEFAULT NULL COMMENT '是否出租房',
  `LandlordPhone` varchar(12) DEFAULT NULL COMMENT '房东电话',
  `RenterPhone` varchar(12) DEFAULT NULL COMMENT '租客电话',
  `Cause` varchar(200) DEFAULT NULL COMMENT '欠费原因',
  `IsSpecial` char(1) DEFAULT NULL COMMENT '是否特殊客户',
  `IsCut` char(1) DEFAULT NULL COMMENT '停电标识 0 未停；1已停',
  `CanCut` char(1) DEFAULT NULL COMMENT '能否停电标识',
  `IsClean` char(1) DEFAULT NULL COMMENT '结清标识   0 未结清 1 结清  2，预期转余期',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `SegmentID` int(11) DEFAULT NULL COMMENT '抄表段ID',
  `SegUser` varchar(25) DEFAULT NULL COMMENT '抄表员名称',
  `IsControl` char(1) DEFAULT NULL COMMENT '是否费控用户',
  `Desc` text,
  `AssetNumber` varchar(45) DEFAULT NULL COMMENT '电表资产号',
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
  `PhoneType` char(1) DEFAULT NULL COMMENT '催费电话。房东|房客',
  `Phone` varchar(12) DEFAULT NULL COMMENT '催费电话',
  `UserID` int(11) DEFAULT NULL,
  `UserName` varchar(25) DEFAULT '' COMMENT '抄表员',
  `CustomerNumber` varchar(25) NOT NULL COMMENT '客房编号',
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `YearMonth` char(6) DEFAULT NULL,
  `Money` float DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table Role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Role`;

CREATE TABLE `Role` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色表',
  `Name` varchar(25) DEFAULT NULL,
  `Modules` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



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



# Dump of table SystemLog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `SystemLog`;

CREATE TABLE `SystemLog` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL COMMENT '操作员',
  `UserName` varchar(25) DEFAULT NULL,
  `Action` varchar(11) DEFAULT NULL COMMENT '操作名称',
  `Result` varchar(25) DEFAULT NULL COMMENT '操作结果',
  `Time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间',
  `Money` float DEFAULT NULL COMMENT '操作相关的金额',
  `CustomerNumber` varchar(25) DEFAULT NULL COMMENT '操作相关客户编号',
  `CustomerName` varchar(25) DEFAULT '' COMMENT '操作相关客户名称',
  `IP` varchar(15) DEFAULT NULL COMMENT '登录IP',
  `Data` varchar(200) DEFAULT NULL COMMENT '其它数据',
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
