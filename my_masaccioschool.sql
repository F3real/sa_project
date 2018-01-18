-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 18, 2018 at 11:33 PM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `my_masaccioschool`
--

-- --------------------------------------------------------

--
-- Table structure for table `alarm`
--

CREATE TABLE `alarm` (
  `id` int(11) NOT NULL,
  `type` enum('fire','earthquake','crime','accident') NOT NULL,
  `number_to_call` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `alarmlog`
--

CREATE TABLE `alarmlog` (
  `id` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `sensors_id` int(11) DEFAULT NULL,
  `alarm_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `contact_info`
--

CREATE TABLE `contact_info` (
  `id` int(11) NOT NULL,
  `data` text NOT NULL,
  `user_id` int(15) NOT NULL,
  `type` enum('email','phone') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `device`
--

CREATE TABLE `device` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `key` int(11) NOT NULL,
  `token` int(11) NOT NULL,
  `creation_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `door_lock_actuator`
--

CREATE TABLE `door_lock_actuator` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `entrylog`
--

CREATE TABLE `entrylog` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `type` enum('entry','exit') NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `entrylog`
--

INSERT INTO `entrylog` (`id`, `room_id`, `time`, `type`, `user_id`) VALUES
(1, 1, '2018-01-11 09:21:00', 'entry', 1),
(2, 2, '2018-01-11 23:52:43', 'entry', 2),
(8, 1, '2018-01-12 14:02:15', 'exit', 1),
(9, 2, '2018-01-12 12:35:00', 'exit', 5),
(10, 5, '2018-01-12 17:00:00', 'entry', 9),
(11, 5, '2018-01-12 12:00:00', 'entry', 11),
(12, 2, '2018-01-12 18:34:00', 'exit', 4),
(13, 4, '2018-01-02 10:32:00', 'entry', 12),
(14, 4, '2018-01-03 00:00:00', 'entry', 1),
(16, 4, '2018-01-15 00:00:00', 'entry', 1),
(17, 4, '2018-01-15 16:06:35', 'entry', 1),
(18, 4, '2018-01-17 14:24:45', 'entry', 1),
(19, 4, '2018-01-17 14:26:50', 'entry', 1),
(20, 4, '2018-01-17 14:27:44', 'entry', 1),
(21, 4, '2018-01-17 14:28:12', 'entry', 1),
(22, 4, '2018-01-17 14:31:19', 'entry', 1),
(23, 1, '2018-01-17 14:41:25', 'entry', 2),
(24, 1, '2018-01-17 14:49:01', 'entry', 1);

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`id`, `user_id`, `parent_id`) VALUES
(1, 1, 4),
(2, 2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `opened_from` int(11) NOT NULL,
  `opened_till` int(11) NOT NULL,
  `day` enum('monday','tuesday','wednesday','thursday','friday','saturday','sunday') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `room_id`, `user_id`, `opened_from`, `opened_till`, `day`) VALUES
(1, 4, 1, 8, 20, 'monday'),
(2, 4, 1, 8, 20, 'wednesday');

-- --------------------------------------------------------

--
-- Table structure for table `rfid`
--

CREATE TABLE `rfid` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `type` enum('entry','exit') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rfid`
--

INSERT INTO `rfid` (`id`, `room_id`, `type`) VALUES
(1, 4, 'entry');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `capacity` int(11) NOT NULL,
  `current_capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `name`, `capacity`, `current_capacity`) VALUES
(1, 'Main_school_entrance', 2000, 2000),
(2, 'Professors_room', 40, 40),
(3, 'Operators_room', 50, 40),
(4, 'Chemistry_laboratory', 30, 27),
(5, 'Computers_laboratory', 60, 60);

-- --------------------------------------------------------

--
-- Table structure for table `school`
--

CREATE TABLE `school` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `address` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `school`
--

INSERT INTO `school` (`id`, `name`, `address`) VALUES
(1, 'Scuola elementare Galileo Galilei', 'via unità d\'Italia 24, Teramo');

-- --------------------------------------------------------

--
-- Table structure for table `sensors`
--

CREATE TABLE `sensors` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `type` enum('fire','earthquake') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id`, `name`) VALUES
(1, 'Professor'),
(2, 'Student'),
(3, 'Guest'),
(4, 'Operator');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `codice_fiscale` varchar(16) NOT NULL,
  `name` text NOT NULL,
  `surname` text NOT NULL,
  `status_id` int(2) NOT NULL,
  `picture` varchar(40) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `document` varchar(10) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `school_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `codice_fiscale`, `name`, `surname`, `status_id`, `picture`, `password`, `document`, `active`, `school_id`) VALUES
