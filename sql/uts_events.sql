-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Jun 15, 2024 at 02:44 AM
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
-- Database: `uts_events`
--

-- --------------------------------------------------------

--
-- Table structure for table `available_ticket`
--

CREATE TABLE `available_ticket` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `stock` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_start` datetime NOT NULL,
  `sale_end` datetime NOT NULL,
  `event_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `description` varchar(1000) NOT NULL,
  `faq` varchar(1000) DEFAULT NULL,
  `organizer_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `event`
--
DELIMITER $$
CREATE TRIGGER `event_rep_insert` AFTER INSERT ON `event` FOR EACH ROW BEGIN
	INSERT INTO event_replication (name, category, start_date, end_date, description, faq, organizer_id)
    VALUES (NEW.name, NEW.category, NEW.start_date, NEW.end_date, NEW.description, NEW.faq, NEW.organizer_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `event_details`
-- (See below for the actual view)
--
CREATE TABLE `event_details` (
`id` int
,`name` varchar(100)
,`category` varchar(100)
,`start_date` datetime
,`end_date` datetime
,`description` varchar(1000)
,`faq` varchar(1000)
,`organizer_id` int
,`created_at` timestamp
,`updated_at` timestamp
,`room_code` varchar(20)
,`likes_count` int
,`viewers_count` int
,`allow_comment` tinyint(1)
,`organizer_name` varchar(100)
,`total_tickets` bigint
);

-- --------------------------------------------------------

--
-- Table structure for table `event_replication`
--

CREATE TABLE `event_replication` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `description` varchar(1000) NOT NULL,
  `faq` varchar(1000) DEFAULT NULL,
  `organizer_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `organizer`
--

CREATE TABLE `organizer` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `logo_url` varchar(1000) NOT NULL,
  `about` varchar(1000) NOT NULL,
  `address` varchar(255) NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `stock` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_start` datetime NOT NULL,
  `sale_end` datetime NOT NULL,
  `event_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` int NOT NULL,
  `code` varchar(20) NOT NULL,
  `trans_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('paid','upaid','cancel','pending') NOT NULL,
  `user_id` int NOT NULL,
  `event_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_detail`
--

CREATE TABLE `transaction_detail` (
  `id` int NOT NULL,
  `quantity` int NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `ticket_id` int NOT NULL,
  `transaction_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `transaction_detail`
--
DELIMITER $$
CREATE TRIGGER `update_ticket_stock` AFTER INSERT ON `transaction_detail` FOR EACH ROW BEGIN
  DECLARE current_stock INT;
  DECLARE available_tickets INT;
  
  SELECT stock INTO current_stock FROM ticket WHERE id = NEW.ticket_id;
  SET available_tickets = current_stock - NEW.quantity;
  
  UPDATE ticket SET stock = available_tickets WHERE id = NEW.ticket_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `about` varchar(1000) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `user_sharding` AFTER INSERT ON `user` FOR EACH ROW BEGIN
	IF NEW.gender = 'male' THEN
    	INSERT INTO user_male(name, username, password, about, gender, email)
      VALUES (NEW.name, NEW.username, NEW.password, NEW.about, NEW.gender, NEW.email);
    ELSEIF NEW.gender = 'female' THEN
    	INSERT INTO user_female(name, username, password, about, gender, email)
      VALUES (NEW.name, NEW.username, NEW.password, NEW.about, NEW.gender, NEW.email);
    ELSE
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid gender';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_female`
--

CREATE TABLE `user_female` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `about` varchar(1000) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_male`
--

CREATE TABLE `user_male` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `about` varchar(1000) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure for view `event_details`
--
DROP TABLE IF EXISTS `event_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `event_details`  AS SELECT `e`.`id` AS `id`, `e`.`name` AS `name`, `e`.`category` AS `category`, `e`.`start_date` AS `start_date`, `e`.`end_date` AS `end_date`, `e`.`description` AS `description`, `e`.`faq` AS `faq`, `e`.`organizer_id` AS `organizer_id`, `e`.`created_at` AS `created_at`, `e`.`updated_at` AS `updated_at`, `r`.`room_code` AS `room_code`, `r`.`likes_count` AS `likes_count`, `r`.`viewers_count` AS `viewers_count`, `r`.`allow_comment` AS `allow_comment`, `o`.`name` AS `organizer_name`, (select count(`ticket`.`stock`) from `ticket` where (`ticket`.`event_id` = `e`.`id`)) AS `total_tickets` FROM ((`event` `e` join `uts_events_live`.`live_room` `r` on((`e`.`id` = `r`.`event_id`))) join `organizer` `o` on((`e`.`organizer_id` = `o`.`id`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `available_ticket`
--
ALTER TABLE `available_ticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `idx_av_ticket_price` (`price`),
  ADD KEY `idx_av_ticket_code` (`code`);

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `organizer_id` (`organizer_id`);
ALTER TABLE `event` ADD FULLTEXT KEY `idx_event_description` (`description`);
ALTER TABLE `event` ADD FULLTEXT KEY `idx_event_faq` (`faq`);

--
-- Indexes for table `event_replication`
--
ALTER TABLE `event_replication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `organizer_id` (`organizer_id`);
ALTER TABLE `event_replication` ADD FULLTEXT KEY `idx_event_rep_description` (`description`);
ALTER TABLE `event_replication` ADD FULLTEXT KEY `idx_event_rep_faq` (`faq`);

--
-- Indexes for table `organizer`
--
ALTER TABLE `organizer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_organizer_email` (`email`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `organizer` ADD FULLTEXT KEY `idx_organizer_about` (`about`);
ALTER TABLE `organizer` ADD FULLTEXT KEY `idx_organizer_description` (`address`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `idx_ticket_price` (`price`),
  ADD KEY `idx_ticket_code` (`code`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_transaction_code` (`code`);

--
-- Indexes for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `transaction_id` (`transaction_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_email` (`email`),
  ADD KEY `idx_user_username` (`username`);

--
-- Indexes for table `user_female`
--
ALTER TABLE `user_female`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_female_email` (`email`),
  ADD KEY `idx_user_female_username` (`username`);

--
-- Indexes for table `user_male`
--
ALTER TABLE `user_male`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_male_email` (`email`),
  ADD KEY `idx_user_male_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `available_ticket`
--
ALTER TABLE `available_ticket`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_replication`
--
ALTER TABLE `event_replication`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `organizer`
--
ALTER TABLE `organizer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_female`
--
ALTER TABLE `user_female`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_male`
--
ALTER TABLE `user_male`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `available_ticket`
--
ALTER TABLE `available_ticket`
  ADD CONSTRAINT `available_ticket_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `event`
--
ALTER TABLE `event`
  ADD CONSTRAINT `event_ibfk_1` FOREIGN KEY (`organizer_id`) REFERENCES `organizer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `organizer`
--
ALTER TABLE `organizer`
  ADD CONSTRAINT `organizer_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD CONSTRAINT `transaction_detail_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `transaction_detail_ibfk_2` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
