-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Хост: beko
-- Время создания: Окт 15 2020 г., 16:46
-- Версия сервера: 10.1.26-MariaDB-0+deb9u1
-- Версия PHP: 7.2.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `pdata`
--
CREATE DATABASE IF NOT EXISTS `pdata` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `pdata`;

-- --------------------------------------------------------

--
-- Структура таблицы `ecps`
--

CREATE TABLE `ecps` (
  `id` int(10) UNSIGNED NOT NULL,
  `owner_ul` varchar(255) NOT NULL,
  `owner_fl_id` int(11) NOT NULL,
  `date_issue` date NOT NULL,
  `date_end` date NOT NULL,
  `issuer_id` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `order_id` int(11) NOT NULL,
  `ticket_no` int(11) NOT NULL,
  `cert` blob NOT NULL,
  `cert_mimetype` varchar(64) DEFAULT NULL,
  `cert_filename` varchar(255) DEFAULT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ecp_assignments`
--

CREATE TABLE `ecp_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `ecp_id` int(11) NOT NULL,
  `user_to_id` int(11) NOT NULL,
  `token_id` int(11) NOT NULL,
  `token_pin` varchar(40) NOT NULL,
  `date_assignment` datetime NOT NULL,
  `dov_id` int(11) NOT NULL,
  `user_it_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `ticket_no` int(11) NOT NULL,
  `rec_no` varchar(15) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ecp_dov`
--

CREATE TABLE `ecp_dov` (
  `id` int(10) UNSIGNED NOT NULL,
  `n` varchar(10) NOT NULL,
  `user_issuer_id` int(11) NOT NULL,
  `user_to_id` int(11) NOT NULL,
  `date_issue` date NOT NULL,
  `date_upto` date NOT NULL,
  `text` varchar(255) NOT NULL,
  `scan` longblob NOT NULL,
  `scan_mimetype` varchar(64) DEFAULT NULL,
  `scan_filename` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `issuers`
--

CREATE TABLE `issuers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `trusted` tinyint(1) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` tinyint(1) UNSIGNED NOT NULL,
  `n` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `text` varchar(255) NOT NULL,
  `scan` longblob NOT NULL,
  `scan_mimetype` varchar(64) DEFAULT NULL,
  `scan_filename` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `skzi`
--

CREATE TABLE `skzi` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `manufacturer` varchar(255) NOT NULL,
  `sn` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `scan` longblob NOT NULL,
  `scan_mimetype` varchar(64) DEFAULT NULL,
  `scan_filename` varchar(255) DEFAULT NULL,
  `dist_placement` varchar(255) NOT NULL,
  `dist_checksum` varchar(255) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `skzi_assignments`
--

CREATE TABLE `skzi_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `skzi_id` int(11) NOT NULL,
  `user_to_id` int(11) NOT NULL,
  `arm_hostname` varchar(40) NOT NULL,
  `date_assignment` datetime NOT NULL,
  `user_it_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `ticket_no` int(11) NOT NULL,
  `rec_no` varchar(15) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `tokens`
--

CREATE TABLE `tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `type_id` int(11) NOT NULL,
  `sn` varchar(40) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `token_types`
--

CREATE TABLE `token_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `token_types`
--

INSERT INTO `token_types` (`id`, `type`) VALUES
(1, 'RuToken Lite'),
(3, 'Флешка USB Transcend JF V10 4GB'),
(4, 'RuToken S');

-- --------------------------------------------------------

--
-- Структура таблицы `users_cache`
--

CREATE TABLE `users_cache` (
  `id` int(10) UNSIGNED NOT NULL,
  `fio` varchar(255) NOT NULL,
  `login` varchar(40) NOT NULL,
  `title` varchar(255) NOT NULL,
  `email` varchar(40) NOT NULL,
  `phone` varchar(40) NOT NULL,
  `room` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `xfecp_users`
--

CREATE TABLE `xfecp_users` (
  `id` int(11) NOT NULL,
  `login` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `role` enum('NO ACCESS','READ ONLY','EDIT','DELETE','ADMIN') NOT NULL DEFAULT 'NO ACCESS'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `xfecp_users`
--

INSERT INTO `xfecp_users` (`id`, `login`, `password`, `role`) VALUES
(1, 'ural', 'test', 'ADMIN'),
(2, 'av', 'test', 'DELETE'),
(7, 'ponkin', 'test', 'DELETE');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `ecps`
--
ALTER TABLE `ecps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner_fl_id` (`owner_fl_id`),
  ADD KEY `date_issue` (`date_issue`);

--
-- Индексы таблицы `ecp_assignments`
--
ALTER TABLE `ecp_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ecp_id` (`ecp_id`),
  ADD KEY `user_to_id` (`user_to_id`),
  ADD KEY `date_assignment` (`date_assignment`);

--
-- Индексы таблицы `ecp_dov`
--
ALTER TABLE `ecp_dov`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `issuers`
--
ALTER TABLE `issuers`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date` (`date`),
  ADD KEY `n` (`n`);

--
-- Индексы таблицы `skzi`
--
ALTER TABLE `skzi`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `skzi_assignments`
--
ALTER TABLE `skzi_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_to_id` (`user_to_id`),
  ADD KEY `date_assignment` (`date_assignment`);

--
-- Индексы таблицы `tokens`
--
ALTER TABLE `tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sn` (`sn`);

--
-- Индексы таблицы `token_types`
--
ALTER TABLE `token_types`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users_cache`
--
ALTER TABLE `users_cache`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `fio` (`fio`);

--
-- Индексы таблицы `xfecp_users`
--
ALTER TABLE `xfecp_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `login` (`login`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `ecps`
--
ALTER TABLE `ecps`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `ecp_assignments`
--
ALTER TABLE `ecp_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `ecp_dov`
--
ALTER TABLE `ecp_dov`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `issuers`
--
ALTER TABLE `issuers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `skzi`
--
ALTER TABLE `skzi`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `skzi_assignments`
--
ALTER TABLE `skzi_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tokens`
--
ALTER TABLE `tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `token_types`
--
ALTER TABLE `token_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `users_cache`
--
ALTER TABLE `users_cache`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `xfecp_users`
--
ALTER TABLE `xfecp_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
