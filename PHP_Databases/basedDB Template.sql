-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 15, 2022 at 05:15 AM
-- Server version: 10.3.34-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `baseddepartment_glorius`
--

-- --------------------------------------------------------

--
-- Table structure for table `authlog`
--

CREATE TABLE `authlog` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `ip` text NOT NULL,
  `user_agent` text NOT NULL,
  `vendorID` int(11) NOT NULL,
  `deviceID` int(11) NOT NULL,
  `last_encryption` text NOT NULL,
  `last_seen` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `hackinglog`
--

CREATE TABLE `hackinglog` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `ip` text NOT NULL,
  `user_agent` text NOT NULL,
  `vendorID` int(11) DEFAULT NULL,
  `deviceID` int(11) DEFAULT NULL,
  `deviceos` text NOT NULL,
  `reason` text NOT NULL,
  `last_seen` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `invitecodes`
--

CREATE TABLE `invitecodes` (
  `invite` text NOT NULL,
  `taken` text NOT NULL DEFAULT 'False',
  `role` text NOT NULL DEFAULT 'live'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL DEFAULT 'Unknown Username',
  `password` text DEFAULT NULL,
  `invite` text NOT NULL,
  `role` text NOT NULL DEFAULT 'live',
  `blocked` text NOT NULL DEFAULT 'False',
  `ip` text DEFAULT NULL,
  `steamID` text DEFAULT NULL,
  `discord` text DEFAULT NULL,
  `discordID` int(11) DEFAULT NULL,
  `last_loaded` datetime NOT NULL,
  `loader_downloads` int(11) NOT NULL DEFAULT 0,
  `hacklog` int(11) NOT NULL DEFAULT 0,
  `vendorID` text NOT NULL,
  `deviceID` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authlog`
--
ALTER TABLE `authlog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hackinglog`
--
ALTER TABLE `hackinglog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authlog`
--
ALTER TABLE `authlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hackinglog`
--
ALTER TABLE `hackinglog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
