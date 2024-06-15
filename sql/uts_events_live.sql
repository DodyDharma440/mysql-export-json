-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Jun 15, 2024 at 02:46 AM
-- Server version: 8.0.32
-- PHP Version: 8.1.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uts_events_live`
--

-- --------------------------------------------------------

--
-- Table structure for table `live_room`
--

CREATE TABLE `live_room` (
  `id` int NOT NULL,
  `room_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `event_id` int NOT NULL,
  `allow_comment` tinyint(1) NOT NULL DEFAULT '1',
  `likes_count` int NOT NULL DEFAULT '0',
  `viewers_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `live_room`
--
DELIMITER $$
CREATE TRIGGER `live_room_code` BEFORE INSERT ON `live_room` FOR EACH ROW SET NEW.room_code = COALESCE(NEW.room_code, lpad(rand() * 1000000, 6, '0'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `live_room_comment`
--

CREATE TABLE `live_room_comment` (
  `id` int NOT NULL,
  `comment` varchar(255) NOT NULL,
  `live_room_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `live_room`
--
ALTER TABLE `live_room`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `idx_room_code` (`room_code`);

--
-- Indexes for table `live_room_comment`
--
ALTER TABLE `live_room_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `live_room_id` (`live_room_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `live_room`
--
ALTER TABLE `live_room`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `live_room_comment`
--
ALTER TABLE `live_room_comment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `live_room`
--
ALTER TABLE `live_room`
  ADD CONSTRAINT `live_room_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `uts_events`.`event` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `live_room_comment`
--
ALTER TABLE `live_room_comment`
  ADD CONSTRAINT `live_room_comment_ibfk_1` FOREIGN KEY (`live_room_id`) REFERENCES `live_room` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `live_room_comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `uts_events`.`user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
