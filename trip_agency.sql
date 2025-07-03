-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 01, 2025 at 10:28 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trip_agency`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT 0,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `participants` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `booking_date` date NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `trip_id`, `user_id`, `customer_name`, `customer_email`, `customer_phone`, `participants`, `total_amount`, `booking_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Test User', 'user@example.com', '+1234567890', 2, 2599.98, '2025-08-01', 'CONFIRMED', '2025-07-01 18:51:20', '2025-07-01 18:51:20'),
(2, 2, 0, 'John Guest', 'john@example.com', '+1987654321', 1, 899.99, '2025-07-15', 'PENDING', '2025-07-01 18:51:20', '2025-07-01 18:51:20'),
(3, 3, 2, 'Test User', 'user@example.com', '+1234567890', 1, 2199.99, '2025-09-10', 'CANCELLED', '2025-07-01 18:51:20', '2025-07-01 19:22:16'),
(4, 2, 2, 'test user', 'testuser@gmail.com', '0123456789', 2, 1799.98, '2025-07-16', 'PENDING', '2025-07-01 19:23:15', '2025-07-01 19:23:15');

-- --------------------------------------------------------

--
-- Table structure for table `travellers`
--

CREATE TABLE `travellers` (
  `traveller_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` enum('M','F','Other') DEFAULT NULL,
  `passport_number` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `travellers`
--

INSERT INTO `travellers` (`traveller_id`, `booking_id`, `name`, `age`, `gender`, `passport_number`, `created_at`) VALUES
(1, 1, 'Test User', 30, 'M', 'A12345678', '2025-07-01 18:51:20'),
(2, 1, 'Jane User', 28, 'F', 'B98765432', '2025-07-01 18:51:20'),
(3, 2, 'John Guest', 35, 'M', 'C11111111', '2025-07-01 18:51:20'),
(4, 3, 'Test User', 30, 'M', 'A12345678', '2025-07-01 18:51:20');

-- --------------------------------------------------------

--
-- Table structure for table `trips`
--

CREATE TABLE `trips` (
  `trip_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `destination` varchar(100) NOT NULL,
  `duration` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `activity_type` varchar(50) NOT NULL,
  `max_participants` int(11) DEFAULT 20,
  `available_spots` int(11) DEFAULT 20,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trips`
--

INSERT INTO `trips` (`trip_id`, `title`, `description`, `destination`, `duration`, `price`, `activity_type`, `max_participants`, `available_spots`, `start_date`, `end_date`, `image_url`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Himalayan Adventure', 'Experience the majestic Himalayas with guided trekking and cultural immersion. This incredible journey takes you through breathtaking mountain landscapes, ancient monasteries, and vibrant local communities.', 'Nepal', 14, 1299.99, 'Adventure', 15, 15, '2025-08-01', '2025-08-15', 'images/himalaya.jpg', 'ACTIVE', '2025-07-01 18:51:20', '2025-07-01 18:51:20'),
(2, 'Paris City Break', 'Explore the City of Light with guided tours and culinary experiences. Visit iconic landmarks like the Eiffel Tower, Louvre Museum, and enjoy authentic French cuisine in charming bistros.', 'France', 5, 899.99, 'Cultural', 25, 23, '2025-07-15', '2025-07-20', 'images/paris.jpg', 'ACTIVE', '2025-07-01 18:51:20', '2025-07-01 19:23:15'),
(3, 'African Safari Adventure', 'Wildlife safari in Kenya with luxury accommodation. Witness the Great Migration, see the Big Five, and experience the raw beauty of African wilderness with expert guides.', 'Kenya', 10, 2199.99, 'Wildlife', 12, 13, '2025-09-10', '2025-09-20', 'images/safari.jpg', 'ACTIVE', '2025-07-01 18:51:20', '2025-07-01 19:22:16'),
(4, 'Bali Relaxation Retreat', 'Peaceful retreat in Bali with spa treatments and beach activities. Unwind in tropical paradise with yoga sessions, traditional massages, and pristine beaches.', 'Indonesia', 7, 1099.99, 'Relaxation', 20, 20, '2025-08-20', '2025-08-27', 'images/bali.jpg', 'ACTIVE', '2025-07-01 18:51:20', '2025-07-01 18:51:20'),
(5, 'Iceland Northern Lights', 'Magical winter adventure to see the Aurora Borealis. Experience ice caves, hot springs, and the incredible natural phenomenon of the Northern Lights.', 'Iceland', 6, 1599.99, 'Adventure', 18, 18, '2025-11-15', '2025-11-21', 'images/iceland.jpg', 'ACTIVE', '2025-07-01 18:51:20', '2025-07-01 18:51:20'),
(6, 'Tokyo Cultural Experience', 'Immerse yourself in Japanese culture with temple visits, traditional cuisine, and modern city exploration. Perfect blend of ancient traditions and cutting-edge technology.', 'Japan', 8, 1399.99, 'Cultural', 16, 16, '2025-10-05', '2025-10-13', 'images/tokyo.jpg', 'ACTIVE', '2025-07-01 18:51:20', '2025-07-01 18:51:20');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('ADMIN','USER') DEFAULT 'USER',
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `role`, `full_name`, `phone`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin123', 'admin@tripagency.com', 'ADMIN', 'System Administrator', '+1555123456', '2025-07-01 18:51:20', '2025-07-01 18:51:20'),
(2, 'testuser', 'password123', 'user@example.com', 'USER', 'Test User', '+1234567890', '2025-07-01 18:51:20', '2025-07-01 18:51:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_trip_id` (`trip_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_booking_date` (`booking_date`);

--
-- Indexes for table `travellers`
--
ALTER TABLE `travellers`
  ADD PRIMARY KEY (`traveller_id`),
  ADD KEY `idx_booking_id` (`booking_id`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`trip_id`),
  ADD KEY `idx_destination` (`destination`),
  ADD KEY `idx_activity_type` (`activity_type`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_price` (`price`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `travellers`
--
ALTER TABLE `travellers`
  MODIFY `traveller_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `trip_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE;

--
-- Constraints for table `travellers`
--
ALTER TABLE `travellers`
  ADD CONSTRAINT `travellers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
