-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.22-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema fuzzy
--

CREATE DATABASE IF NOT EXISTS fuzzy;
USE fuzzy;

--
-- Definition of table `audit_proof`
--

DROP TABLE IF EXISTS `audit_proof`;
CREATE TABLE `audit_proof` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `filekey` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  `uid` varchar(45) NOT NULL,
  `hashproof` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `audit_proof`
--

/*!40000 ALTER TABLE `audit_proof` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_proof` ENABLE KEYS */;


--
-- Definition of table `audit_request`
--

DROP TABLE IF EXISTS `audit_request`;
CREATE TABLE `audit_request` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `filekey` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  `uid` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `hash` varchar(45) NOT NULL,
  `hash_proof` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `audit_request`
--

/*!40000 ALTER TABLE `audit_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_request` ENABLE KEYS */;


--
-- Definition of table `cloud_request`
--

DROP TABLE IF EXISTS `cloud_request`;
CREATE TABLE `cloud_request` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `filekey` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  `uid` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cloud_request`
--

/*!40000 ALTER TABLE `cloud_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_request` ENABLE KEYS */;


--
-- Definition of table `fileupload`
--

DROP TABLE IF EXISTS `fileupload`;
CREATE TABLE `fileupload` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `filename` varchar(100) NOT NULL,
  `content` longblob NOT NULL,
  `user` varchar(100) NOT NULL,
  `time` varchar(100) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `conn` longblob NOT NULL,
  `hashcode` varchar(100) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `fname` varchar(100) NOT NULL,
  `filekey` varchar(100) NOT NULL,
  `audit_status` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fileupload`
--

/*!40000 ALTER TABLE `fileupload` DISABLE KEYS */;
/*!40000 ALTER TABLE `fileupload` ENABLE KEYS */;


--
-- Definition of table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `dob` varchar(45) NOT NULL,
  `gender` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `city` varchar(45) NOT NULL,
  `country` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `rpassword` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  `kgc` varchar(45) NOT NULL,
  `otp` varchar(45) NOT NULL,
  `sign` longblob NOT NULL,
  `val` varchar(200) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
