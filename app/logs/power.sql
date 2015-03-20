-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2015 年 03 月 20 日 17:20
-- 服务器版本: 5.5.8
-- PHP 版本: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `power`
--

-- --------------------------------------------------------

--
-- 表的结构 `Arrears`
--

CREATE TABLE IF NOT EXISTS `Arrears` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8928 ;

-- --------------------------------------------------------

--
-- 表的结构 `Charge`
--

CREATE TABLE IF NOT EXISTS `Charge` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerNumber` varchar(25) NOT NULL,
  `Segment` varchar(25) DEFAULT NULL COMMENT '抄表段',
  `SegUser` varchar(25) DEFAULT NULL COMMENT '抄表员',
  `Year` char(4) DEFAULT NULL COMMENT '收费年',
  `YearMonth` int(11) NOT NULL,
  `Money` float NOT NULL,
  `UserID` int(11) NOT NULL COMMENT '收费人ID',
  `UserName` varchar(25) NOT NULL COMMENT '收费人',
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsRent` char(1) NOT NULL DEFAULT '' COMMENT '是否出租房',
  `LandlordPhone` varchar(12) DEFAULT '' COMMENT '房东电话',
  `RenterPhone` varchar(12) DEFAULT '' COMMENT '租客电话',
  `IsControl` char(1) DEFAULT NULL COMMENT '签定费控协议',
  `ChargeTeam` int(11) DEFAULT NULL COMMENT '收费班ID',
  `ManageTeam` int(11) DEFAULT NULL COMMENT '催费班ID',
  `PayStyle` char(1) DEFAULT '1' COMMENT '结算方式 1 再多 2 Pos 3 支票',
  `PayState` char(1) DEFAULT '0' COMMENT '解款状态：0 未解 1已解 2 二次结款',
  `PayUserID` int(11) DEFAULT NULL COMMENT '解款人ID',
  `PayUserName` varchar(20) DEFAULT NULL COMMENT '解款人名称',
  `PayinTime` timestamp NULL DEFAULT NULL COMMENT '解款时间',
  `Bank` varchar(25) DEFAULT NULL COMMENT '票据银行',
  `NoteNumber` varchar(25) DEFAULT NULL COMMENT '票据编号',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='收费信息表' AUTO_INCREMENT=3662 ;

-- --------------------------------------------------------

--
-- 表的结构 `Config`
--

CREATE TABLE IF NOT EXISTS `Config` (
  `Key` varchar(15) NOT NULL DEFAULT '',
  `Value` varchar(100) DEFAULT NULL,
  `Desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `Customer`
--

CREATE TABLE IF NOT EXISTS `Customer` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7203 ;

-- --------------------------------------------------------

--
-- 表的结构 `CutInfo`
--

CREATE TABLE IF NOT EXISTS `CutInfo` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=602 ;

-- --------------------------------------------------------

--
-- 表的结构 `Message`
--

CREATE TABLE IF NOT EXISTS `Message` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6285 ;

-- --------------------------------------------------------

--
-- 表的结构 `Module`
--

CREATE TABLE IF NOT EXISTS `Module` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '操作模块表',
  `Name` varchar(25) DEFAULT NULL,
  `Url` varchar(200) DEFAULT NULL,
  `Icon` varchar(200) DEFAULT NULL,
  `ParentID` int(11) NOT NULL,
  `Sort` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=39 ;

-- --------------------------------------------------------

--
-- 表的结构 `Press`
--

CREATE TABLE IF NOT EXISTS `Press` (
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
  `Desc` varchar(200) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1033 ;

-- --------------------------------------------------------

--
-- 表的结构 `Role`
--

CREATE TABLE IF NOT EXISTS `Role` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色表',
  `Name` varchar(25) DEFAULT NULL,
  `Modules` varchar(255) DEFAULT NULL,
  `IndexPage` varchar(100) DEFAULT NULL COMMENT '角色登录的首页面',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- 表的结构 `SegmentLog`
--

CREATE TABLE IF NOT EXISTS `SegmentLog` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Number` varchar(25) NOT NULL DEFAULT '' COMMENT '编号',
  `Name` varchar(25) DEFAULT NULL COMMENT '抄表段名称',
  `UserID` int(11) DEFAULT NULL COMMENT '抄表员ID',
  `UserName` varchar(25) DEFAULT NULL COMMENT '抄表员名称',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1146 ;

-- --------------------------------------------------------

--
-- 表的结构 `SystemLog`
--

CREATE TABLE IF NOT EXISTS `SystemLog` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6327 ;

-- --------------------------------------------------------

--
-- 表的结构 `Team`
--

CREATE TABLE IF NOT EXISTS `Team` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  `TypeName` varchar(25) DEFAULT NULL,
  `LineNumber` int(11) DEFAULT NULL COMMENT '指标线',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- 表的结构 `User`
--

CREATE TABLE IF NOT EXISTS `User` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(25) NOT NULL DEFAULT '',
  `Pass` varchar(50) NOT NULL DEFAULT '',
  `Role` int(11) NOT NULL DEFAULT '1',
  `RoleName` varchar(25) DEFAULT NULL,
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreateUser` int(11) DEFAULT NULL,
  `TeamID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=209 ;

-- --------------------------------------------------------

--
-- 表的结构 `UserModule`
--

CREATE TABLE IF NOT EXISTS `UserModule` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户权限表',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `UserMoney`
--

CREATE TABLE IF NOT EXISTS `UserMoney` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `UserName` varchar(25) DEFAULT NULL,
  `Month` char(6) DEFAULT NULL,
  `Money` float DEFAULT NULL COMMENT '应收电费',
  `House` int(11) DEFAULT NULL COMMENT '应收户数',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