(1, 'test', 'Mario', 'Rossi', 2, '3', 'pbkdf2:sha256:50000$KNDXHQzu$d9a9fb4b85e3ebe1b373aa12e1396806859bf1304b5214f3d8874d4b10a231bb', 'anr23442', 0, 1),
(2, 'ggscud2378annu', 'Barack', 'Obama', 1, NULL, 'rqwafs877', 'bo5tr', 1, 1),
(3, 'asdd789asda', 'Marco', 'Bianchi', 2, '3', 'sdasd89', 'fds54rw', 1, 1),
(4, 'test1', 'Leonardo', 'Di Caprio', 2, '3', 'pbkdf2:sha256:50000$KNDXHQzu$d9a9fb4b85e3ebe1b373aa12e1396806859bf1304b5214f3d8874d4b10a231bb', '346rwe', 0, 1),
(5, 'sasd879asd', 'Luis Nazario da Lima', 'Ronaldo', 2, NULL, 'asdasdrw', '435fd', 0, 1),
(9, 'kjds872eq', 'Kim', 'Jong-un', 3, NULL, 'asdasq42', 'afs3r', 0, 1),
(11, 'gna0r39r0ksd', 'Will', 'Smith', 4, NULL, 'sadiiads789', 'ahus78f', 1, 1),
(12, 'swr325ef', 'Ozzy', 'Osbourne', 2, NULL, 'werwe32', 'sfre3532', 1, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alarm`
--
ALTER TABLE `alarm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alarmlog`
--
ALTER TABLE `alarmlog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`,`sensors_id`),
  ADD KEY `alarm_id` (`alarm_id`),
  ADD KEY `sensors_id` (`sensors_id`);

--
-- Indexes for table `contact_info`
--
ALTER TABLE `contact_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `device`
--
ALTER TABLE `device`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `door_lock_actuator`
--
ALTER TABLE `door_lock_actuator`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `entrylog`
--
ALTER TABLE `entrylog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`,`parent_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `rfid`
--
ALTER TABLE `rfid`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `school`
--
ALTER TABLE `school`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sensors`
--
ALTER TABLE `sensors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status_id` (`status_id`),
  ADD KEY `school_id` (`school_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alarm`
--
ALTER TABLE `alarm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `alarmlog`
--
ALTER TABLE `alarmlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contact_info`
--
ALTER TABLE `contact_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `device`
--
ALTER TABLE `device`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `door_lock_actuator`
--
ALTER TABLE `door_lock_actuator`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `entrylog`
--
ALTER TABLE `entrylog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rfid`
--
ALTER TABLE `rfid`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `school`
--
ALTER TABLE `school`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sensors`
--
ALTER TABLE `sensors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alarmlog`
--
ALTER TABLE `alarmlog`
  ADD CONSTRAINT `alarmlog_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `alarmlog_ibfk_2` FOREIGN KEY (`alarm_id`) REFERENCES `alarm` (`id`),
  ADD CONSTRAINT `alarmlog_ibfk_3` FOREIGN KEY (`sensors_id`) REFERENCES `sensors` (`id`);

--
-- Constraints for table `contact_info`
--
ALTER TABLE `contact_info`
  ADD CONSTRAINT `contact_info_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `device`
--
ALTER TABLE `device`
  ADD CONSTRAINT `device_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `door_lock_actuator`
--
ALTER TABLE `door_lock_actuator`
  ADD CONSTRAINT `door_lock_actuator_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`);

--
-- Constraints for table `entrylog`
--
ALTER TABLE `entrylog`
  ADD CONSTRAINT `entrylog_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`),
  ADD CONSTRAINT `entrylog_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `parents`
--
ALTER TABLE `parents`
  ADD CONSTRAINT `parents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `parents_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `permissions`
--
ALTER TABLE `permissions`
  ADD CONSTRAINT `permissions_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`),
  ADD CONSTRAINT `permissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `rfid`
--
ALTER TABLE `rfid`
  ADD CONSTRAINT `rfid_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`);

--
-- Constraints for table `sensors`
--
ALTER TABLE `sensors`
  ADD CONSTRAINT `sensors_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`school_id`) REFERENCES `school` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
