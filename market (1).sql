-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 17 2025 г., 08:07
-- Версия сервера: 8.0.19
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `market`
--
CREATE DATABASE IF NOT EXISTS `market` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `market`;

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `AddAuthor` (IN `firstName` VARCHAR(50), IN `secondName` VARCHAR(50), IN `country` VARCHAR(30), OUT `authorId` INT)  BEGIN
    INSERT INTO authors (FirstName, SecondName, Country)
    VALUES (firstName, secondName, country);
    
    SET authorId = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `AddNewCustomer` (`login` VARCHAR(50), `firstName` VARCHAR(50), `secondName` VARCHAR(50), `address` VARCHAR(100), `phone` VARCHAR(20))  BEGIN
	INSERT INTO customers (Login, FirstName, SecondName, Address, Phone)
    VALUES (login, firstName, secondName, address, phone);
    
    SELECT LAST_INSERT_ID() AS newCustomerId;
END$$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `DeleteAuthorsWithoutBooks` ()  BEGIN
	DELETE FROM authors
    WHERE AuthorId NOT IN (
		SELECT DISTINCT AuthorId FROM books
    );
END$$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `GetBooksFromTitle` (`word` VARCHAR(50))  BEGIN
    SELECT * FROM books
    WHERE Title LIKE CONCAT('%', word, '%');
END$$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `IncreasePrice` (IN `percent` DECIMAL(6,2))  BEGIN
    UPDATE books
    SET Price = Price + (Price * percent / 100);
END$$

--
-- Функции
--
CREATE DEFINER=`root`@`127.0.0.1` FUNCTION `GetAuthorsCount` (`Country` VARCHAR(30)) RETURNS INT BEGIN
	DECLARE Count INT;
    SELECT COUNT(*) INTO Count
    FROM authors
    WHERE authors.Country = Country;
    RETURN Count;
END$$

CREATE DEFINER=`root`@`127.0.0.1` FUNCTION `GetBooksByAuthorId` (`AuthorId` INT) RETURNS TEXT CHARSET utf8 BEGIN
	DECLARE Books TEXT;
    SELECT GROUP_CONCAT(title SEPARATOR ', ')
    INTO Books
    FROM books
    WHERE books.AuthorId = AuthorId;
    RETURN IFNULL(Books, 'Нет книг');
END$$

CREATE DEFINER=`root`@`127.0.0.1` FUNCTION `GetCustomerFullName` (`login` VARCHAR(50)) RETURNS VARCHAR(100) CHARSET utf8 BEGIN
    DECLARE FullName VARCHAR(100);
    SELECT UPPER(CONCAT(FirstName, " ", SecondName)) INTO FullName
    FROM customers
    WHERE Login = login
    LIMIT 1;
    RETURN FullName;
END$$

CREATE DEFINER=`root`@`127.0.0.1` FUNCTION `GetOrderTotal` (`OrderId` INT) RETURNS DECIMAL(6,2) BEGIN
    DECLARE TotalPrice DECIMAL(6, 2);
    SELECT SUM(Count * Price) INTO TotalPrice
    FROM orders
    LEFT JOIN composition ON orders.OrderId = composition.OrderId
    LEFT JOIN books ON composition.BookId = books.BookId
    WHERE orders.OrderId = OrderId;
    RETURN IFNULL(TotalPrice, 0);
END$$

CREATE DEFINER=`root`@`127.0.0.1` FUNCTION `ProfitFromYear` (`Year` INT) RETURNS DECIMAL(10,2) BEGIN
	DECLARE Profit DECIMAL(10, 2);
    SELECT SUM(Price * Count)
    INTO Profit
    FROM orders
	LEFT JOIN composition ON orders.OrderId = composition.OrderId
    LEFT JOIN books ON composition.BookId = books.BookId
    WHERE YEAR(OrderDatetime) = Year;
    RETURN IFNULL(Profit, 0);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `authors`
--

CREATE TABLE `authors` (
  `AuthorId` int UNSIGNED NOT NULL,
  `SecondName` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `Country` varchar(50) NOT NULL DEFAULT 'Россия'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `authors`
--

INSERT INTO `authors` (`AuthorId`, `SecondName`, `FirstName`, `Country`) VALUES
(1, 'Попов', 'Иван', 'Россия'),
(2, 'Иванов', 'Поп', 'Белорусия'),
(3, 'Орал', 'Джордж', 'США'),
(4, 'Пушкин', 'Александр', 'Россия'),
(5, 'Есенин', 'Сергей', 'Россия'),
(15, 'Плет', 'Андрей', 'Россия'),
(16, 'Иванов', 'Петр', 'Финляндия'),
(17, 'ГОЛЫШЕВ', 'ИЛ', 'ПОЛША');

-- --------------------------------------------------------

--
-- Структура таблицы `books`
--

CREATE TABLE `books` (
  `BookId` int NOT NULL,
  `Title` varchar(50) NOT NULL,
  `Genre` enum('проза','поэзия','другое') NOT NULL DEFAULT 'проза',
  `Price` decimal(6,2) UNSIGNED NOT NULL DEFAULT '0.00',
  `Weight` decimal(4,3) UNSIGNED NOT NULL DEFAULT '0.000',
  `Pages` smallint UNSIGNED NOT NULL DEFAULT '0',
  `PublicationYear` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `AuthorId` int UNSIGNED NOT NULL,
  `Count` int NOT NULL DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `books`
--

INSERT INTO `books` (`BookId`, `Title`, `Genre`, `Price`, `Weight`, `Pages`, `PublicationYear`, `AuthorId`, `Count`) VALUES
(1, 'Сказки linux', 'другое', '220.00', '1.000', 123, '2024-12-12 00:00:00', 1, 41),
(2, 'Сказки windows', 'другое', '1210.00', '1.000', 324, '2024-12-12 00:00:00', 2, 23),
(3, 'компьютер Воробей', 'другое', '330.00', '1.000', 1230, '2024-12-12 00:00:00', 3, 46),
(4, 'Корабль компьютер', 'другое', '330.00', '1.000', 1231, '2024-12-12 00:00:00', 1, 48),
(5, 'Голуби', 'другое', '110.00', '1.000', 123, '2024-12-12 00:00:00', 3, 46),
(6, 'Грач', 'другое', '220.00', '1.000', 1233, '2024-12-12 00:00:00', 4, 50),
(7, 'Петух компьютер', 'другое', '550.00', '1.000', 432, '2024-12-12 00:00:00', 5, 50),
(8, 'Грач', 'другое', '110.00', '4.000', 333, '2024-12-12 00:00:00', 4, 50),
(9, 'тетушка совунья', 'проза', '5000.00', '5.000', 454, '2024-12-12 00:00:00', 4, 50),
(12, 'кар карыч', 'проза', '2222.00', '0.000', 0, '2025-04-16 10:46:49', 2, 100);

--
-- Триггеры `books`
--
DELIMITER $$
CREATE TRIGGER `DeleteFromBooksLogs` AFTER DELETE ON `books` FOR EACH ROW INSERT INTO logs VALUES ('books', 'DELETE', NOW(), CURRENT_USER())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `InsertInBooks` BEFORE INSERT ON `books` FOR EACH ROW IF NEW.Price > 5000 THEN
    SET NEW.Price = 5000;
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `InsertInBooksLogs` AFTER INSERT ON `books` FOR EACH ROW INSERT INTO logs VALUES ('books', 'INSERT', NOW(), CURRENT_USER())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UpdateBooksLogs` AFTER UPDATE ON `books` FOR EACH ROW INSERT INTO logs VALUES ('books', 'UPDATE', NOW(), CURRENT_USER())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `booksinfo`
--

CREATE TABLE `booksinfo` (
  `BookId` int NOT NULL,
  `Title` varchar(50) NOT NULL,
  `SecondName` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `PublicationYear` year DEFAULT NULL,
  `Price` decimal(6,4) NOT NULL,
  `EntranceDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `composition`
--

CREATE TABLE `composition` (
  `BookId` int NOT NULL,
  `OrderId` int NOT NULL,
  `Count` tinyint UNSIGNED NOT NULL DEFAULT '1'
) ;

--
-- Дамп данных таблицы `composition`
--

INSERT INTO `composition` (`BookId`, `OrderId`, `Count`) VALUES
(1, 1, 1),
(1, 2, 4),
(2, 1, 2),
(2, 2, 10),
(2, 4, 5),
(3, 2, 1),
(3, 4, 3),
(4, 2, 1),
(4, 5, 1),
(5, 5, 4);

--
-- Триггеры `composition`
--
DELIMITER $$
CREATE TRIGGER `InsertInComposition` AFTER INSERT ON `composition` FOR EACH ROW SELECT SUM(composition.Count * Price) INTO @orderCost
    FROM composition
    LEFT JOIN books ON composition.BookId = books.BookId
    WHERE OrderId = NEW.OrderId
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TakeBooks` BEFORE INSERT ON `composition` FOR EACH ROW UPDATE books
SET Count = Count - NEW.Count
WHERE BookId = NEW.BookId
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `customers`
--

CREATE TABLE `customers` (
  `CustomerId` int NOT NULL,
  `Login` varchar(20) NOT NULL,
  `SecondName` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `Address` varchar(100) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `customers`
--

INSERT INTO `customers` (`CustomerId`, `Login`, `SecondName`, `FirstName`, `Address`, `Phone`) VALUES
(1, 'ispp', 'Колосов', 'Вадим ', 'Шенкурск', '89210733512'),
(2, 'ispp21', 'Маратканов', 'Андрей ', 'Архангельск', '12412532523'),
(4, 'ffd', 'Twen', 'Mark', '-', NULL);

--
-- Триггеры `customers`
--
DELIMITER $$
CREATE TRIGGER `AddDeletedCustomers` AFTER DELETE ON `customers` FOR EACH ROW BEGIN
    INSERT INTO DeletedCustomers (CustomerId, Login, SecondName ,FirstName, Address, Phone, DeleteTime)
    VALUES (OLD.CustomerId, OLD.Login, OLD.SecondName, OLD.FirstName, OLD.Address, OLD.Phone, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `deletedcustomers`
--

CREATE TABLE `deletedcustomers` (
  `CustomerId` int NOT NULL,
  `Login` varchar(20) NOT NULL,
  `SecondName` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `Address` varchar(100) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `DeleteTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `deletedcustomers`
--

INSERT INTO `deletedcustomers` (`CustomerId`, `Login`, `SecondName`, `FirstName`, `Address`, `Phone`, `DeleteTime`) VALUES
(5, 'iss', 'Платонов', 'Антон', 'ЛОндан', '35315135', '2025-04-15 08:32:05'),
(6, 'pr15', 'секон', 'Энтони', 'Шолден', NULL, '2025-04-14 11:26:20');

-- --------------------------------------------------------

--
-- Структура таблицы `delivery`
--

CREATE TABLE `delivery` (
  `DeliveryId` int NOT NULL,
  `Amount` smallint NOT NULL,
  `DeliveryDate` date NOT NULL,
  `BookId` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `games`
--

CREATE TABLE `games` (
  `idGame` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `category` varchar(50) NOT NULL,
  `price` decimal(18,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `games`
--

INSERT INTO `games` (`idGame`, `name`, `description`, `category`, `price`) VALUES
(1, 'Sim City', 'Градостроительный Sim симулятор снова с вами! Создайте город своей мечты', 'Симулятор', '1499.00'),
(2, 'TITANFALL', 'Эта симулятор игра перенесет Sim симулятор вас во вселенную, где малое противопоставляется большому, природа – индустрии, а человек – машине', 'Шутер', '2299.00'),
(3, 'Battlefield 4', 'симулятор Battlefield 4 – это определяющий  симулятор для жанра, полный симулятор экшена боевик, известный своей разрушаемостью, равных которой нет', 'Шутер', '899.40'),
(4, 'The Sims 4', 'В симулятор реальности каждому Sim симулятор человеку дано симулятор прожить лишь одну жизнь. Но с помощью The Sims 4 это ограничение можно снять! Вам решать — где, как и с кем жить, чем заниматься, чем украшать и обустраивать свой дом', 'Симулятор', '15.00'),
(5, 'Dark Souls 2', 'Продолжение симулятор знаменитого ролевого экшена вновь заставит игроков пройти через сложнейшие испытания. Dark Souls II предложит нового героя, новую историю и новый мир. Лишь одно неизменно – выжить в мрачной вселенной Dark Souls очень непросто.', 'RPG', '949.00'),
(6, 'The Elder Scrolls V: Skyrim', 'После убийства короля Скайрима империя оказалась на грани катастрофы. Вокруг претендентов на престол сплотились новые союзы, и разгорелся конфликт. К тому же, как предсказывали древние свитки, в мир вернулись жестокие и беспощадные драконы. Теперь будущее Скайрима и всей империи зависит от драконорожденного — человека, в жилах которого течет кровь легендарных существ.', 'RPG', '1399.00'),
(7, 'FIFA 14', 'Достоверный, красивый, эмоциональный футбол! Проверенный временем геймплей FIFA стал ещё лучше благодаря инновациям, поощряющим творческую игру в центре поля и позволяющим задавать её темп.', 'Симулятор', '699.00'),
(8, 'Need for Speed Rivals', 'Забудьте про стандартные режимы игры. Сотрите грань между одиночным и многопользовательским режимом в постоянном соперничестве между гонщиками и полицией. Свободно войдите в мир, в котором ваши друзья уже участвуют в гонках и погонях. ', 'Симулятор', '15.00'),
(9, 'Crysis 3', 'Действие игры разворачивается в 2047 году, а вам предстоит выступить в роли Пророка.', 'Шутер', '1299.00'),
(10, 'Dead Space 3', 'В Dead Space 3 Айзек Кларк и суровый солдат Джон Карвер отправляются в космическое путешествие, чтобы узнать о происхождении некроморфов.', 'Шутер', '499.00');

-- --------------------------------------------------------

--
-- Структура таблицы `logs`
--

CREATE TABLE `logs` (
  `Table` varchar(30) NOT NULL,
  `Operation` varchar(20) NOT NULL,
  `Datetime` datetime NOT NULL,
  `User` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `logs`
--

INSERT INTO `logs` (`Table`, `Operation`, `Datetime`, `User`) VALUES
('books', 'UPDATE', '2025-04-15 08:05:52', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-15 08:07:58', 'root@127.0.0.1'),
('books', 'INSERT', '2025-04-15 08:08:37', 'root@127.0.0.1'),
('books', 'DELETE', '2025-04-15 08:10:35', 'root@127.0.0.1'),
('orders', 'INSERT', '2025-04-15 08:14:02', 'root@127.0.0.1'),
('orders', 'UPDATE', '2025-04-15 08:14:15', 'root@127.0.0.1'),
('orders', 'DELETE', '2025-04-15 08:14:27', 'root@127.0.0.1'),
('orders', 'INSERT', '2025-04-15 08:20:26', 'root@127.0.0.1'),
('orders', 'INSERT', '2025-04-15 08:28:03', 'root@127.0.0.1'),
('orders', 'DELETE', '2025-04-15 08:32:05', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-15 08:51:00', 'root@127.0.0.1'),
('books', 'DELETE', '2025-04-16 10:46:09', 'root@127.0.0.1'),
('books', 'INSERT', '2025-04-16 10:46:49', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-16 08:58:33', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-15 08:05:52', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-15 08:07:58', 'root@127.0.0.1'),
('books', 'INSERT', '2025-04-15 08:08:37', 'root@127.0.0.1'),
('books', 'DELETE', '2025-04-15 08:10:35', 'root@127.0.0.1'),
('orders', 'INSERT', '2025-04-15 08:14:02', 'root@127.0.0.1'),
('orders', 'UPDATE', '2025-04-15 08:14:15', 'root@127.0.0.1'),
('orders', 'DELETE', '2025-04-15 08:14:27', 'root@127.0.0.1'),
('orders', 'INSERT', '2025-04-15 08:20:26', 'root@127.0.0.1'),
('orders', 'INSERT', '2025-04-15 08:28:03', 'root@127.0.0.1'),
('orders', 'DELETE', '2025-04-15 08:32:05', 'root@127.0.0.1'),
('books', 'UPDATE', '2025-04-15 08:51:00', 'root@127.0.0.1'),
('books', 'DELETE', '2025-04-16 10:46:09', 'root@127.0.0.1'),
('books', 'INSERT', '2025-04-16 10:46:49', 'root@127.0.0.1');

-- --------------------------------------------------------

--
-- Структура таблицы `myeventtable`
--

CREATE TABLE `myeventtable` (
  `id` int NOT NULL,
  `eventTime` datetime NOT NULL,
  `eventName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `myeventtable`
--

INSERT INTO `myeventtable` (`id`, `eventTime`, `eventName`) VALUES
(1, '2025-04-12 10:40:00', 'event1'),
(2, '2025-04-12 10:40:10', 'event1'),
(3, '2025-04-12 10:40:20', 'event1'),
(4, '2025-04-12 10:40:30', 'event1'),
(5, '2025-04-12 10:40:40', 'event1'),
(6, '2025-04-12 10:40:50', 'event1'),
(7, '2025-04-12 10:41:00', 'event1'),
(8, '2025-04-12 10:41:10', 'event1'),
(9, '2025-04-12 10:41:20', 'event1'),
(10, '2025-04-12 10:41:30', 'event1'),
(11, '2025-04-12 10:41:40', 'event1'),
(12, '2025-04-12 10:41:50', 'event1'),
(13, '2025-04-12 10:42:00', 'event1'),
(14, '2025-04-12 10:42:10', 'event1'),
(15, '2025-04-12 10:42:20', 'event1'),
(16, '2025-04-12 10:42:30', 'event1'),
(17, '2025-04-12 10:42:30', 'event2'),
(18, '2025-04-12 10:42:40', 'event1'),
(19, '2025-04-12 10:42:50', 'event1'),
(20, '2025-04-12 10:43:00', 'event1'),
(21, '2025-04-12 10:43:11', 'event1'),
(22, '2025-04-12 10:43:21', 'event1'),
(23, '2025-04-12 10:43:30', 'event1'),
(24, '2025-04-12 10:43:40', 'event1'),
(25, '2025-04-12 10:43:50', 'event1'),
(26, '2025-04-12 10:44:00', 'event1'),
(27, '2025-04-12 10:44:10', 'event1'),
(28, '2025-04-12 10:44:20', 'event1'),
(29, '2025-04-12 10:44:30', 'event1'),
(30, '2025-04-12 10:44:40', 'event1'),
(31, '2025-04-12 10:44:50', 'event1'),
(32, '2025-04-12 10:45:00', 'event1'),
(33, '2025-04-12 10:45:00', 'event3'),
(34, '2025-04-12 10:45:00', 'event2'),
(35, '2025-04-12 10:47:30', 'event2'),
(36, '2025-04-12 10:50:00', 'event2'),
(37, '2025-04-12 10:51:41', 'eventAuthor'),
(38, '2025-04-12 10:52:30', 'event2'),
(39, '2025-04-12 10:55:00', 'event2'),
(40, '2025-04-12 10:57:30', 'event2'),
(41, '2025-04-12 11:00:00', 'event2'),
(42, '2025-04-12 11:02:30', 'event2'),
(43, '2025-04-12 11:05:00', 'event2'),
(44, '2025-04-12 11:07:30', 'event2'),
(45, '2025-04-12 11:10:00', 'event2'),
(46, '2025-04-12 11:12:30', 'event2'),
(47, '2025-04-12 11:14:50', 'eventAuthor'),
(48, '2025-04-12 11:15:00', 'event2'),
(49, '2025-04-12 11:17:30', 'event2'),
(50, '2025-04-12 11:20:00', 'event2'),
(51, '2025-04-12 11:22:30', 'event2'),
(52, '2025-04-12 11:25:00', 'event2'),
(53, '2025-04-12 11:27:30', 'event2'),
(54, '2025-04-12 11:30:00', 'event2'),
(55, '2025-04-12 11:32:30', 'event2'),
(56, '2025-04-12 11:35:00', 'event2'),
(57, '2025-04-12 11:37:30', 'event2'),
(58, '2025-04-12 11:40:00', 'event2'),
(59, '2025-04-12 11:42:30', 'event2'),
(60, '2025-04-12 11:45:00', 'event2'),
(61, '2025-04-12 11:47:30', 'event2'),
(62, '2025-04-12 11:50:00', 'event2'),
(63, '2025-04-12 11:52:30', 'event2'),
(64, '2025-04-12 11:55:00', 'event2'),
(65, '2025-04-12 11:57:30', 'event2'),
(66, '2025-04-12 12:00:00', 'event2'),
(67, '2025-04-12 12:02:30', 'event2');

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `OrderId` int NOT NULL,
  `OrderDatetime` varchar(45) NOT NULL,
  `CustomerId` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`OrderId`, `OrderDatetime`, `CustomerId`) VALUES
(1, '2024-12-12 00:00:00', 1),
(2, '2025-12-12 00:00:00', 2),
(4, '2026-12-12 00:00:00', 1),
(5, '2024-12-12 00:00:00', 2),
(6, '2025-04-14 11:07:24', 4),
(8, '2025-04-15 08:20:26', 2);

--
-- Триггеры `orders`
--
DELIMITER $$
CREATE TRIGGER `DeleteOrdersLogs` AFTER DELETE ON `orders` FOR EACH ROW BEGIN
    INSERT INTO logs VALUES ('orders', 'DELETE', NOW(), CURRENT_USER());
    DELETE FROM customers
        WHERE CustomerId NOT IN (
            SELECT DISTINCT orders.CustomerId FROM orders
        );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `InsertInOrder` BEFORE INSERT ON `orders` FOR EACH ROW SET NEW.OrderDatetime = NOW()
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `InsertInOrdersLogs` AFTER INSERT ON `orders` FOR EACH ROW INSERT INTO logs VALUES ('orders', 'INSERT', NOW(), CURRENT_USER())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UpdateOrdersLogs` AFTER UPDATE ON `orders` FOR EACH ROW INSERT INTO logs VALUES ('orders', 'UPDATE', NOW(), CURRENT_USER())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `tempbooks`
--

CREATE TABLE `tempbooks` (
  `SecondName` varchar(100) DEFAULT NULL,
  `FirstName` varchar(100) DEFAULT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `video_games`
--

CREATE TABLE `video_games` (
  `Title` varchar(200) DEFAULT NULL,
  `MaxPlayers` tinyint DEFAULT NULL,
  `Genres` varchar(100) DEFAULT NULL,
  `Release Console` varchar(100) DEFAULT NULL,
  `ReleaseYear` smallint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `video_games`
--

INSERT INTO `video_games` (`Title`, `MaxPlayers`, `Genres`, `Release Console`, `ReleaseYear`) VALUES
('Super Mario 64 DS', 1, 'Action', 'Nintendo DS', 2004),
('Lumines: Puzzle Fusion', 1, 'Strategy', 'Sony PSP', 2004),
('WarioWare Touched!', 2, 'Action,Racing / Driving,Sports', 'Nintendo DS', 2004),
('Hot Shots Golf: Open Tee', 1, 'Sports', 'Sony PSP', 2004),
('Spider-Man 2', 1, 'Action', 'Nintendo DS', 2004),
('The Urbz: Sims in the City', 1, 'Simulation', 'Nintendo DS', 2004),
('Ridge Racer', 1, 'Racing / Driving', 'Sony PSP', 2004),
('Metal Gear Ac!d', 1, 'Strategy', 'Sony PSP', 2004),
('Madden NFL 2005', 1, 'Sports', 'Nintendo DS', 2004),
('Pokmon Dash', 1, 'Racing / Driving', 'Nintendo DS', 2004),
('Dynasty Warriors', 1, 'Action,Adventure,Role-Playing (RPG)', 'Sony PSP', 2004),
('Feel the Magic XY/XX', 1, 'Action,Adventure,Racing / Driving,Sports', 'Nintendo DS', 2004),
('Ridge Racer DS', 1, 'Racing / Driving', 'Nintendo DS', 2004),
('Darkstalkers Chronicle: The Chaos Tower', 1, 'Action', 'Sony PSP', 2004),
('Ape Escape Academy', 4, 'Action,Sports', 'Sony PSP', 2004),
('Polarium', 1, 'Strategy', 'Nintendo DS', 2004),
('Asphalt: Urban GT', 1, 'Racing / Driving,Simulation', 'Nintendo DS', 2004),
('Zoo Keeper', 1, 'Action', 'Nintendo DS', 2004),
('Mr. DRILLER: Drill Spirits', 1, 'Action', 'Nintendo DS', 2004),
('Sprung', 1, 'Adventure', 'Nintendo DS', 2004),
('Armored Core: Formula Front - Extreme Battle', 1, 'Action,Strategy', 'Sony PSP', 2004),
('Puyo Pop Fever', 1, 'Action,Strategy', 'Nintendo DS', 2004),
('Mario Kart DS', 1, 'Racing / Driving', 'Nintendo DS', 2005),
('Nintendogs', 1, 'Simulation', 'Nintendo DS', 2005),
('Brain Age: Train Your Brain in Minutes a Day!', 1, 'Action', 'Nintendo DS', 2005),
('Brain Agey: More Training in Minutes a Day!', 1, 'Action', 'Nintendo DS', 2005),
('Grand Theft Auto: Liberty City Stories', 1, 'Action,Racing / Driving', 'Sony PSP', 2005),
('Animal Crossing: Wild World', 1, 'Simulation', 'Nintendo DS', 2005),
('Big Brain Academy', 1, 'Action', 'Nintendo DS', 2005),
('Call of Duty 2', 4, 'Action', 'X360', 2005),
('Midnight Club 3: DUB Edition', 1, 'Racing / Driving', 'Sony PSP', 2005),
('Need for Speed: Most Wanted 5-1-0', 1, 'Racing / Driving', 'Sony PSP', 2005),
('Pokmon Mystery Dungeon: Blue Rescue Team', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2005),
('Sonic Rush', 1, 'Action', 'Nintendo DS', 2005),
('Star Wars: Battlefront II', 1, 'Action', 'Sony PSP', 2005),
('SOCOM: U.S. Navy SEALs - Fireteam Bravo', 1, 'Action', 'Sony PSP', 2005),
('Need for Speed: Most Wanted', 2, 'Racing / Driving', 'X360', 2005),
('Zoo Tycoon DS', 1, 'Simulation,Strategy', 'Nintendo DS', 2005),
('The Sims 2', 1, 'Role-Playing (RPG),Simulation', 'Nintendo DS', 2005),
('Mario & Luigi: Partners in Time', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2005),
('Madden NFL 06', 1, 'Sports', 'Sony PSP', 2005),
('Need for Speed Underground: Rivals', 4, 'Racing / Driving', 'Sony PSP', 2005),
('Twisted Metal: Head-On', 1, 'Action,Racing / Driving', 'Sony PSP', 2005),
('Perfect Dark Zero', 4, 'Action', 'X360', 2005),
('Super Monkey Ball: Touch & Roll', 1, 'Action', 'Nintendo DS', 2005),
('Super Princess Peach', 1, 'Action', 'Nintendo DS', 2005),
('Burnout Legends', 1, 'Action,Racing / Driving', 'Sony PSP', 2005),
('Madden NFL 06', 2, 'Sports', 'X360', 2005),
('Clubhouse Games', 1, 'Strategy', 'Nintendo DS', 2005),
('ATV Offroad Fury: Blazin\' Trails', 4, 'Racing / Driving,Sports', 'Sony PSP', 2005),
('Untold Legends: Brotherhood of the Blade', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2005),
('Tony Hawk\'s Underground 2: Remix', 1, 'Sports', 'Sony PSP', 2005),
('The Sims 2', 1, 'Simulation,Strategy', 'Sony PSP', 2005),
('WipEout Pure', 1, 'Action,Racing / Driving', 'Sony PSP', 2005),
('NBA Live 06', 1, 'Sports', 'Sony PSP', 2005),
('WWE Smackdown vs. Raw 2006', 4, 'Action,Sports', 'Sony PSP', 2005),
('Dead or Alive 4', 4, 'Action', 'X360', 2005),
('Phoenix Wright: Ace Attorney', 1, 'Adventure,Simulation', 'Nintendo DS', 2005),
('Spider-Man 2', 1, 'Action', 'Sony PSP', 2005),
('NFL Street 2', 4, 'Sports', 'Sony PSP', 2005),
('Kirby: Canvas Curse', 1, 'Action', 'Nintendo DS', 2005),
('Battlefield 2: Modern Combat', 4, 'Action', 'X360', 2005),
('Yoshi Touch & Go', 1, 'Action', 'Nintendo DS', 2005),
('Tiger Woods PGA Tour 06', 4, 'Sports', 'X360', 2005),
('Condemned: Criminal Origins', 1, 'Action,Adventure', 'X360', 2005),
('Peter Jackson\'s King Kong: The Official Game of...', 2, 'Action', 'X360', 2005),
('Castlevania: Dawn of Sorrow', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2005),
('SpongeBob SquarePants: The Yellow Avenger', 1, 'Action', 'Nintendo DS', 2005),
('Marvel Nemesis: Rise of the Imperfects ', 1, 'Action', 'Sony PSP', 2005),
('Kameo: Elements of Power', 1, 'Action', 'X360', 2005),
('Advance Wars: Dual Strike', 1, 'Strategy', 'Nintendo DS', 2005),
('Trauma Center: Under the Knife', 1, 'Action,Simulation', 'Nintendo DS', 2005),
('Coded Arms', 1, 'Action', 'Sony PSP', 2005),
('NBA LIVE 06 ', 1, 'Sports', 'X360', 2005),
('Tony Hawk\'s American Wasteland', 1, 'Sports', 'X360', 2005),
('Star Wars: Episode III - Revenge of the Sith', 1, 'Action', 'Nintendo DS', 2005),
('Capcom Classics Collection Remixed', 1, 'Action', 'Sony PSP', 2005),
('Madagascar', 1, 'Adventure', 'Nintendo DS', 2005),
('X-Men: Legends II - Rise of Apocalypse', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2005),
('Quake 4', 1, 'Action', 'X360', 2005),
('Pokmon Trozei!', 1, 'Strategy', 'Nintendo DS', 2005),
('Need for Speed: Most Wanted', 1, 'Racing / Driving', 'Nintendo DS', 2005),
('Mega Man Maverick Hunter X', 1, 'Action', 'Sony PSP', 2005),
('Metroid Prime Pinball', 1, 'Action,Simulation', 'Nintendo DS', 2005),
('NBA 06', 1, 'Sports', 'Sony PSP', 2005),
('GUN ', 1, 'Action,Racing / Driving,Role-Playing (RPG)', 'X360', 2005),
('NBA 2K6 ', 1, 'Sports', 'X360', 2005),
('Pinball Hall of Fame: The Gottlieb Collection', 4, 'Action', 'Sony PSP', 2005),
('Harry Potter and the Goblet of Fire', 1, 'Action', 'Nintendo DS', 2005),
('Tony Hawk\'s American Sk8land', 1, 'Sports', 'Nintendo DS', 2005),
('MVP Baseball', 1, 'Sports', 'Sony PSP', 2005),
('Tiger Woods PGA Tour', 1, 'Sports', 'Sony PSP', 2005),
('World Series of Poker', 1, 'Sports,Strategy', 'Sony PSP', 2005),
('SSX on Tour', 1, 'Sports', 'Sony PSP', 2005),
('Tiger Woods PGA Tour 06', 1, 'Sports', 'Sony PSP', 2005),
('Death Jr.', 1, 'Action', 'Sony PSP', 2005),
('Harry Potter and the Goblet of Fire', 1, 'Action', 'Sony PSP', 2005),
('MediEvil Resurrection', 1, 'Action', 'Sony PSP', 2005),
('The Chronicles of Narnia: The Lion, the Witch a...', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2005),
('Shrek SuperSlam', 1, 'Action', 'Nintendo DS', 2005),
('Virtua Tennis: World Tour', 1, 'Sports', 'Sony PSP', 2005),
('Prince of Persia: Revelations', 1, 'Action', 'Sony PSP', 2005),
('Burnout Legends', 1, 'Action,Racing / Driving', 'Nintendo DS', 2005),
('Meteos', 1, 'Strategy', 'Nintendo DS', 2005),
('Spyro: Shadow Legacy', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2005),
('The Con', 1, 'Action', 'Sony PSP', 2005),
('Infected', 1, 'Action', 'Sony PSP', 2005),
('Pursuit Force', 1, 'Action,Racing / Driving', 'Sony PSP', 2005),
('Kingdom of Paradise', 2, 'Action,Role-Playing (RPG)', 'Sony PSP', 2005),
('Dragon Ball Z: Supersonic Warriors 2', 1, 'Action', 'Nintendo DS', 2005),
('Dragon Quest Heroes: Rocket Slime', 1, 'Action', 'Nintendo DS', 2005),
('Dead to Rights: Reckoning', 1, 'Action', 'Sony PSP', 2005),
('Amped 3', 1, 'Sports', 'X360', 2005),
('Break \'em All', 1, 'Action', 'Nintendo DS', 2005),
('Lunar: Dragon Song', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2005),
('Madden NFL 06', 1, 'Sports', 'Nintendo DS', 2005),
('Retro Atari Classics', 1, 'Action,Racing / Driving,Simulation', 'Nintendo DS', 2005),
('True Swing Golf', 1, 'Sports', 'Nintendo DS', 2005),
('FIFA Soccer', 1, 'Sports', 'Sony PSP', 2005),
('Metal Gear Ac!d 2', 1, 'Strategy', 'Sony PSP', 2005),
('ATV Quad Frenzy', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2005),
('Bomberman', 1, 'Strategy', 'Nintendo DS', 2005),
('GoldenEye: Rogue Agent', 1, 'Action', 'Nintendo DS', 2005),
('Need for Speed Underground 2', 1, 'Racing / Driving', 'Nintendo DS', 2005),
('Frogger: Helmet Chaos', 1, 'Action', 'Sony PSP', 2005),
('The Lord of the Rings: Tactics', 1, 'Role-Playing (RPG),Strategy', 'Sony PSP', 2005),
('Rengoku: The Tower of Purgatory', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2005),
('Gretzky NHL', 2, 'Sports', 'Sony PSP', 2005),
('Ridge Racer 6', 2, 'Racing / Driving', 'X360', 2005),
('Ford Racing 3', 1, 'Action,Racing / Driving', 'Nintendo DS', 2005),
('NHL 2K6 ', 1, 'Sports', 'X360', 2005),
('Bust-a-Move DS', 1, 'Action,Strategy', 'Nintendo DS', 2005),
('Battles of Prince of Persia', 1, 'Strategy', 'Nintendo DS', 2005),
('GripShift', 1, 'Racing / Driving', 'Sony PSP', 2005),
('Marvel Nemesis: Rise of the Imperfects ', 1, 'Action', 'Nintendo DS', 2005),
('Scooby-Doo! Unmasked', 1, 'Action', 'Nintendo DS', 2005),
('Viewtiful Joe: Double Trouble!', 1, 'Action', 'Nintendo DS', 2005),
('The Legend of Heroes: A Tear of Vermillion', 1, 'Role-Playing (RPG)', 'Sony PSP', 2005),
('PQ: Practical Intelligence Quotient', 1, 'Strategy', 'Sony PSP', 2005),
('Lost in Blue', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2005),
('Ghost in the Shell: Stand Alone Complex', 1, 'Action', 'Sony PSP', 2005),
('Dig Dug: Digging Strike', 1, 'Action', 'Nintendo DS', 2005),
('Frogger: Helmet Chaos', 1, 'Action', 'Nintendo DS', 2005),
('Mega Man Battle Network 5: Double Team DS', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2005),
('Nanostray', 1, 'Action', 'Nintendo DS', 2005),
('Sega Casino', 1, 'Simulation', 'Nintendo DS', 2005),
('Teenage Mutant Ninja Turtles 3: Mutant Nightmare', 1, 'Action,Adventure', 'Nintendo DS', 2005),
('Pac-Man World 3', 1, 'Action', 'Sony PSP', 2005),
('Tokobot', 1, 'Strategy', 'Sony PSP', 2005),
('Fullmetal Alchemist: Dual Sympathy', 1, 'Action', 'Nintendo DS', 2005),
('Exit', 1, 'Action', 'Sony PSP', 2005),
('Bubble Bobble Revolution', 1, 'Action', 'Nintendo DS', 2005),
('The Rub Rabbits!', 2, 'Action,Adventure', 'Nintendo DS', 2005),
('Electroplankton', 1, 'Simulation', 'Nintendo DS', 2005),
('LifeSigns: Surgical Unit', 1, 'Simulation,Strategy', 'Nintendo DS', 2005),
('Space Invaders Revolution', 1, 'Action', 'Nintendo DS', 2005),
('Wii Play', 2, 'Action,Sports', 'Nintendo Wii', 2006),
('New Super Mario Bros.', 1, 'Action', 'Nintendo DS', 2006),
('Pokmon Diamond', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Pokmon Pearl', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Gears of War', 2, 'Action', 'X360', 2006),
('The Legend of Zelda: Twilight Princess', 1, 'Action,Role-Playing (RPG)', 'Nintendo Wii', 2006),
('Cooking Mama', 1, 'Simulation', 'Nintendo DS', 2006),
('Marvel Ultimate Alliance', 4, 'Action,Role-Playing (RPG)', 'X360', 2006),
('Daxter', 1, 'Action', 'Sony PSP', 2006),
('The Elder Scrolls IV: Oblivion', 1, 'Action,Role-Playing (RPG)', 'X360', 2006),
('Madden NFL 07', 2, 'Sports', 'X360', 2006),
('Grand Theft Auto: Vice City Stories', 1, 'Action,Racing / Driving', 'Sony PSP', 2006),
('Resistance: Fall of Man', 4, 'Action', 'PlayStation 3', 2006),
('MotorStorm', 1, 'Action,Racing / Driving,Sports', 'PlayStation 3', 2006),
('Call of Duty 3', 2, 'Action', 'X360', 2006),
('Yoshi\'s Island DS', 1, 'Action', 'Nintendo DS', 2006),
('Tom Clancy\'s Ghost Recon: Advanced Warfighter', 4, 'Action', 'X360', 2006),
('Fight Night Round 3', 2, 'Action,Sports', 'X360', 2006),
('Pokmon Ranger', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Rayman Raving Rabbids', 4, 'Action', 'Nintendo Wii', 2006),
('Saints Row', 1, 'Action,Racing / Driving', 'X360', 2006),
('Tom Clancy\'s Rainbow Six: Vegas', 2, 'Action', 'X360', 2006),
('Dead Rising', 1, 'Action', 'X360', 2006),
('Call of Duty 3', 1, 'Action', 'Nintendo Wii', 2006),
('Lost Planet: Extreme Condition', 1, 'Action', 'X360', 2006),
('Mario Hoops 3 on 3', 1, 'Sports', 'Nintendo DS', 2006),
('LEGO Star Wars II: The Original Trilogy', 1, 'Action', 'Nintendo DS', 2006),
('Super Monkey Ball: Banana Blitz', 4, 'Action', 'Nintendo Wii', 2006),
('The Sims 2: Pets', 1, 'Simulation', 'Nintendo DS', 2006),
('Need for Speed: Carbon - Own the City', 1, 'Racing / Driving', 'Sony PSP', 2006),
('WarioWare: Smooth Moves', 6, 'Action,Racing / Driving,Sports', 'Nintendo Wii', 2006),
('Fight Night Round 3', 2, 'Action,Sports', 'PlayStation 3', 2006),
('Final Fantasy III', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('SOCOM: U.S. Navy SEALs - Fireteam Bravo 2', 1, 'Action', 'Sony PSP', 2006),
('Madden NFL 07', 1, 'Sports', 'Sony PSP', 2006),
('Monster 4x4: World Circuit', 4, 'Racing / Driving', 'Nintendo Wii', 2006),
('Kirby: Squeak Squad', 1, 'Action', 'Nintendo DS', 2006),
('Pokmon Battle Revolution', 4, 'Action,Strategy', 'Nintendo Wii', 2006),
('Medal of Honor: Heroes', 1, 'Action', 'Sony PSP', 2006),
('Tekken: Dark Resurrection', 1, 'Action', 'Sony PSP', 2006),
('Need for Speed: Carbon', 2, 'Racing / Driving', 'X360', 2006),
('Mario vs. Donkey Kong 2: March of the Minis', 1, 'Action', 'Nintendo DS', 2006),
('Sonic Rivals', 1, 'Action,Racing / Driving', 'Sony PSP', 2006),
('NCAA Football 07', 2, 'Sports', 'X360', 2006),
('Mortal Kombat: Unchained', 2, 'Action', 'Sony PSP', 2006),
('Tom Clancy\'s Splinter Cell: Double Agent', 1, 'Action', 'X360', 2006),
('Tetris DS', 1, 'Strategy', 'Nintendo DS', 2006),
('LEGO Star Wars II: The Original Trilogy', 2, 'Action', 'Sony PSP', 2006),
('Red Steel', 4, 'Action', 'Nintendo Wii', 2006),
('Metroid Prime: Hunters', 1, 'Action', 'Nintendo DS', 2006),
('LEGO Star Wars II: The Original Trilogy', 2, 'Action', 'X360', 2006),
('NBA 2K7 ', 1, 'Sports', 'X360', 2006),
('SEGA Genesis Collection', 2, 'Action,Racing / Driving,Role-Playing (RPG),Strategy', 'Sony PSP', 2006),
('Call of Duty 3', 1, 'Action', 'PlayStation 3', 2006),
('NBA Live 07', 1, 'Sports', 'Sony PSP', 2006),
('Madden NFL 07', 2, 'Sports', 'PlayStation 3', 2006),
('SpongeBob SquarePants: The Yellow Avenger', 1, 'Action', 'Sony PSP', 2006),
('Madden NFL 07', 4, 'Sports', 'Nintendo Wii', 2006),
('Fight Night Round 3', 2, 'Action,Simulation,Sports', 'Sony PSP', 2006),
('Need for Speed: Carbon', 2, 'Racing / Driving', 'PlayStation 3', 2006),
('Need for Speed: Carbon', 2, 'Racing / Driving', 'Nintendo Wii', 2006),
('WWE SmackDown vs. Raw 2007', 4, 'Sports', 'X360', 2006),
('Tiger Woods PGA Tour 07', 1, 'Sports', 'X360', 2006),
('Viva Pi$?ata', 4, 'Simulation,Strategy', 'X360', 2006),
('SpongeBob Squarepants: Creature from the Krusty Krab', 1, 'Action,Adventure', 'Nintendo Wii', 2006),
('Tony Hawk\'s Project 8', 2, 'Sports', 'Sony PSP', 2006),
('Tony Hawk\'s Project 8', 2, 'Sports', 'X360', 2006),
('NBA LIVE 07 ', 1, 'Sports', 'X360', 2006),
('Excite Truck', 2, 'Racing / Driving', 'Nintendo Wii', 2006),
('Harvest Moon DS', 1, 'Role-Playing (RPG),Simulation', 'Nintendo DS', 2006),
('Star Fox Command', 1, 'Action', 'Nintendo DS', 2006),
('Metal Gear Solid: Portable Ops', 1, 'Action,Strategy', 'Sony PSP', 2006),
('Marvel Ultimate Alliance', 4, 'Action,Role-Playing (RPG)', 'Nintendo Wii', 2006),
('Blazing Angels: Squadrons of WWII', 2, 'Action', 'X360', 2006),
('Major League Baseball 2K6', 2, 'Sports', 'X360', 2006),
('NCAA Football 07', 1, 'Sports', 'Sony PSP', 2006),
('MLB 06: The Show', 2, 'Sports', 'Sony PSP', 2006),
('Blazing Angels: Squadrons of WWII', 2, 'Action', 'PlayStation 3', 2006),
('WWE SmackDown vs. Raw 2007', 4, 'Sports', 'Sony PSP', 2006),
('Rune Factory: A Fantasy Harvest Moon', 1, 'Role-Playing (RPG),Simulation', 'Nintendo DS', 2006),
('Marvel Ultimate Alliance', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2006),
('Marvel Ultimate Alliance', 4, 'Action,Role-Playing (RPG)', 'PlayStation 3', 2006),
('Tiger Woods PGA Tour 07', 4, 'Sports', 'PlayStation 3', 2006),
('Ace Combat X: Skies of Deception', 1, 'Action,Simulation', 'Sony PSP', 2006),
('Killzone: Liberation', 1, 'Action,Strategy', 'Sony PSP', 2006),
('F.E.A.R.: First Encounter Assault Recon', 1, 'Action', 'X360', 2006),
('NBA 2K7', 7, 'Sports', 'PlayStation 3', 2006),
('Tony Hawk\'s Project 8', 2, 'Sports', 'PlayStation 3', 2006),
('Avatar: The Last Airbender', 1, 'Action', 'Nintendo DS', 2006),
('Castlevania: Portrait of Ruin', 1, 'Action', 'Nintendo DS', 2006),
('Hitman: Blood Money', 1, 'Action', 'X360', 2006),
('Rockstar Games presents Table Tennis', 2, 'Sports', 'X360', 2006),
('Trauma Center: Second Opinion', 1, 'Action,Simulation', 'Nintendo Wii', 2006),
('Tenchu Z', 1, 'Action', 'X360', 2006),
('Elite Beat Agents', 1, 'Action', 'Nintendo DS', 2006),
('Street Fighter Alpha 3 MAX', 1, 'Action', 'Sony PSP', 2006),
('Blue Dragon', 1, 'Role-Playing (RPG)', 'X360', 2006),
('The Lord of the Rings: The Battle for Middle Ea...', 1, 'Strategy', 'X360', 2006),
('Prey', 1, 'Action', 'X360', 2006),
('Over the Hedge', 1, 'Adventure', 'Nintendo DS', 2006),
('Capcom Classics Collection Reloaded', 1, 'Action', 'Sony PSP', 2006),
('Pirates of the Caribbean: Dead Man\'s Chest', 1, 'Action', 'Sony PSP', 2006),
('NHL 07 ', 1, 'Sports', 'X360', 2006),
('Monster Hunter Freedom', 1, 'Action,Strategy', 'Sony PSP', 2006),
('Chromehounds', 1, 'Action,Simulation,Strategy', 'X360', 2006),
('Test Drive Unlimited', 1, 'Racing / Driving', 'X360', 2006),
('Dragon Ball Z: Budokai Tenkaichi 2', 2, 'Action', 'Nintendo Wii', 2006),
('Dragon Quest Monsters: Joker', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Pirates of the Caribbean: Dead Man\'s Chest', 1, 'Action', 'Nintendo DS', 2006),
('NFL Street 3', 1, 'Action,Sports', 'Sony PSP', 2006),
('Syphon Filter: Dark Mirror', 1, 'Action', 'Sony PSP', 2006),
('NBA 07', 4, 'Sports', 'PlayStation 3', 2006),
('Ridge Racer 7', 2, 'Racing / Driving', 'PlayStation 3', 2006),
('The Outfit', 2, 'Action', 'X360', 2006),
('Elebits', 4, 'Action', 'Nintendo Wii', 2006),
('Tony Hawk\'s Downhill Jam', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2006),
('The Sims 2: Pets', 1, 'Simulation', 'Sony PSP', 2006),
('Tiger Woods PGA Tour 07', 1, 'Sports', 'Sony PSP', 2006),
('Thrillville', 1, 'Simulation,Strategy', 'Sony PSP', 2006),
('The Godfather: The Game', 1, 'Action', 'X360', 2006),
('Rampage: Total Destruction', 4, 'Action', 'Nintendo Wii', 2006),
('College Hoops 2K7', 4, 'Sports', 'X360', 2006),
('Far Cry: Instincts - Predator', 4, 'Action', 'X360', 2006),
('Full Auto', 2, 'Action,Racing / Driving', 'X360', 2006),
('Age of Empires: The Age of Kings', 1, 'Strategy', 'Nintendo DS', 2006),
('Need for Speed: Carbon - Own the City', 1, 'Action,Racing / Driving', 'Nintendo DS', 2006),
('Brothers in Arms: D-Day', 1, 'Action', 'Sony PSP', 2006),
('Family Guy Video Game!', 1, 'Action', 'Sony PSP', 2006),
('Superman Returns', 1, 'Action', 'X360', 2006),
('Over G Fighters', 2, 'Simulation', 'X360', 2006),
('Final Fantasy XI Online', 1, 'Action,Role-Playing (RPG)', 'X360', 2006),
('Mystery Dungeon: Shiren the Wanderer', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2006),
('Phoenix Wright: Ace Attorney - Justice for All', 1, 'Adventure,Simulation', 'Nintendo DS', 2006),
('Justice League Heroes', 1, 'Action', 'Sony PSP', 2006),
('Valhalla Knights', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2006),
('Genji: Days of the Blade', 1, 'Action,Role-Playing (RPG)', 'PlayStation 3', 2006),
('Top Spin 2', 4, 'Sports', 'X360', 2006),
('Field Commander', 2, 'Strategy', 'Sony PSP', 2006),
('Children of Mana', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2006),
('Valkyrie Profile: Lenneth', 1, 'Role-Playing (RPG)', 'Sony PSP', 2006),
('Monster House', 1, 'Action', 'Nintendo DS', 2006),
('Enchanted Arms', 1, 'Role-Playing (RPG)', 'X360', 2006),
('NHL 07', 4, 'Sports', 'Sony PSP', 2006),
('Bust-a-Move Deluxe', 2, 'Strategy', 'Sony PSP', 2006),
('Full Auto 2: Battlelines', 2, 'Action,Racing / Driving', 'PlayStation 3', 2006),
('Blitz: The League', 2, 'Sports', 'X360', 2006),
('Star Trek Legacy', 2, 'Action,Strategy', 'X360', 2006),
('Eragon', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2006),
('Master of Illusion', 1, 'Strategy', 'Nintendo DS', 2006),
('Mega Man ZX', 1, 'Action', 'Nintendo DS', 2006),
('Untold Legends: The Warrior\'s Code', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2006),
('Super Swing Golf', 1, 'Sports', 'Nintendo Wii', 2006),
('X-Men: The Official Game', 1, 'Action', 'X360', 2006),
('Untold Legends: Dark Kingdom', 2, 'Action,Role-Playing (RPG)', 'PlayStation 3', 2006),
('Happy Feet', 2, 'Action', 'Nintendo Wii', 2006),
('Open Season', 1, 'Action', 'Nintendo DS', 2006),
('Dungeon Siege: Throne of Agony', 1, 'Role-Playing (RPG)', 'Sony PSP', 2006),
('LocoRoco', 1, 'Action,Strategy', 'Sony PSP', 2006),
('Dead or Alive: Xtreme 2', 1, 'Racing / Driving,Sports', 'X360', 2006),
('Fuzion Frenzy 2', 4, 'Action,Sports', 'X360', 2006),
('MotoGP \'06', 4, 'Racing / Driving,Simulation,Sports', 'X360', 2006),
('Lumines II', 2, 'Strategy', 'Sony PSP', 2006),
('Major League Baseball 2K6', 1, 'Sports', 'Sony PSP', 2006),
('Star Wars: Lethal Alliance', 1, 'Action', 'Sony PSP', 2006),
('Worms: Open Warfare', 1, 'Action,Strategy', 'Sony PSP', 2006),
('Eragon', 4, 'Action', 'Sony PSP', 2006),
('Metal Slug Anthology', 4, 'Action', 'Nintendo Wii', 2006),
('Open Season', 4, 'Action', 'X360', 2006),
('Tom Clancy\'s Splinter Cell: Double Agent', 2, 'Action', 'Nintendo Wii', 2006),
('Avatar: The Last Airbender', 1, 'Action', 'Sony PSP', 2006),
('Lemmings', 1, 'Strategy', 'Sony PSP', 2006),
('Mega Man Powered Up', 1, 'Action', 'Sony PSP', 2006),
('College Hoops 2K6', 1, 'Sports', 'X360', 2006),
('Dynasty Warriors 5: Empires', 2, 'Action,Role-Playing (RPG),Strategy', 'X360', 2006),
('Magical Starsign', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Resident Evil: Deadly Silence', 1, 'Action', 'Nintendo DS', 2006),
('X-Men: The Official Game', 1, 'Action', 'Nintendo DS', 2006),
('Cabela\'s African Safari', 1, 'Sports', 'X360', 2006),
('Cabela\'s Alaskan Adventures', 1, 'Sports', 'X360', 2006),
('Armored Core 4', 2, 'Action', 'PlayStation 3', 2006),
('Eragon', 2, 'Action', 'X360', 2006),
('LostMagic', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2006),
('Magnetica', 1, 'Action,Strategy', 'Nintendo DS', 2006),
('Def Jam Fight for NY: The Takeover', 1, 'Action', 'Sony PSP', 2006),
('NASCAR 07', 1, 'Racing / Driving,Simulation', 'Sony PSP', 2006),
('The Ant Bully', 1, 'Action', 'Nintendo Wii', 2006),
('Just Cause', 1, 'Action,Racing / Driving', 'X360', 2006),
('Onechanbara: Bikini Samurai Squad', 1, 'Action', 'X360', 2006),
('Phantasy Star Universe', 1, 'Role-Playing (RPG)', 'X360', 2006),
('Project Sylpheed: Arc of Deception', 1, 'Action', 'X360', 2006),
('Winning Eleven: Pro Evolution Soccer 2007', 6, 'Sports', 'X360', 2006),
('Kororinpa: Marble Mania', 2, 'Action,Strategy', 'Nintendo Wii', 2006),
('Digimon World DS', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Justice League Heroes', 1, 'Action', 'Nintendo DS', 2006),
('Innocent Life: A Futuristic Harvest Moon', 1, 'Role-Playing (RPG),Simulation,Strategy', 'Sony PSP', 2006),
('Power Stone Collection', 1, 'Action', 'Sony PSP', 2006),
('EA Replay', 4, 'Action,Role-Playing (RPG),Simulation,Sports,Strategy', 'Sony PSP', 2006),
('Open Season', 4, 'Action', 'Nintendo Wii', 2006),
('Samurai Warriors 2', 4, 'Action', 'X360', 2006),
('Far Cry: Vengeance', 2, 'Action', 'Nintendo Wii', 2006),
('Import Tuner Challenge', 2, 'Racing / Driving', 'X360', 2006),
('Contact', 1, 'Adventure,Role-Playing (RPG)', 'Nintendo DS', 2006),
('Touch Detective', 1, 'Adventure', 'Nintendo DS', 2006),
('FIFA Street 2', 1, 'Sports', 'Sony PSP', 2006),
('007: From Russia with Love', 1, 'Action,Racing / Driving', 'Sony PSP', 2006),
('PaRappa the Rapper', 1, 'Action', 'Sony PSP', 2006),
('Riviera: The Promised Land', 1, 'Role-Playing (RPG)', 'Sony PSP', 2006),
('Samurai Warriors: State of War', 1, 'Action', 'Sony PSP', 2006),
('Viewtiful Joe: Red Hot Rumble', 1, 'Action', 'Sony PSP', 2006),
('Ice Age 2: The Meltdown', 1, 'Action', 'Nintendo Wii', 2006),
('Rumble Roses XX', 4, 'Action,Sports', 'X360', 2006),
('Bionicle Heroes', 1, 'Action', 'Nintendo DS', 2006),
('Deep Labyrinth', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Blade Dancer: Lineage of Light', 1, 'Role-Playing (RPG)', 'Sony PSP', 2006),
('Every Extend Extra', 1, 'Action', 'Sony PSP', 2006),
('Ultimate Ghosts \'N\' Goblins', 1, 'Action', 'Sony PSP', 2006),
('Xiaolin Showdown', 1, 'Action', 'Sony PSP', 2006),
('Bionicle Heroes', 1, 'Action', 'X360', 2006),
('Bullet Witch', 1, 'Action', 'X360', 2006),
('Death Jr. II: Root of Evil', 2, 'Action', 'Sony PSP', 2006),
('Alex Rider: Stormbreaker', 1, 'Action,Adventure', 'Nintendo DS', 2006),
('Cartoon Network Racing', 1, 'Racing / Driving', 'Nintendo DS', 2006),
('Guilty Gear: Dust Strikers', 1, 'Action', 'Nintendo DS', 2006),
('Gunpey DS', 1, 'Strategy', 'Nintendo DS', 2006),
('Lara Croft Tomb Raider: Legend', 1, 'Action,Racing / Driving', 'Nintendo DS', 2006),
('Worms: Open Warfare', 1, 'Action,Strategy', 'Nintendo DS', 2006),
('Mercury Meltdown', 1, 'Strategy', 'Sony PSP', 2006),
('MTX Mototrax', 1, 'Racing / Driving,Sports', 'Sony PSP', 2006),
('Snoopy vs. the Red Baron', 1, 'Action', 'Sony PSP', 2006),
('Super Monkey Ball Adventure', 1, 'Action,Racing / Driving', 'Sony PSP', 2006),
('Ys VI: The Ark of Napishtim', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2006),
('Bomberman Land Touch!', 1, 'Action', 'Nintendo DS', 2006),
('Point Blank DS', 1, 'Action', 'Nintendo DS', 2006),
('Scurge: Hive', 1, 'Action', 'Nintendo DS', 2006),
('Star Trek: Tactical Assault', 1, 'Action,Strategy', 'Nintendo DS', 2006),
('Tao\'s Adventure: Curse of the Demon Seal', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2006),
('Ford Bold Moves Street Racing', 1, 'Racing / Driving', 'Sony PSP', 2006),
('Gitaroo Man Lives!', 1, 'Simulation', 'Sony PSP', 2006),
('Gradius Collection', 1, 'Action', 'Sony PSP', 2006),
('The Legend of Heroes II: Prophecy of the Moonli...', 1, 'Role-Playing (RPG)', 'Sony PSP', 2006),
('Pac-Man World Rally', 1, 'Action,Racing / Driving', 'Sony PSP', 2006),
('Bomberman: Act Zero', 1, 'Action', 'X360', 2006),
('Earth Defense Force 2017', 2, 'Action', 'X360', 2006),
('WarTech: Senko no Ronde', 2, 'Action', 'X360', 2006),
('MechAssault: Phantom War', 1, 'Action', 'Nintendo DS', 2006),
('Astonishia Story', 1, 'Role-Playing (RPG),Strategy', 'Sony PSP', 2006),
('B-Boy', 1, 'Action', 'Sony PSP', 2006),
('BattleZone', 1, 'Action', 'Sony PSP', 2006),
('Bounty Hounds', 1, 'Action,Strategy', 'Sony PSP', 2006),
('Bubble Bobble Evolution', 1, 'Action', 'Sony PSP', 2006),
('MotoGP', 1, 'Racing / Driving,Sports', 'Sony PSP', 2006),
('OutRun 2006: Coast 2 Coast', 1, 'Racing / Driving', 'Sony PSP', 2006),
('Warhammer: Battle for Atluma', 1, 'Strategy', 'Sony PSP', 2006),
('SBK: Snowboard Kids', 1, 'Action,Sports', 'Nintendo DS', 2006),
('Tenchu: Dark Secret', 1, 'Action', 'Nintendo DS', 2006),
('Dungeon Maker: Hunting Ground', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2006),
('Metal Gear Solid: Digital Graphic Novel', 1, 'Adventure', 'Sony PSP', 2006),
('Star Trek: Tactical Assault', 1, 'Action,Strategy', 'Sony PSP', 2006),
('Micro Machines V4', 2, 'Action,Racing / Driving', 'Sony PSP', 2006),
('Platypus', 2, 'Action', 'Sony PSP', 2006),
('Custom Robo Arena', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2006),
('Gurumin: A Monstrous Adventure', 1, 'Action', 'Sony PSP', 2006),
('Spider-Man 3', 1, 'Action', 'Sony PSP', 2006),
('Wii Fit', 1, 'Educational,Sports', 'Nintendo Wii', 2007),
('Halo 3', 4, 'Action', 'X360', 2007),
('Call of Duty 4: Modern Warfare', 4, 'Action', 'X360', 2007),
('Super Mario Galaxy', 2, 'Action', 'Nintendo Wii', 2007),
('Mario Party DS', 1, 'Action,Strategy', 'Nintendo DS', 2007),
('Mario Party 8', 4, 'Action,Strategy', 'Nintendo Wii', 2007),
('Guitar Hero III: Legends of Rock', 2, 'Action,Simulation', 'X360', 2007),
('Link\'s Crossbow Training', 1, 'Action', 'Nintendo Wii', 2007),
('Guitar Hero III: Legends of Rock', 2, 'Action,Simulation', 'Nintendo Wii', 2007),
('Assassin\'s Creed', 1, 'Action', 'X360', 2007),
('LEGO Star Wars: The Complete Saga', 2, 'Action', 'Nintendo Wii', 2007),
('Call of Duty 4: Modern Warfare', 4, 'Action', 'PlayStation 3', 2007),
('Mario & Sonic at the Olympic Games', 4, 'Action,Sports', 'Nintendo Wii', 2007),
('LEGO Star Wars: The Complete Saga', 1, 'Action,Racing / Driving', 'Nintendo DS', 2007),
('Forza Motorsport 2', 2, 'Racing / Driving', 'X360', 2007),
('Madden NFL 08', 4, 'Sports', 'X360', 2007),
('Guitar Hero II', 2, 'Action,Simulation', 'X360', 2007),
('Rock Band', 4, 'Action,Simulation', 'X360', 2007),
('The Legend of Zelda: Phantom Hourglass', 1, 'Action', 'Nintendo DS', 2007),
('Pokmon Mystery Dungeon: Explorers of Darkness', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('Pokmon Mystery Dungeon: Explorers of Time', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('Assassin\'s Creed', 1, 'Action', 'PlayStation 3', 2007),
('Uncharted: Drake\'s Fortune', 1, 'Action', 'PlayStation 3', 2007),
('Mass Effect', 1, 'Action,Role-Playing (RPG)', 'X360', 2007),
('Cooking Mama 2: Dinner with Friends', 1, 'Simulation', 'Nintendo DS', 2007),
('BioShock', 1, 'Action', 'X360', 2007),
('Super Paper Mario', 1, 'Action,Role-Playing (RPG)', 'Nintendo Wii', 2007),
('Game Party', 4, 'Action', 'Nintendo Wii', 2007),
('Ratchet & Clank: Size Matters', 1, 'Action', 'Sony PSP', 2007),
('Dance Dance Revolution Hottest Party', 4, 'Action', 'Nintendo Wii', 2007),
('Cooking Mama: Cook Off', 2, 'Simulation', 'Nintendo Wii', 2007),
('Gran Turismo 5: Prologue', 2, 'Racing / Driving,Simulation', 'PlayStation 3', 2007),
('Professor Layton and the Curious Village', 1, 'Adventure,Educational,Strategy', 'Nintendo DS', 2007),
('Resident Evil 4', 1, 'Action', 'Nintendo Wii', 2007),
('The Elder Scrolls IV: Oblivion', 1, 'Action,Role-Playing (RPG)', 'PlayStation 3', 2007),
('Transformers: Autobots', 1, 'Action,Racing / Driving', 'Nintendo DS', 2007),
('Transformers: Decepticons', 1, 'Action,Racing / Driving', 'Nintendo DS', 2007),
('Diddy Kong Racing DS', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2007),
('Big Brain Academy: Wii Degree', 8, 'Action', 'Nintendo Wii', 2007),
('Need for Speed: ProStreet', 2, 'Racing / Driving', 'X360', 2007),
('Deal or No Deal', 1, 'Strategy', 'Nintendo DS', 2007),
('LEGO Star Wars: The Complete Saga', 2, 'Action', 'X360', 2007),
('Sonic and the Secret Rings', 4, 'Action', 'Nintendo Wii', 2007),
('The Orange Box', 1, 'Action', 'X360', 2007),
('Crackdown', 1, 'Action,Racing / Driving,Role-Playing (RPG)', 'X360', 2007),
('Rock Band', 4, 'Action,Simulation', 'PlayStation 3', 2007),
('Tiger Woods PGA Tour 08', 4, 'Sports', 'Nintendo Wii', 2007),
('WWE Smackdown vs. Raw 2008', 4, 'Sports', 'X360', 2007),
('Madden NFL 08', 4, 'Sports', 'PlayStation 3', 2007),
('Call of Duty 4: Modern Warfare', 1, 'Action', 'Nintendo DS', 2007),
('MySims', 1, 'Simulation,Strategy', 'Nintendo Wii', 2007),
('Mario Strikers Charged', 4, 'Action,Sports', 'Nintendo Wii', 2007),
('Star Wars Battlefront: Renegade Squadron', 1, 'Action', 'Sony PSP', 2007),
('Flash Focus: Vision Training in Minutes a Day', 1, 'Action', 'Nintendo DS', 2007),
('Metroid Prime 3: Corruption', 1, 'Action', 'Nintendo Wii', 2007),
('Tom Clancy\'s Ghost Recon: Advanced Warfighter 2...', 1, 'Action', 'X360', 2007),
('Madden NFL 08', 4, 'Sports', 'Nintendo Wii', 2007),
('Ratchet & Clank Future: Tools of Destruction', 1, 'Action', 'PlayStation 3', 2007),
('LEGO Star Wars: The Complete Saga', 2, 'Action', 'PlayStation 3', 2007),
('Rayman Raving Rabbids 2', 4, 'Action', 'Nintendo Wii', 2007),
('NBA 2K8 ', 1, 'Sports', 'X360', 2007),
('Namco Museum DS', 1, 'Action', 'Nintendo DS', 2007),
('Need for Speed: ProStreet', 2, 'Racing / Driving', 'PlayStation 3', 2007),
('Blazing Angels: Squadrons of WWII', 2, 'Action', 'Nintendo Wii', 2007),
('Drawn to Life', 1, 'Action', 'Nintendo DS', 2007),
('EA Playground', 4, 'Action,Racing / Driving,Sports', 'Nintendo Wii', 2007),
('Major League Baseball 2K7', 2, 'Sports', 'X360', 2007),
('Resident Evil: The Umbrella Chronicles', 2, 'Action', 'Nintendo Wii', 2007),
('NCAA Football 08', 2, 'Sports', 'X360', 2007),
('Spectrobes', 1, 'Action,Strategy', 'Nintendo DS', 2007),
('The Sims 2: Castaway', 1, 'Simulation', 'Nintendo DS', 2007),
('WWE Smackdown vs. Raw 2008', 6, 'Sports', 'PlayStation 3', 2007),
('Madden NFL 08', 1, 'Sports', 'Sony PSP', 2007),
('NBA Live 08', 4, 'Sports', 'PlayStation 3', 2007),
('The Simpsons Game', 1, 'Action', 'Nintendo DS', 2007),
('Ace Combat 6: Fires of Liberation', 1, 'Action,Simulation', 'X360', 2007),
('Heavenly Sword', 1, 'Action', 'PlayStation 3', 2007),
('Ninja Gaiden Sigma', 1, 'Action', 'PlayStation 3', 2007),
('Ben 10: Protector of the Earth', 1, 'Action', 'Nintendo Wii', 2007),
('The Simpsons Game', 2, 'Action', 'X360', 2007),
('CrossworDS', 1, 'Educational,Strategy', 'Nintendo DS', 2007),
('Sonic Rush Adventure', 1, 'Action,Sports', 'Nintendo DS', 2007),
('Tiger Woods PGA Tour 08', 4, 'Sports', 'X360', 2007),
('Tony Hawk\'s Proving Ground', 2, 'Sports', 'X360', 2007),
('Call of Duty: Roads to Victory', 1, 'Action', 'Sony PSP', 2007),
('Transformers: The Game', 1, 'Action', 'X360', 2007),
('NBA 2K8', 7, 'Sports', 'PlayStation 3', 2007),
('Medal of Honor: Heroes 2', 1, 'Action', 'Sony PSP', 2007),
('Spider-Man 3', 1, 'Action', 'X360', 2007),
('Tom Clancy\'s Rainbow Six: Vegas', 2, 'Action', 'PlayStation 3', 2007),
('Need for Speed: ProStreet', 2, 'Racing / Driving', 'Nintendo Wii', 2007),
('NBA LIVE 08 ', 1, 'Sports', 'X360', 2007),
('Dance Dance Revolution Universe 2', 4, 'Action', 'X360', 2007),
('MX vs. ATV Untamed', 2, 'Racing / Driving', 'X360', 2007),
('Final Fantasy IV', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('NBA Street Homecourt', 4, 'Sports', 'X360', 2007),
('The Simpsons Game', 2, 'Action', 'Nintendo Wii', 2007),
('Winter Sports: The Ultimate Challenge', 1, 'Racing / Driving,Sports', 'Nintendo Wii', 2007),
('WWE Smackdown vs. Raw 2008', 4, 'Sports', 'Sony PSP', 2007),
('Tiger Woods PGA Tour 07', 4, 'Sports', 'Nintendo Wii', 2007),
('Crash of the Titans', 1, 'Action', 'Nintendo DS', 2007),
('Sonic Rivals 2', 1, 'Action', 'Sony PSP', 2007),
('Boogie', 2, 'Action', 'Nintendo Wii', 2007),
('Medal of Honor: Airborne', 2, 'Action', 'X360', 2007),
('The Sims 2: Castaway', 1, 'Simulation', 'Nintendo Wii', 2007),
('Spider-Man 3', 1, 'Action', 'Nintendo Wii', 2007),
('Lost Odyssey', 1, 'Role-Playing (RPG)', 'X360', 2007),
('Bee Movie Game', 1, 'Adventure', 'Nintendo DS', 2007),
('Spider-Man 3', 1, 'Action', 'Nintendo DS', 2007),
('Final Fantasy Tactics', 1, 'Role-Playing (RPG),Strategy', 'Sony PSP', 2007),
('Endless Ocean', 1, 'Simulation', 'Nintendo Wii', 2007),
('SingStar', 6, 'Simulation', 'PlayStation 3', 2007),
('Ratatouille', 1, 'Action', 'Nintendo Wii', 2007),
('The Sims 2: Pets', 1, 'Simulation', 'Nintendo Wii', 2007),
('Two Worlds', 1, 'Action,Role-Playing (RPG)', 'X360', 2007),
('Crash of the Titans', 2, 'Action', 'Nintendo Wii', 2007),
('Sonic the Hedgehog', 2, 'Action', 'X360', 2007),
('Mega Man Star Force: Dragon', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2007),
('Sonic the Hedgehog', 2, 'Action', 'PlayStation 3', 2007),
('Harry Potter and the Order of the Phoenix', 1, 'Action', 'Nintendo Wii', 2007),
('Nicktoons: Attack of the Toybots', 1, 'Action', 'Nintendo Wii', 2007),
('WWE Smackdown vs. Raw 2008', 4, 'Sports', 'Nintendo Wii', 2007),
('The Simpsons Game', 2, 'Action', 'PlayStation 3', 2007),
('DiRT', 1, 'Racing / Driving,Simulation,Sports', 'X360', 2007),
('Kane & Lynch: Dead Men', 2, 'Action', 'X360', 2007),
('Jam Sessions', 1, 'Educational,Simulation', 'Nintendo DS', 2007),
('Monster Hunter Freedom 2', 1, 'Action,Strategy', 'Sony PSP', 2007),
('Shadowrun', 1, 'Action', 'X360', 2007),
('Thrillville: Off the Rails', 4, 'Simulation,Strategy', 'Nintendo Wii', 2007),
('Tony Hawk\'s Proving Ground', 2, 'Sports', 'PlayStation 3', 2007),
('My Word Coach', 1, 'Educational', 'Nintendo DS', 2007),
('The World Ends With You', 1, 'Action,Adventure,Role-Playing (RPG)', 'Nintendo DS', 2007),
('The BIGS', 4, 'Action,Simulation,Sports', 'Nintendo Wii', 2007),
('NCAA Football 08', 2, 'Sports', 'PlayStation 3', 2007),
('Final Fantasy Tactics A2: Grimoire of the Rift', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2007),
('Beowulf: The Game', 1, 'Action', 'X360', 2007),
('The Darkness', 1, 'Action', 'X360', 2007),
('Tom Clancy\'s Ghost Recon: Advanced Warfighter 2...', 4, 'Action', 'PlayStation 3', 2007),
('Final Fantasy', 1, 'Role-Playing (RPG)', 'Sony PSP', 2007),
('Lair', 1, 'Action', 'PlayStation 3', 2007),
('Transformers: The Game', 1, 'Action', 'Nintendo Wii', 2007),
('Command & Conquer 3: Tiberium Wars', 1, 'Strategy', 'X360', 2007),
('Overlord', 1, 'Action,Strategy', 'X360', 2007),
('Diner Dash', 1, 'Action', 'Nintendo DS', 2007),
('Medal of Honor: Heroes 2', 1, 'Action', 'Nintendo Wii', 2007),
('MX vs. ATV Untamed', 2, 'Racing / Driving', 'PlayStation 3', 2007),
('Time Crisis 4', 2, 'Action', 'PlayStation 3', 2007),
('Dragon Ball Z: Budokai Tenkaichi 3', 2, 'Action', 'Nintendo Wii', 2007),
('Final Fantasy XII: Revenant Wings', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2007),
('SOCOM: U.S. Navy SEALs - Tactical Strike', 1, 'Action,Strategy', 'Sony PSP', 2007),
('Unreal Tournament III', 1, 'Action', 'PlayStation 3', 2007),
('Bee Movie Game', 2, 'Action', 'Nintendo Wii', 2007),
('Def Jam: Icon', 2, 'Action', 'X360', 2007),
('Transformers: The Game', 1, 'Action', 'PlayStation 3', 2007),
('TimeShift', 1, 'Action', 'X360', 2007),
('SSX Blur', 4, 'Sports', 'Nintendo Wii', 2007),
('Bleach: The Blade of Fate', 1, 'Action', 'Nintendo DS', 2007),
('EA Playground', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2007),
('Final Fantasy II', 1, 'Role-Playing (RPG)', 'Sony PSP', 2007),
('The Eye of Judgment', 2, 'Strategy', 'PlayStation 3', 2007),
('MLB 07: The Show', 2, 'Sports', 'PlayStation 3', 2007),
('Virtua Fighter 5', 2, 'Action', 'PlayStation 3', 2007),
('NiGHTS: Journey of Dreams', 2, 'Action', 'Nintendo Wii', 2007),
('Puzzle Quest: Challenge of the Warlords', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2007),
('NBA Live 08', 1, 'Sports', 'Sony PSP', 2007),
('Kane & Lynch: Dead Men', 2, 'Action', 'PlayStation 3', 2007),
('Crash of the Titans', 2, 'Action', 'X360', 2007),
('Harry Potter and the Order of the Phoenix', 1, 'Action', 'Nintendo DS', 2007),
('SimCity DS', 1, 'Simulation', 'Nintendo DS', 2007),
('Wario: Master of Disguise', 1, 'Action', 'Nintendo DS', 2007),
('No More Heroes', 1, 'Action,Racing / Driving', 'Nintendo Wii', 2007),
('BlackSite: Area 51', 1, 'Action', 'X360', 2007),
('Shrek the Third', 2, 'Action', 'X360', 2007),
('Shrek the Third', 1, 'Adventure', 'Nintendo DS', 2007),
('Surf\'s Up', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2007),
('MLB 07: The Show', 1, 'Sports', 'Sony PSP', 2007),
('TMNT', 1, 'Action', 'X360', 2007),
('Spider-Man: Friend or Foe', 2, 'Action', 'X360', 2007),
('Contra 4', 1, 'Action', 'Nintendo DS', 2007),
('Phoenix Wright: Ace Attorney - Trials and Tribu...', 1, 'Adventure,Simulation', 'Nintendo DS', 2007),
('Disney Pirates of the Caribbean: At World\'s End', 1, 'Action', 'Nintendo DS', 2007),
('Dragon Ball Z: Shin Budokai - Another Road', 1, 'Action', 'Sony PSP', 2007),
('Spider-Man 3', 1, 'Action', 'PlayStation 3', 2007),
('The Golden Compass', 1, 'Action', 'X360', 2007),
('Stuntman: Ignition', 4, 'Action,Racing / Driving', 'X360', 2007),
('Chicken Shoot', 2, 'Action', 'Nintendo Wii', 2007),
('Shrek the Third', 2, 'Action', 'Nintendo Wii', 2007),
('DK: Jungle Climber', 1, 'Action,Strategy', 'Nintendo DS', 2007),
('Dragon Quest IV: Chapters of the Chosen', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('300: March to Glory', 1, 'Action', 'Sony PSP', 2007),
('Fire Emblem: Radiant Dawn', 1, 'Role-Playing (RPG),Strategy', 'Nintendo Wii', 2007),
('The Golden Compass', 1, 'Action', 'Nintendo Wii', 2007),
('Manhunt 2', 1, 'Action', 'Nintendo Wii', 2007),
('NASCAR 08', 1, 'Racing / Driving,Sports', 'X360', 2007),
('Virtua Tennis 3', 4, 'Sports', 'PlayStation 3', 2007),
('All-Pro Football 2K8', 4, 'Sports', 'X360', 2007),
('Major League Baseball 2K7', 2, 'Sports', 'PlayStation 3', 2007),
('The Warriors', 1, 'Action', 'Sony PSP', 2007),
('Ghost Rider', 4, 'Action', 'Sony PSP', 2007),
('Tony Hawk\'s Proving Ground', 2, 'Sports', 'Nintendo Wii', 2007),
('Juiced 2: Hot Import Nights', 2, 'Racing / Driving', 'X360', 2007),
('Juiced 2: Hot Import Nights', 1, 'Racing / Driving', 'Nintendo DS', 2007),
('The Simpsons Game', 1, 'Action', 'Sony PSP', 2007),
('Syphon Filter: Logan\'s Shadow', 1, 'Action,Strategy', 'Sony PSP', 2007),
('Tiger Woods PGA Tour 08', 4, 'Sports', 'PlayStation 3', 2007),
('Ratatouille', 4, 'Action', 'X360', 2007),
('Trauma Center: New Blood', 2, 'Action,Simulation', 'Nintendo Wii', 2007),
('Hotel Dusk: Room 215', 1, 'Adventure', 'Nintendo DS', 2007),
('Mega Man ZX Advent', 1, 'Action', 'Nintendo DS', 2007),
('Silent Hill: 0rigins', 1, 'Action', 'Sony PSP', 2007),
('Harry Potter and the Order of the Phoenix', 1, 'Action', 'X360', 2007),
('NHL 08 ', 1, 'Sports', 'X360', 2007),
('Castlevania: The Dracula X Chronicles', 2, 'Action', 'Sony PSP', 2007),
('Tony Hawk\'s Proving Ground', 1, 'Sports', 'Nintendo DS', 2007),
('Jeanne d\'Arc', 1, 'Role-Playing (RPG),Strategy', 'Sony PSP', 2007),
('BWii: Battalion Wars 2', 1, 'Action,Simulation,Strategy', 'Nintendo Wii', 2007),
('Battlestations: Midway', 1, 'Action,Strategy', 'X360', 2007),
('Dragon Ball Z: Harukanaru Densetsu', 1, 'Strategy', 'Nintendo DS', 2007),
('Touch the Dead', 1, 'Action', 'Nintendo DS', 2007),
('The Darkness', 1, 'Action', 'PlayStation 3', 2007),
('Donkey Kong Barrel Blast', 4, 'Racing / Driving', 'Nintendo Wii', 2007),
('The BIGS', 4, 'Action,Simulation,Sports', 'X360', 2007),
('Armored Core 4', 2, 'Action', 'X360', 2007),
('Etrian Odyssey', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('Ben 10: Protector of the Earth', 1, 'Action', 'Sony PSP', 2007),
('Tom Clancy\'s Splinter Cell: Double Agent', 1, 'Action,Strategy', 'PlayStation 3', 2007),
('Looney Tunes: Acme Arsenal', 1, 'Action', 'Nintendo Wii', 2007),
('Zack & Wiki: Quest for Barbaros\' Treasure', 1, 'Adventure', 'Nintendo Wii', 2007),
('Monster Jam', 4, 'Sports', 'X360', 2007),
('Virtua Fighter 5', 2, 'Action', 'X360', 2007),
('Lunar Knights', 1, 'Action', 'Nintendo DS', 2007),
('Enchanted Arms', 1, 'Role-Playing (RPG)', 'PlayStation 3', 2007),
('F.E.A.R.: First Encounter Assault Recon', 1, 'Action', 'PlayStation 3', 2007),
('Folklore', 1, 'Action,Role-Playing (RPG)', 'PlayStation 3', 2007),
('Juiced 2: Hot Import Nights', 1, 'Racing / Driving', 'PlayStation 3', 2007),
('The Elder Scrolls IV: Shivering Isles', 1, 'Action,Role-Playing (RPG)', 'X360', 2007),
('NHL 08', 7, 'Sports', 'PlayStation 3', 2007),
('NCAA 07 March Madness', 4, 'Sports', 'X360', 2007),
('Rayman Raving Rabbids', 4, 'Action', 'X360', 2007),
('Viva Pi$?ata: Party Animals', 4, 'Racing / Driving', 'X360', 2007),
('Warriors Orochi', 2, 'Action,Role-Playing (RPG)', 'X360', 2007),
('Luminous Arc', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2007),
('Picross DS', 1, 'Strategy', 'Nintendo DS', 2007),
('Harry Potter and the Order of the Phoenix', 1, 'Action', 'PlayStation 3', 2007),
('College Hoops 2K7', 6, 'Sports', 'PlayStation 3', 2007),
('The BIGS', 4, 'Action,Simulation,Sports', 'PlayStation 3', 2007),
('Stuntman: Ignition', 4, 'Action,Racing / Driving', 'PlayStation 3', 2007),
('Mortal Kombat: Armageddon', 4, 'Action,Racing / Driving', 'Nintendo Wii', 2007),
('Def Jam: Icon', 2, 'Action', 'PlayStation 3', 2007),
('Soulcalibur Legends', 2, 'Action', 'Nintendo Wii', 2007),
('Surf\'s Up', 2, 'Sports', 'Nintendo Wii', 2007),
('Planet Puzzle League', 1, 'Strategy', 'Nintendo DS', 2007),
('DiRT', 1, 'Racing / Driving,Simulation,Sports', 'PlayStation 3', 2007),
('TMNT', 1, 'Action', 'Nintendo Wii', 2007),
('Soldier of Fortune: Payback', 1, 'Action', 'X360', 2007),
('Dynasty Warriors: Gundam', 2, 'Action', 'PlayStation 3', 2007),
('Disney Pirates of the Caribbean: At World\'s End', 2, 'Action', 'PlayStation 3', 2007),
('Bee Movie Game', 2, 'Action', 'X360', 2007),
('Dynasty Warriors: Gundam', 2, 'Action', 'X360', 2007),
('Golden Axe', 2, 'Action', 'X360', 2007),
('Dementium: The Ward', 1, 'Action', 'Nintendo DS', 2007),
('Rondo of Swords', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2007),
('Disgaea: Afternoon of Darkness', 1, 'Role-Playing (RPG),Strategy', 'Sony PSP', 2007),
('NASCAR 08', 1, 'Racing / Driving,Sports', 'PlayStation 3', 2007),
('Dragon Quest Swords: The Masked Queen and the T...', 1, 'Action', 'Nintendo Wii', 2007),
('Call of Juarez', 1, 'Action', 'X360', 2007),
('College Hoops 2K8', 1, 'Sports', 'X360', 2007),
('Eternal Sonata', 1, 'Role-Playing (RPG)', 'X360', 2007),
('Kingdom Under Fire: Circle of Doom', 1, 'Action,Role-Playing (RPG)', 'X360', 2007),
('Vampire Rain', 1, 'Action', 'X360', 2007),
('All-Pro Football 2K8', 6, 'Sports', 'PlayStation 3', 2007),
('Mercury Meltdown', 2, 'Strategy', 'Nintendo Wii', 2007),
('Conan', 1, 'Action,Adventure', 'PlayStation 3', 2007),
('Godzilla: Unleashed', 1, 'Action', 'Nintendo Wii', 2007),
('NBA Live 08', 1, 'Sports', 'Nintendo Wii', 2007),
('Conan', 1, 'Action,Adventure', 'X360', 2007),
('Spider-Man: Friend or Foe', 2, 'Action', 'Nintendo Wii', 2007),
('College Hoops 2K8', 7, 'Sports', 'PlayStation 3', 2007),
('NBA 08', 4, 'Sports', 'PlayStation 3', 2007),
('Thrillville: Off the Rails', 4, 'Simulation,Strategy', 'X360', 2007),
('Geometry Wars: Galaxies', 1, 'Action', 'Nintendo DS', 2007),
('Rayman Raving Rabbids', 1, 'Action', 'Nintendo DS', 2007),
('WordJong', 1, 'Strategy', 'Nintendo DS', 2007),
('Warhammer 40,000: Squad Command', 1, 'Strategy', 'Sony PSP', 2007),
('Beowulf: The Game', 1, 'Action', 'PlayStation 3', 2007),
('The Golden Compass', 1, 'Action', 'PlayStation 3', 2007),
('Scarface: The World is Yours', 1, 'Action,Racing / Driving', 'Nintendo Wii', 2007),
('Hot Wheels: Beat That!', 1, 'Action,Racing / Driving', 'X360', 2007),
('NHL 2K8 ', 1, 'Sports', 'X360', 2007),
('NBA Street Homecourt', 4, 'Sports', 'PlayStation 3', 2007),
('Geometry Wars: Galaxies', 2, 'Action', 'Nintendo Wii', 2007),
('Final Fantasy: Crystal Chronicles - Echoes of Time', 1, 'Action', 'Nintendo DS', 2007),
('Godzilla Unleashed: Double Smash', 1, 'Action', 'Nintendo DS', 2007),
('MX vs. ATV Untamed', 1, 'Racing / Driving', 'Nintendo DS', 2007),
('WWE SmackDown vs. Raw 2008', 1, 'Sports', 'Nintendo DS', 2007),
('The BIGS', 1, 'Action,Simulation,Sports', 'Sony PSP', 2007),
('Brave Story: New Traveler', 1, 'Role-Playing (RPG)', 'Sony PSP', 2007),
('WipEout Pulse', 1, 'Action,Racing / Driving', 'Sony PSP', 2007),
('TimeShift', 1, 'Action', 'PlayStation 3', 2007),
('Star Trek: Conquest', 1, 'Action,Strategy', 'Nintendo Wii', 2007),
('Beautiful Katamari', 1, 'Action', 'X360', 2007),
('Hour of Victory', 1, 'Action', 'X360', 2007),
('Fantastic Four: Rise of the Silver Surfer', 4, 'Action', 'PlayStation 3', 2007),
('SEGA Rally Revo', 2, 'Racing / Driving,Simulation', 'X360', 2007),
('7 Wonders of the Ancient World', 1, 'Strategy', 'Nintendo DS', 2007),
('Draglade', 1, 'Action', 'Nintendo DS', 2007),
('Final Fantasy Fables: Chocobo Tales', 1, 'Action', 'Nintendo DS', 2007),
('Marvel Trading Card Game', 1, 'Strategy', 'Nintendo DS', 2007),
('Crazy Taxi: Fare Wars', 1, 'Action,Racing / Driving', 'Sony PSP', 2007),
('The Golden Compass', 1, 'Action', 'Sony PSP', 2007),
('Harry Potter and the Order of the Phoenix', 1, 'Action', 'Sony PSP', 2007),
('Bladestorm: The Hundred Years\' War', 1, 'Action,Role-Playing (RPG),Strategy', 'PlayStation 3', 2007),
('Surf\'s Up', 4, 'Sports', 'X360', 2007),
('Blazing Angels 2: Secret Missions of WWII', 2, 'Action', 'X360', 2007),
('InuYasha: Secret of the Divine Jewel', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('The Settlers', 1, 'Strategy', 'Nintendo DS', 2007),
('Shrek the Third', 1, 'Action', 'Sony PSP', 2007),
('Ratatouille', 1, 'Action', 'PlayStation 3', 2007),
('Soldier of Fortune: Payback', 1, 'Action', 'PlayStation 3', 2007),
('Heatseeker', 1, 'Action', 'Nintendo Wii', 2007),
('NHL 2K8', 7, 'Sports', 'PlayStation 3', 2007),
('NCAA March Madness 08', 4, 'Sports', 'PlayStation 3', 2007),
('Fantastic Four: Rise of the Silver Surfer', 4, 'Action', 'X360', 2007),
('Monster Madness: Battle for Suburbia', 4, 'Action', 'X360', 2007),
('Pro Evolution Soccer 2008', 4, 'Sports', 'X360', 2007),
('Blazing Angels 2: Secret Missions of WWII', 2, 'Action', 'PlayStation 3', 2007),
('Cake Mania', 1, 'Action', 'Nintendo DS', 2007),
('River King: Mystic Valley', 1, 'Adventure,Simulation,Sports', 'Nintendo DS', 2007),
('Touch Detective 2 1/2', 1, 'Adventure', 'Nintendo DS', 2007),
('7 Wonders of the Ancient World', 1, 'Strategy', 'Sony PSP', 2007),
('Brooktown High', 1, 'Simulation', 'Sony PSP', 2007),
('Crush', 1, 'Action', 'Sony PSP', 2007),
('Jackass: The Game', 1, 'Action', 'Sony PSP', 2007),
('The Sims 2: Castaway', 1, 'Simulation', 'Sony PSP', 2007),
('Test Drive Unlimited', 1, 'Racing / Driving', 'Sony PSP', 2007),
('Thrillville: Off the Rails', 1, 'Simulation,Strategy', 'Sony PSP', 2007),
('Victorious Boxers: Revolution', 1, 'Action,Simulation,Sports', 'Nintendo Wii', 2007),
('Bladestorm: The Hundred Years\' War', 1, 'Action,Role-Playing (RPG),Strategy', 'X360', 2007),
('Looney Tunes: Acme Arsenal', 4, 'Action', 'X360', 2007),
('SEGA Rally Revo', 2, 'Racing / Driving,Simulation', 'PlayStation 3', 2007),
('Death Jr. and the Science Fair of Doom', 1, 'Action', 'Nintendo DS', 2007),
('Indianapolis 500 Legends', 1, 'Racing / Driving', 'Nintendo DS', 2007),
('Worms: Open Warfare 2', 1, 'Action,Strategy', 'Nintendo DS', 2007),
('Alien Syndrome', 1, 'Action', 'Sony PSP', 2007),
('BlackSite: Area 51', 1, 'Action', 'PlayStation 3', 2007),
('Code Lyoko: Quest for Infinity', 1, 'Action', 'Nintendo Wii', 2007),
('Super Swing Golf Season 2', 1, 'Sports', 'Nintendo Wii', 2007),
('FlatOut: Ultimate Carnage', 1, 'Racing / Driving', 'X360', 2007),
('Zoids Assault', 1, 'Role-Playing (RPG),Strategy', 'X360', 2007),
('Alien Syndrome', 4, 'Action', 'Nintendo Wii', 2007),
('Tetris Evolution', 4, 'Strategy', 'X360', 2007),
('Heroes of Mana', 1, 'Strategy', 'Nintendo DS', 2007),
('Myst', 1, 'Adventure', 'Nintendo DS', 2007),
('Coded Arms: Contagion', 1, 'Action', 'Sony PSP', 2007),
('King of Clubs', 1, 'Sports', 'Nintendo Wii', 2007),
('F.E.A.R. Files', 1, 'Action', 'X360', 2007),
('Ontamarama', 1, 'Action', 'Nintendo DS', 2007),
('Retro Game Challenge', 1, 'Action,Racing / Driving,Role-Playing (RPG)', 'Nintendo DS', 2007),
('Ultimate Mortal Kombat 3', 1, 'Action', 'Nintendo DS', 2007),
('Warhammer 40,000: Squad Command', 1, 'Strategy', 'Nintendo DS', 2007),
('Juiced 2: Hot Import Nights', 1, 'Racing / Driving', 'Sony PSP', 2007),
('Pursuit Force: Extreme Justice', 1, 'Action,Racing / Driving', 'Sony PSP', 2007),
('Medal of Honor: Vanguard', 1, 'Action', 'Nintendo Wii', 2007),
('World Series of Poker 2008: Battle for the Brac...', 1, 'Simulation', 'X360', 2007),
('Pro Evolution Soccer 2008', 7, 'Sports', 'PlayStation 3', 2007),
('Worms: Open Warfare 2', 4, 'Action,Strategy', 'Sony PSP', 2007),
('Surf\'s Up', 4, 'Sports', 'PlayStation 3', 2007),
('Fantastic Four: Rise of the Silver Surfer', 4, 'Action', 'Nintendo Wii', 2007),
('Brothers in Arms DS', 1, 'Action', 'Nintendo DS', 2007),
('Bubble Bobble Double Shot', 1, 'Action', 'Nintendo DS', 2007),
('Fantastic Four: Rise of the Silver Surfer', 1, 'Action', 'Nintendo DS', 2007),
('Zendoku', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2007),
('Heatseeker', 1, 'Action', 'Sony PSP', 2007),
('Manhunt 2', 1, 'Action', 'Sony PSP', 2007);
INSERT INTO `video_games` (`Title`, `MaxPlayers`, `Genres`, `Release Console`, `ReleaseYear`) VALUES
('SWAT: Target Liberty', 1, 'Action,Strategy', 'Sony PSP', 2007),
('Anubis II', 1, 'Action', 'Nintendo Wii', 2007),
('Barnyard', 1, 'Action,Adventure', 'Nintendo Wii', 2007),
('Escape from Bug Island', 1, 'Action', 'Nintendo Wii', 2007),
('Octomania', 1, 'Action,Strategy', 'Nintendo Wii', 2007),
('Cabela\'s Big Game Hunter', 1, 'Simulation,Sports', 'X360', 2007),
('UEFA Champions League 2006-2007', 4, 'Sports', 'X360', 2007),
('Aliens Vs Predator: Requiem', 2, 'Action', 'Sony PSP', 2007),
('NBA 08', 2, 'Sports', 'Sony PSP', 2007),
('Guilty Gear XX ? Core', 2, 'Action', 'Nintendo Wii', 2007),
('Arkanoid DS', 1, 'Strategy', 'Nintendo DS', 2007),
('Code Lyoko', 1, 'Action,Adventure', 'Nintendo DS', 2007),
('Dynasty Warriors DS: Fighter\'s Battle', 1, 'Action,Strategy', 'Nintendo DS', 2007),
('Orcs & Elves', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2007),
('Prism: Light the Way', 1, 'Action,Strategy', 'Nintendo DS', 2007),
('Dead Head Fred', 1, 'Action', 'Sony PSP', 2007),
('Hot Pixel', 1, 'Action', 'Sony PSP', 2007),
('The Legend of Heroes III: Song of the Ocean', 1, 'Role-Playing (RPG)', 'Sony PSP', 2007),
('SEGA Rally Revo', 1, 'Racing / Driving,Simulation', 'Sony PSP', 2007),
('Bionicle Heroes', 1, 'Action', 'Nintendo Wii', 2007),
('Burnout Dominator', 4, 'Action,Racing / Driving', 'Sony PSP', 2007),
('Samurai Warriors 2: Empires', 2, 'Action,Role-Playing (RPG),Strategy', 'X360', 2007),
('Meteos: Disney Magic', 1, 'Strategy', 'Nintendo DS', 2007),
('Turn It Around', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2007),
('Cube', 1, 'Strategy', 'Sony PSP', 2007),
('Dragoneer\'s Aria', 1, 'Role-Playing (RPG)', 'Sony PSP', 2007),
('The Fast and the Furious', 1, 'Racing / Driving', 'Sony PSP', 2007),
('R-Type Command', 1, 'Strategy', 'Sony PSP', 2007),
('Virtua Tennis 3', 1, 'Sports', 'Sony PSP', 2007),
('Virtua Tennis 3', 4, 'Sports', 'X360', 2007),
('Front Mission', 1, 'Strategy', 'Nintendo DS', 2007),
('Lost in Blue 2', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2007),
('Nervous Brickdown', 1, 'Action', 'Nintendo DS', 2007),
('Sea Monsters: A Prehistoric Adventure', 1, 'Action,Educational', 'Nintendo DS', 2007),
('After Burner: Black Falcon', 1, 'Action', 'Sony PSP', 2007),
('Capcom Puzzle World', 1, 'Strategy', 'Sony PSP', 2007),
('Puzzle Quest: Challenge of the Warlords', 1, 'Role-Playing (RPG),Strategy', 'Sony PSP', 2007),
('Smash Court Tennis 3', 1, 'Sports', 'Sony PSP', 2007),
('UEFA Champions League 2006-2007', 1, 'Sports', 'Sony PSP', 2007),
('Driver: Parallel Lines', 1, 'Action,Racing / Driving', 'Nintendo Wii', 2007),
('Mario Kart Wii', 4, 'Racing / Driving', 'Nintendo Wii', 2008),
('Grand Theft Auto IV', 1, 'Action,Racing / Driving', 'X360', 2008),
('Super Smash Bros.: Brawl', 6, 'Action', 'Nintendo Wii', 2008),
('Call of Duty: World at War', 4, 'Action', 'X360', 2008),
('Grand Theft Auto IV', 1, 'Action,Racing / Driving', 'PlayStation 3', 2008),
('Gears of War 2', 2, 'Action', 'X360', 2008),
('Pokmon: Platinum Version', 1, 'Adventure,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Metal Gear Solid 4: Guns of the Patriots', 1, 'Action', 'PlayStation 3', 2008),
('Fable II', 1, 'Role-Playing (RPG)', 'X360', 2008),
('Call of Duty: World at War', 4, 'Action', 'PlayStation 3', 2008),
('Guitar Hero: World Tour', 4, 'Action,Simulation', 'Nintendo Wii', 2008),
('LittleBigPlanet', 4, 'Action', 'PlayStation 3', 2008),
('Fallout 3', 1, 'Action,Role-Playing (RPG)', 'X360', 2008),
('LEGO Indiana Jones: The Original Adventures', 2, 'Action', 'X360', 2008),
('Left 4 Dead', 2, 'Action', 'X360', 2008),
('Madden NFL 09', 4, 'Sports', 'X360', 2008),
('Guitar Hero: On Tour', 1, 'Action,Simulation', 'Nintendo DS', 2008),
('Kung Fu Panda', 4, 'Action', 'X360', 2008),
('Rock Band 2', 4, 'Action,Simulation', 'X360', 2008),
('Sega Superstars Tennis', 4, 'Sports', 'X360', 2008),
('Guitar Hero: World Tour', 4, 'Action,Simulation', 'X360', 2008),
('Animal Crossing: City Folk', 1, 'Simulation', 'Nintendo Wii', 2008),
('Mario & Sonic at the Olympic Games', 1, 'Action,Sports', 'Nintendo DS', 2008),
('Madden NFL 09', 4, 'Sports', 'PlayStation 3', 2008),
('LEGO Batman: The Videogame', 2, 'Action', 'X360', 2008),
('Tom Clancy\'s Rainbow Six: Vegas 2', 2, 'Action', 'X360', 2008),
('Kirby Super Star Ultra', 1, 'Action', 'Nintendo DS', 2008),
('Star Wars: The Force Unleashed', 1, 'Action', 'X360', 2008),
('God of War: Chains of Olympus', 1, 'Action', 'Sony PSP', 2008),
('Fallout 3', 1, 'Action,Role-Playing (RPG)', 'PlayStation 3', 2008),
('Pure', 1, 'Racing / Driving,Sports', 'X360', 2008),
('LEGO Indiana Jones: The Original Adventures', 2, 'Action', 'Nintendo Wii', 2008),
('Rock Band', 2, 'Action,Simulation', 'Nintendo Wii', 2008),
('LEGO Batman: The Videogame', 1, 'Action,Racing / Driving', 'Nintendo DS', 2008),
('Saints Row 2', 1, 'Action,Racing / Driving', 'X360', 2008),
('LEGO Batman: The Videogame', 2, 'Action', 'Nintendo Wii', 2008),
('Call of Duty: World at War', 2, 'Action', 'Nintendo Wii', 2008),
('Midnight Club: Los Angeles', 1, 'Racing / Driving', 'X360', 2008),
('Mortal Kombat vs. DC Universe', 2, 'Action', 'PlayStation 3', 2008),
('Army of Two', 2, 'Action', 'X360', 2008),
('Resistance 2', 2, 'Action', 'PlayStation 3', 2008),
('Rock Band 2', 1, 'Action,Simulation', 'PlayStation 3', 2008),
('Midnight Club: Los Angeles', 1, 'Racing / Driving', 'PlayStation 3', 2008),
('Sonic Unleashed', 1, 'Action', 'Nintendo Wii', 2008),
('NBA 2K9 ', 1, 'Sports', 'X360', 2008),
('Guitar Hero: World Tour', 4, 'Action,Simulation', 'PlayStation 3', 2008),
('Guitar Hero: Aerosmith', 1, 'Action,Simulation', 'Nintendo Wii', 2008),
('Star Wars: The Force Unleashed', 2, 'Action', 'Nintendo Wii', 2008),
('Burnout Paradise', 1, 'Action,Racing / Driving', 'PlayStation 3', 2008),
('Pokmon Ranger: Shadows of Almia', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Mortal Kombat vs. DC Universe', 2, 'Action', 'X360', 2008),
('Dead Space', 1, 'Action', 'PlayStation 3', 2008),
('Shaun White Snowboarding: Road Trip', 1, 'Sports', 'Nintendo Wii', 2008),
('Star Wars: The Force Unleashed', 1, 'Action', 'PlayStation 3', 2008),
('Guitar Hero: Aerosmith', 2, 'Action,Simulation', 'X360', 2008),
('SOCOM: U.S. Navy SEALs - Confrontation', 1, 'Action', 'PlayStation 3', 2008),
('SoulCalibur IV', 2, 'Action', 'X360', 2008),
('Battlefield: Bad Company', 1, 'Action', 'X360', 2008),
('Saints Row 2', 1, 'Action,Racing / Driving', 'PlayStation 3', 2008),
('Guitar Hero: On Tour - Decades', 1, 'Action,Simulation', 'Nintendo DS', 2008),
('Devil May Cry 4', 1, 'Action', 'X360', 2008),
('Mystery Case Files: MillionHeir', 1, 'Adventure', 'Nintendo DS', 2008),
('Battlefield: Bad Company', 1, 'Action', 'PlayStation 3', 2008),
('Army of Two', 2, 'Action', 'PlayStation 3', 2008),
('Rayman Raving Rabbids TV Party', 4, 'Action,Racing / Driving,Sports,Strategy', 'Nintendo Wii', 2008),
('The House of the Dead 2 & 3 Return', 2, 'Action', 'Nintendo Wii', 2008),
('Far Cry 2', 1, 'Action', 'X360', 2008),
('Boom Blox', 4, 'Action,Strategy', 'Nintendo Wii', 2008),
('Spore Creatures', 1, 'Adventure,Simulation', 'Nintendo DS', 2008),
('Madden NFL 09', 4, 'Sports', 'Sony PSP', 2008),
('NCAA Football 09', 4, 'Sports', 'X360', 2008),
('MLB 08: The Show', 2, 'Sports', 'PlayStation 3', 2008),
('Tom Clancy\'s Rainbow Six: Vegas 2', 2, 'Action', 'PlayStation 3', 2008),
('Mercenaries 2: World in Flames', 1, 'Action', 'X360', 2008),
('Need for Speed: Undercover', 1, 'Racing / Driving', 'X360', 2008),
('Guitar Hero: Aerosmith', 2, 'Action,Simulation', 'PlayStation 3', 2008),
('SoulCalibur IV', 2, 'Action', 'PlayStation 3', 2008),
('Valkyria Chronicles', 1, 'Action,Role-Playing (RPG),Strategy', 'PlayStation 3', 2008),
('Harvest Moon: Tree of Tranquility', 1, 'Role-Playing (RPG),Simulation', 'Nintendo Wii', 2008),
('Star Wars: The Clone Wars - Jedi Alliance', 1, 'Action,Adventure', 'Nintendo DS', 2008),
('Need for Speed: Undercover', 1, 'Racing / Driving', 'PlayStation 3', 2008),
('Wario Land: Shake It!', 1, 'Action', 'Nintendo Wii', 2008),
('NBA 2K9', 7, 'Sports', 'PlayStation 3', 2008),
('Major League Baseball 2K9', 1, 'Sports', 'X360', 2008),
('NCAA Football 09', 4, 'Sports', 'PlayStation 3', 2008),
('Kung Fu Panda', 1, 'Action', 'Nintendo DS', 2008),
('Devil May Cry 4', 1, 'Action', 'PlayStation 3', 2008),
('Tom Clancy\'s EndWar', 1, 'Strategy', 'X360', 2008),
('LEGO Batman: The Videogame', 1, 'Action', 'Sony PSP', 2008),
('BioShock', 1, 'Action', 'PlayStation 3', 2008),
('Bully: Scholarship Edition', 1, 'Action,Adventure', 'X360', 2008),
('Prince of Persia', 1, 'Action', 'X360', 2008),
('Kung Fu Panda', 4, 'Action', 'Nintendo Wii', 2008),
('Sonic Chronicles: The Dark Brotherhood', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Chrono Trigger', 2, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Tomb Raider: Underworld', 1, 'Action', 'X360', 2008),
('skate it', 4, 'Action,Sports', 'Nintendo Wii', 2008),
('The Legendary Starfy', 1, 'Action,Adventure', 'Nintendo DS', 2008),
('Mirror\'s Edge', 1, 'Action', 'X360', 2008),
('Haze', 2, 'Action', 'PlayStation 3', 2008),
('Dissidia: Final Fantasy', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2008),
('Sid Meier\'s Civilization: Revolution', 1, 'Strategy', 'X360', 2008),
('Wall-E', 4, 'Action', 'Nintendo Wii', 2008),
('Prince of Persia', 1, 'Action', 'PlayStation 3', 2008),
('NHL 09 ', 1, 'Sports', 'X360', 2008),
('Brothers in Arms: Hell\'s Highway', 1, 'Action', 'X360', 2008),
('Shaun White Snowboarding', 1, 'Sports', 'X360', 2008),
('Turok', 1, 'Action', 'X360', 2008),
('Iron Man', 1, 'Action', 'Sony PSP', 2008),
('De Blob', 4, 'Action', 'Nintendo Wii', 2008),
('Sonic Riders: Zero Gravity', 4, 'Racing / Driving', 'Nintendo Wii', 2008),
('Rhythm Heaven', 1, 'Action', 'Nintendo DS', 2008),
('Tomb Raider: Underworld', 1, 'Action', 'PlayStation 3', 2008),
('Advance Wars: Days of Ruin', 4, 'Strategy', 'Nintendo DS', 2008),
('LEGO Batman: The Videogame', 2, 'Action', 'PlayStation 3', 2008),
('Far Cry 2', 1, 'Action', 'PlayStation 3', 2008),
('Harvest Moon: Island of Happiness', 1, 'Simulation,Strategy', 'Nintendo DS', 2008),
('Brothers in Arms: Hell\'s Highway', 1, 'Action', 'PlayStation 3', 2008),
('Sonic Unleashed', 1, 'Action,Adventure', 'PlayStation 3', 2008),
('Pinball Hall of Fame: The Williams Collection', 1, 'Simulation', 'Nintendo Wii', 2008),
('Sonic Unleashed', 1, 'Action,Adventure', 'X360', 2008),
('Samba de Amigo', 2, 'Action', 'Nintendo Wii', 2008),
('?kami', 1, 'Action', 'Nintendo Wii', 2008),
('LEGO Indiana Jones: The Original Adventures', 2, 'Action', 'PlayStation 3', 2008),
('MotorStorm: Pacific Rift', 4, 'Action,Racing / Driving,Sports', 'PlayStation 3', 2008),
('Tiger Woods PGA Tour 09', 4, 'Sports', 'X360', 2008),
('SimCity Creator', 1, 'Simulation', 'Nintendo Wii', 2008),
('Tiger Woods PGA Tour 09', 4, 'Sports', 'PlayStation 3', 2008),
('Sid Meier\'s Civilization: Revolution', 1, 'Simulation,Strategy', 'Nintendo DS', 2008),
('Pure', 1, 'Racing / Driving,Sports', 'PlayStation 3', 2008),
('Turok', 1, 'Action', 'PlayStation 3', 2008),
('Crash: Mind over Mutant', 1, 'Action', 'Nintendo Wii', 2008),
('Spider-Man: Web of Shadows', 1, 'Action', 'X360', 2008),
('Frontlines: Fuel of War', 1, 'Action', 'X360', 2008),
('GRID', 1, 'Racing / Driving,Simulation,Sports', 'X360', 2008),
('Too Human', 1, 'Action,Role-Playing (RPG)', 'X360', 2008),
('Speed Racer: The Videogame', 2, 'Racing / Driving', 'Nintendo Wii', 2008),
('LEGO Indiana Jones: The Original Adventures', 1, 'Action', 'Sony PSP', 2008),
('SEGA Bass Fishing', 1, 'Sports', 'Nintendo Wii', 2008),
('The Chronicles of Narnia: Prince Caspian', 2, 'Action,Role-Playing (RPG)', 'Nintendo Wii', 2008),
('Iron Man', 1, 'Action', 'Nintendo DS', 2008),
('The Sims 2: Apartment Pets', 1, 'Simulation', 'Nintendo DS', 2008),
('MLB 08: The Show', 1, 'Sports', 'Sony PSP', 2008),
('Iron Man', 1, 'Action', 'PlayStation 3', 2008),
('Madagascar: Escape 2 Africa', 1, 'Action,Adventure', 'Nintendo DS', 2008),
('GRID', 1, 'Racing / Driving,Simulation,Sports', 'PlayStation 3', 2008),
('NHL 09', 1, 'Sports', 'PlayStation 3', 2008),
('Banjo-Kazooie: Nuts & Bolts', 1, 'Action,Adventure,Racing / Driving,Sports', 'X360', 2008),
('Hot Shots Golf: Out of Bounds', 4, 'Sports', 'PlayStation 3', 2008),
('Rune Factory 2: A Fantasy Harvest Moon', 1, 'Action,Role-Playing (RPG),Simulation', 'Nintendo DS', 2008),
('SimCity Creator', 1, 'Simulation', 'Nintendo DS', 2008),
('Patapon', 1, 'Action,Strategy', 'Sony PSP', 2008),
('Shaun White Snowboarding', 1, 'Sports', 'PlayStation 3', 2008),
('Iron Man', 1, 'Action', 'Nintendo Wii', 2008),
('Sega Superstars Tennis', 1, 'Sports', 'Nintendo DS', 2008),
('Lost Planet: Extreme Condition', 1, 'Action', 'PlayStation 3', 2008),
('Mirror\'s Edge', 1, 'Action', 'PlayStation 3', 2008),
('The Incredible Hulk', 1, 'Action', 'Nintendo Wii', 2008),
('Condemned 2: Bloodshot', 1, 'Action,Adventure', 'X360', 2008),
('Sega Superstars Tennis', 4, 'Sports', 'Nintendo Wii', 2008),
('Speed Racer: The Videogame', 1, 'Racing / Driving', 'Nintendo DS', 2008),
('Viva Pi$?ata: Pocket Paradise', 1, 'Simulation,Strategy', 'Nintendo DS', 2008),
('Tom Clancy\'s EndWar', 1, 'Strategy', 'PlayStation 3', 2008),
('Iron Man', 1, 'Action', 'X360', 2008),
('Need for Speed: Undercover', 4, 'Racing / Driving', 'Nintendo Wii', 2008),
('Wall-E', 4, 'Action', 'X360', 2008),
('Spectrobes: Beyond the Portals', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('MX vs. ATV Untamed', 1, 'Educational', 'Sony PSP', 2008),
('Mercenaries 2: World in Flames', 1, 'Action', 'PlayStation 3', 2008),
('Infinite Undiscovery', 1, 'Action,Role-Playing (RPG)', 'X360', 2008),
('TNA iMPACT!', 4, 'Sports', 'X360', 2008),
('Enemy Territory: Quake Wars', 1, 'Action', 'X360', 2008),
('Fire Emblem: Shadow Dragon', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2008),
('Neopets Puzzle Adventure', 1, 'Adventure,Role-Playing (RPG),Strategy', 'Nintendo DS', 2008),
('Tales of Vesperia', 1, 'Adventure,Role-Playing (RPG)', 'X360', 2008),
('SingStar ABBA', 8, 'Action', 'PlayStation 3', 2008),
('Dragon Ball Z: Burst Limit', 2, 'Action', 'X360', 2008),
('Apollo Justice: Ace Attorney', 1, 'Adventure,Simulation', 'Nintendo DS', 2008),
('Castlevania: Order of Ecclesia', 1, 'Action,Adventure,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Mega Man Star Force 2: Zerker X Ninja', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Enemy Territory: Quake Wars', 1, 'Action', 'PlayStation 3', 2008),
('Namco Museum: Virtual Arcade', 1, 'Action,Racing / Driving', 'X360', 2008),
('NASCAR 09', 1, 'Racing / Driving,Sports', 'X360', 2008),
('Turning Point: Fall of Liberty', 1, 'Action', 'X360', 2008),
('Summer Athletics 2009', 4, 'Sports', 'Nintendo Wii', 2008),
('Unreal Tournament III', 2, 'Action', 'X360', 2008),
('Shaun White Snowboarding', 1, 'Racing / Driving,Sports', 'Nintendo DS', 2008),
('Dark Sector', 1, 'Action', 'PlayStation 3', 2008),
('The Last Remnant', 1, 'Role-Playing (RPG)', 'X360', 2008),
('Dragon Ball Z: Burst Limit', 2, 'Action', 'PlayStation 3', 2008),
('NASCAR 09', 1, 'Racing / Driving,Sports', 'PlayStation 3', 2008),
('Turning Point: Fall of Liberty', 1, 'Action', 'PlayStation 3', 2008),
('MX vs. ATV Untamed', 1, 'Racing / Driving', 'Nintendo Wii', 2008),
('Crash: Mind over Mutant', 1, 'Action', 'X360', 2008),
('The Incredible Hulk', 1, 'Action', 'X360', 2008),
('Silent Hill: Homecoming', 1, 'Action', 'X360', 2008),
('TNA iMPACT!', 4, 'Sports', 'PlayStation 3', 2008),
('The Incredible Hulk', 1, 'Action', 'PlayStation 3', 2008),
('Kung Fu Panda', 1, 'Action', 'PlayStation 3', 2008),
('Dark Sector', 1, 'Action', 'X360', 2008),
('Tales of Symphonia: Dawn of the New World', 4, 'Role-Playing (RPG)', 'Nintendo Wii', 2008),
('Valkyrie Profile: Covenant of the Plume', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2008),
('Spider-Man: Web of Shadows', 1, 'Action', 'PlayStation 3', 2008),
('TV Show King', 4, 'Strategy', 'Nintendo Wii', 2008),
('AC/DC Live: Rock Band - Track Pack', 4, 'Action,Simulation', 'X360', 2008),
('The Chronicles of Narnia: Prince Caspian', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Hot Shots Golf: Open Tee 2', 1, 'Sports', 'Sony PSP', 2008),
('AC/DC Live: Rock Band - Track Pack', 1, 'Action,Simulation', 'PlayStation 3', 2008),
('Harvest Moon: Magical Melody', 4, 'Role-Playing (RPG),Simulation', 'Nintendo Wii', 2008),
('Dynasty Warriors 6', 2, 'Action,Strategy', 'PlayStation 3', 2008),
('Order Up!', 1, 'Action,Simulation', 'Nintendo Wii', 2008),
('NBA Ballers: Chosen One', 4, 'Sports', 'X360', 2008),
('Age of Empires: Mythologies', 1, 'Strategy', 'Nintendo DS', 2008),
('LocoRoco 2', 1, 'Action,Strategy', 'Sony PSP', 2008),
('Star Ocean: First Departure', 1, 'Action,Role-Playing (RPG)', 'Sony PSP', 2008),
('Lost: Via Domus', 1, 'Action,Adventure', 'PlayStation 3', 2008),
('Tetris Party', 4, 'Strategy', 'Nintendo Wii', 2008),
('Bully: Scholarship Edition', 2, 'Action,Adventure', 'Nintendo Wii', 2008),
('The Spiderwick Chronicles', 2, 'Action,Adventure', 'Nintendo Wii', 2008),
('Dynasty Warriors 6', 2, 'Action,Strategy', 'X360', 2008),
('Facebreaker', 2, 'Sports', 'X360', 2008),
('Ninja Gaiden: Dragon Sword', 1, 'Action', 'Nintendo DS', 2008),
('Condemned 2: Bloodshot', 1, 'Action,Adventure', 'PlayStation 3', 2008),
('Silent Hill: Homecoming', 1, 'Action', 'PlayStation 3', 2008),
('Command & Conquer: Red Alert 3', 1, 'Strategy', 'X360', 2008),
('Viking: Battle for Asgard', 1, 'Action', 'X360', 2008),
('Beijing 2008', 4, 'Sports', 'X360', 2008),
('Don King Presents: Prizefighter', 2, 'Sports', 'X360', 2008),
('Bomberman', 1, 'Action,Strategy', 'Sony PSP', 2008),
('Ferrari Challenge Trofeo Pirelli', 1, 'Racing / Driving', 'PlayStation 3', 2008),
('Command & Conquer 3: Kane\'s Wrath', 1, 'Strategy', 'X360', 2008),
('Lost: Via Domus', 1, 'Action,Adventure', 'X360', 2008),
('NHL 2K9 ', 1, 'Sports', 'X360', 2008),
('Eternal Sonata', 2, 'Role-Playing (RPG)', 'PlayStation 3', 2008),
('Viva Pi$?ata: Trouble in Paradise', 2, 'Racing / Driving,Simulation,Strategy', 'X360', 2008),
('FlatOut: Head On', 1, 'Racing / Driving,Sports', 'Sony PSP', 2008),
('Viking: Battle for Asgard', 1, 'Action', 'PlayStation 3', 2008),
('Neopets Puzzle Adventure', 1, 'Role-Playing (RPG),Strategy', 'Nintendo Wii', 2008),
('TNA iMPACT!', 1, 'Sports', 'Nintendo Wii', 2008),
('Tomb Raider: Underworld', 1, 'Action', 'Nintendo Wii', 2008),
('The Club', 4, 'Action', 'X360', 2008),
('The Chronicles of Narnia: Prince Caspian', 2, 'Action,Role-Playing (RPG)', 'X360', 2008),
('Cabela\'s Dangerous Hunts 2009', 1, 'Sports', 'X360', 2008),
('Dark Messiah of Might and Magic: Elements', 1, 'Action,Role-Playing (RPG)', 'X360', 2008),
('Fracture', 1, 'Action', 'X360', 2008),
('Bomberman Land', 4, 'Action', 'Nintendo Wii', 2008),
('Nitrobike', 4, 'Action,Racing / Driving,Sports', 'Nintendo Wii', 2008),
('Culdcept Saga', 4, 'Strategy', 'X360', 2008),
('Facebreaker', 2, 'Sports', 'PlayStation 3', 2008),
('MLB Power Pros 2008', 2, 'Sports', 'Nintendo Wii', 2008),
('Mushroom Men: The Spore Wars', 2, 'Action', 'Nintendo Wii', 2008),
('Dragon Quest V: Hand of the Heavenly Bride', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Ninjatown', 1, 'Strategy', 'Nintendo DS', 2008),
('Super Dodgeball Brawlers', 1, 'Action,Sports', 'Nintendo DS', 2008),
('Dokapon Kingdom', 1, 'Role-Playing (RPG),Strategy', 'Nintendo Wii', 2008),
('Alone in the Dark', 1, 'Action,Adventure,Racing / Driving', 'X360', 2008),
('NBA 09: The Inside', 4, 'Sports', 'PlayStation 3', 2008),
('Sega Superstars Tennis', 4, 'Sports', 'PlayStation 3', 2008),
('Baja: Edge of Control', 4, 'Racing / Driving,Simulation,Sports', 'X360', 2008),
('Destroy All Humans! Big Willy Unleashed', 2, 'Adventure', 'Nintendo Wii', 2008),
('Space Invaders Extreme', 1, 'Action', 'Nintendo DS', 2008),
('Ultimate Band', 1, 'Action,Simulation', 'Nintendo DS', 2008),
('The Club', 4, 'Action', 'PlayStation 3', 2008),
('Madagascar: Escape 2 Africa', 4, 'Action', 'PlayStation 3', 2008),
('NBA Ballers: Chosen One', 4, 'Sports', 'PlayStation 3', 2008),
('Dream Pinball 3D', 4, 'Simulation', 'Nintendo Wii', 2008),
('Madagascar: Escape 2 Africa', 4, 'Action', 'X360', 2008),
('Pro Evolution Soccer 2008', 2, 'Sports', 'Nintendo Wii', 2008),
('Avalon Code', 1, 'Action,Adventure,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Disgaea DS', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2008),
('Guitar Rock Tour', 1, 'Simulation', 'Nintendo DS', 2008),
('Lost in Blue 3', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Syberia', 1, 'Adventure', 'Nintendo DS', 2008),
('Afrika', 1, 'Adventure,Simulation', 'PlayStation 3', 2008),
('NFL Head Coach 09', 1, 'Simulation,Sports,Strategy', 'PlayStation 3', 2008),
('NHL 2K9', 1, 'Sports', 'PlayStation 3', 2008),
('Brothers in Arms: Double Time', 1, 'Action,Strategy', 'Nintendo Wii', 2008),
('ObsCure: The Aftermath', 1, 'Action', 'Nintendo Wii', 2008),
('MotoGP 08', 1, 'Racing / Driving,Simulation,Sports', 'X360', 2008),
('NFL Head Coach 09', 1, 'Simulation,Sports,Strategy', 'X360', 2008),
('NFL Tour', 1, 'Action,Sports', 'X360', 2008),
('Pinball Hall of Fame: The Williams Collection', 4, 'Simulation', 'Sony PSP', 2008),
('Baja: Edge of Control', 4, 'Racing / Driving,Simulation,Sports', 'PlayStation 3', 2008),
('NFL Tour', 4, 'Action,Sports', 'PlayStation 3', 2008),
('Wall-E', 4, 'Action', 'PlayStation 3', 2008),
('Ninja Reflex', 4, 'Action', 'Nintendo Wii', 2008),
('Conflict: Denied Ops', 4, 'Action', 'X360', 2008),
('Top Spin 3', 4, 'Sports', 'X360', 2008),
('Blitz: The League II', 2, 'Action,Sports', 'PlayStation 3', 2008),
('Hellboy: The Science of Evil', 2, 'Action,Adventure', 'PlayStation 3', 2008),
('Castlevania Judgment', 2, 'Action', 'Nintendo Wii', 2008),
('Death Jr. II: Root of Evil', 2, 'Action', 'Nintendo Wii', 2008),
('Raiden IV', 2, 'Action', 'X360', 2008),
('Metal Slug 7', 1, 'Action', 'Nintendo DS', 2008),
('Spider-Man: Web of Shadows', 1, 'Action', 'Nintendo DS', 2008),
('Trauma Center: Under The Knife 2', 1, 'Action,Simulation', 'Nintendo DS', 2008),
('Fracture', 1, 'Action', 'PlayStation 3', 2008),
('Alone in the Dark', 1, 'Action,Adventure,Racing / Driving', 'Nintendo Wii', 2008),
('Final Fantasy Fables: Chocobo\'s Dungeon', 1, 'Action,Role-Playing (RPG)', 'Nintendo Wii', 2008),
('The King of Fighters Collection: The Orochi Saga', 1, 'Action', 'Nintendo Wii', 2008),
('Klonoa: Door to Phantomile', 1, 'Action', 'Nintendo Wii', 2008),
('Samurai Warriors: Katana', 1, 'Action', 'Nintendo Wii', 2008),
('Battle of the Bands', 2, 'Action,Simulation', 'Nintendo Wii', 2008),
('Hellboy: The Science of Evil', 2, 'Action,Adventure', 'X360', 2008),
('Dragon Ball: Origins', 1, 'Action,Adventure', 'Nintendo DS', 2008),
('Ninja Reflex', 1, 'Action', 'Nintendo DS', 2008),
('Space Bust-A-Move', 1, 'Strategy', 'Nintendo DS', 2008),
('Top Spin 3', 1, 'Sports', 'PlayStation 3', 2008),
('UEFA Euro 2008', 7, 'Sports', 'PlayStation 3', 2008),
('Blast Works: Build, Trade, Destroy', 4, 'Action', 'Nintendo Wii', 2008),
('FIFA Street 3', 4, 'Sports', 'X360', 2008),
('Blitz: The League II', 2, 'Action,Sports', 'X360', 2008),
('Space Chimps', 2, 'Action,Adventure', 'X360', 2008),
('The Spiderwick Chronicles', 2, 'Action,Adventure', 'X360', 2008),
('Etrian Odyssey II: Heroes of Lagaard', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Line Rider 2: Unbound', 1, 'Simulation,Sports', 'Nintendo DS', 2008),
('The King of Fighters Collection: The Orochi Saga', 1, 'Action', 'Sony PSP', 2008),
('Target: Terror', 1, 'Action', 'Nintendo Wii', 2008),
('Legendary', 1, 'Action', 'X360', 2008),
('Universe at War: Earth Assault', 1, 'Action,Strategy', 'X360', 2008),
('Smash Court Tennis 3', 4, 'Simulation,Sports', 'X360', 2008),
('Code Lyoko: Fall of X.A.N.A', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Knights in the Nightmare', 1, 'Role-Playing (RPG),Strategy', 'Nintendo DS', 2008),
('Lock\'s Quest', 1, 'Action,Adventure,Strategy', 'Nintendo DS', 2008),
('Master of the Monster Lair', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('N+', 1, 'Action', 'Nintendo DS', 2008),
('Pipe Mania', 1, 'Strategy', 'Nintendo DS', 2008),
('The Spiderwick Chronicles', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Summon Night: Twin Age', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Wild Arms XF', 1, 'Role-Playing (RPG)', 'Sony PSP', 2008),
('FIFA Street 3', 1, 'Sports', 'PlayStation 3', 2008),
('MotoGP 08', 1, 'Racing / Driving,Simulation,Sports', 'PlayStation 3', 2008),
('Harvey Birdman: Attorney at Law', 1, 'Adventure', 'Nintendo Wii', 2008),
('Let\'s Tap', 1, 'Simulation', 'Nintendo Wii', 2008),
('NHL 2K9', 1, 'Sports', 'Nintendo Wii', 2008),
('Conflict: Denied Ops', 4, 'Action', 'PlayStation 3', 2008),
('Worms: A Space Oddity', 4, 'Action,Strategy', 'Nintendo Wii', 2008),
('UEFA Euro 2008', 4, 'Sports', 'X360', 2008),
('Overlord: Raising Hell', 2, 'Action,Strategy', 'PlayStation 3', 2008),
('Battle Fantasia', 2, 'Action,Role-Playing (RPG)', 'X360', 2008),
('Bangai-O Spirits', 1, 'Action', 'Nintendo DS', 2008),
('Dungeon Explorer: Warriors of Ancient Arts', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('From the Abyss', 1, 'Action,Role-Playing (RPG)', 'Nintendo DS', 2008),
('New International Track & Field', 1, 'Action,Sports', 'Nintendo DS', 2008),
('Soul Bubbles', 1, 'Strategy', 'Nintendo DS', 2008),
('Tropix!', 1, 'Action', 'Nintendo DS', 2008),
('Unsolved Crimes', 1, 'Action,Adventure,Racing / Driving', 'Nintendo DS', 2008),
('Zubo', 1, 'Adventure,Role-Playing (RPG),Strategy', 'Nintendo DS', 2008),
('Ford Racing Off Road', 1, 'Racing / Driving', 'Sony PSP', 2008),
('Harvey Birdman: Attorney at Law', 1, 'Adventure', 'Sony PSP', 2008),
('Secret Agent Clank', 1, 'Action', 'Sony PSP', 2008),
('Space Invaders Extreme', 1, 'Action', 'Sony PSP', 2008),
('Armored Core: For Answer', 1, 'Action', 'PlayStation 3', 2008),
('Legendary', 1, 'Action', 'PlayStation 3', 2008),
('Agatha Christie: Evil Under the Sun', 1, 'Adventure', 'Nintendo Wii', 2008),
('Agatha Christie: And Then There Were None', 1, 'Adventure', 'Nintendo Wii', 2008),
('Armored Core: For Answer', 1, 'Action', 'X360', 2008),
('Cradle of Rome', 1, 'Strategy', 'Nintendo DS', 2008),
('The Dark Spire', 1, 'Adventure,Role-Playing (RPG)', 'Nintendo DS', 2008),
('Flower, Sun and Rain', 1, 'Adventure', 'Nintendo DS', 2008),
('Insecticide', 1, 'Action,Adventure', 'Nintendo DS', 2008),
('Izuna 2: The Unemployed Ninja Returns', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Looney Tunes: Cartoon Conductor', 1, 'Action', 'Nintendo DS', 2008),
('Nanostray 2', 1, 'Action', 'Nintendo DS', 2008),
('Hellboy: The Science of Evil', 1, 'Action', 'Sony PSP', 2008),
('Pipe Mania', 1, 'Strategy', 'Sony PSP', 2008),
('UEFA Euro 2008', 1, 'Sports', 'Sony PSP', 2008),
('Vampire Rain', 1, 'Action', 'PlayStation 3', 2008),
('Baroque', 1, 'Action,Role-Playing (RPG)', 'Nintendo Wii', 2008),
('Supreme Commander', 1, 'Strategy', 'X360', 2008),
('Hail to the Chimp', 4, 'Action,Strategy', 'X360', 2008),
('Assassin\'s Creed: Altar\'s Chronicles', 1, 'Action', 'Nintendo DS', 2008),
('The Legend of Kage 2', 1, 'Action', 'Nintendo DS', 2008),
('Rhapsody: A Musical Adventure', 1, 'Role-Playing (RPG)', 'Nintendo DS', 2008),
('Secret Files: Tunguska', 1, 'Adventure', 'Nintendo DS', 2008),
('Fading Shadows', 1, 'Action,Adventure', 'Sony PSP', 2008),
('Hail to the Chimp', 1, 'Action,Strategy', 'PlayStation 3', 2008),
('Secret Files: Tunguska', 2, 'Adventure', 'Nintendo Wii', 2008),
('Chicken Hunter', 1, 'Action', 'Nintendo DS', 2008);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `viewauthorbooks`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `viewauthorbooks` (
`SecondName` varchar(50)
,`FirstName` varchar(50)
,`ViewBookInfo` text
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `viewbookinfo`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `viewbookinfo` (
`BookId` int
,`SecondName` varchar(50)
,`FirstName` varchar(50)
,`Title` varchar(50)
,`Price` decimal(6,2) unsigned
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `viewbookinfowithfairy`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `viewbookinfowithfairy` (
`BookId` int
,`SecondName` varchar(50)
,`FirstName` varchar(50)
,`Title` varchar(50)
,`ContainsFairy` varchar(3)
,`price` decimal(6,2) unsigned
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `viewbookwithpricecategory`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `viewbookwithpricecategory` (
`BookId` int
,`SecondName` varchar(50)
,`FirstName` varchar(50)
,`Title` varchar(50)
,`PriceCategory` varchar(15)
,`Price` decimal(6,2) unsigned
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `viewcurrentyearorders`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `viewcurrentyearorders` (
`OrderId` int
,`OrderDatetime` varchar(45)
,`CustomerId` int
,`Login` varchar(20)
,`SecondName` varchar(50)
,`FirstName` varchar(50)
);

-- --------------------------------------------------------

--
-- Структура для представления `viewauthorbooks`
--
DROP TABLE IF EXISTS `viewauthorbooks`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `viewauthorbooks`  AS SELECT `authors`.`SecondName` AS `SecondName`, `authors`.`FirstName` AS `FirstName`, group_concat(distinct `books`.`Title` separator '; ') AS `ViewBookInfo` FROM (`authors` join `books` on((`books`.`AuthorId` = `authors`.`AuthorId`))) GROUP BY `authors`.`AuthorId` ;

-- --------------------------------------------------------

--
-- Структура для представления `viewbookinfo`
--
DROP TABLE IF EXISTS `viewbookinfo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `viewbookinfo`  AS SELECT `books`.`BookId` AS `BookId`, `authors`.`SecondName` AS `SecondName`, `authors`.`FirstName` AS `FirstName`, `books`.`Title` AS `Title`, `books`.`Price` AS `Price` FROM (`books` join `authors` on((`books`.`AuthorId` = `authors`.`AuthorId`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `viewbookinfowithfairy`
--
DROP TABLE IF EXISTS `viewbookinfowithfairy`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `viewbookinfowithfairy`  AS SELECT `viewbookinfo`.`BookId` AS `BookId`, `viewbookinfo`.`SecondName` AS `SecondName`, `viewbookinfo`.`FirstName` AS `FirstName`, `viewbookinfo`.`Title` AS `Title`, (case when (`viewbookinfo`.`Title` like '%Сказки%') then 'Да' else 'Нет' end) AS `ContainsFairy`, `viewbookinfo`.`Price` AS `price` FROM `viewbookinfo` ;

-- --------------------------------------------------------

--
-- Структура для представления `viewbookwithpricecategory`
--
DROP TABLE IF EXISTS `viewbookwithpricecategory`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `viewbookwithpricecategory`  AS SELECT `viewbookinfo`.`BookId` AS `BookId`, `viewbookinfo`.`SecondName` AS `SecondName`, `viewbookinfo`.`FirstName` AS `FirstName`, `viewbookinfo`.`Title` AS `Title`, (case when (`viewbookinfo`.`Price` < 1000) then 'до 1000' when ((`viewbookinfo`.`Price` >= 1000) and (`viewbookinfo`.`Price` <= 5000)) then 'от 1000 до 5000' else 'от 5000' end) AS `PriceCategory`, `viewbookinfo`.`Price` AS `Price` FROM `viewbookinfo` ;

-- --------------------------------------------------------

--
-- Структура для представления `viewcurrentyearorders`
--
DROP TABLE IF EXISTS `viewcurrentyearorders`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `viewcurrentyearorders`  AS SELECT `orders`.`OrderId` AS `OrderId`, `orders`.`OrderDatetime` AS `OrderDatetime`, `customers`.`CustomerId` AS `CustomerId`, `customers`.`Login` AS `Login`, `customers`.`SecondName` AS `SecondName`, `customers`.`FirstName` AS `FirstName` FROM (`orders` join `customers` on((`orders`.`CustomerId` = `customers`.`CustomerId`))) WHERE (year(`orders`.`OrderDatetime`) = year(curdate())) ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`AuthorId`),
  ADD UNIQUE KEY `NameSecondName_UNIQUE` (`SecondName`,`FirstName`);

--
-- Индексы таблицы `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`BookId`),
  ADD KEY `fk_Books_Authors1_idx` (`AuthorId`);

--
-- Индексы таблицы `booksinfo`
--
ALTER TABLE `booksinfo`
  ADD PRIMARY KEY (`BookId`),
  ADD UNIQUE KEY `Title` (`Title`,`SecondName`,`Name`);

--
-- Индексы таблицы `composition`
--
ALTER TABLE `composition`
  ADD PRIMARY KEY (`BookId`,`OrderId`),
  ADD KEY `fk_Books_has_Orders_Orders1_idx` (`OrderId`),
  ADD KEY `fk_Books_has_Orders_Books1_idx` (`BookId`);

--
-- Индексы таблицы `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerId`);

--
-- Индексы таблицы `deletedcustomers`
--
ALTER TABLE `deletedcustomers`
  ADD PRIMARY KEY (`CustomerId`);

--
-- Индексы таблицы `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`DeliveryId`),
  ADD KEY `fk_delivery_books1_idx` (`BookId`);

--
-- Индексы таблицы `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`idGame`);
ALTER TABLE `games` ADD FULLTEXT KEY `description` (`description`);
ALTER TABLE `games` ADD FULLTEXT KEY `name` (`name`,`description`);

--
-- Индексы таблицы `myeventtable`
--
ALTER TABLE `myeventtable`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderId`),
  ADD KEY `fk_Orders_Customers1_idx` (`CustomerId`);

--
-- Индексы таблицы `video_games`
--
ALTER TABLE `video_games` ADD FULLTEXT KEY `Genres` (`Genres`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `authors`
--
ALTER TABLE `authors`
  MODIFY `AuthorId` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `books`
--
ALTER TABLE `books`
  MODIFY `BookId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `booksinfo`
--
ALTER TABLE `booksinfo`
  MODIFY `BookId` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `delivery`
--
ALTER TABLE `delivery`
  MODIFY `DeliveryId` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `games`
--
ALTER TABLE `games`
  MODIFY `idGame` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `myeventtable`
--
ALTER TABLE `myeventtable`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `fk_Books_Authors1` FOREIGN KEY (`AuthorId`) REFERENCES `authors` (`AuthorId`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `composition`
--
ALTER TABLE `composition`
  ADD CONSTRAINT `fk_Books_has_Orders_Books1` FOREIGN KEY (`BookId`) REFERENCES `books` (`BookId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Books_has_Orders_Orders1` FOREIGN KEY (`OrderId`) REFERENCES `orders` (`OrderId`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `fk_delivery_books1` FOREIGN KEY (`BookId`) REFERENCES `books` (`BookId`);

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_Orders_Customers1` FOREIGN KEY (`CustomerId`) REFERENCES `customers` (`CustomerId`) ON UPDATE CASCADE;

DELIMITER $$
--
-- События
--
CREATE DEFINER=`root`@`127.0.0.1` EVENT `event1` ON SCHEDULE EVERY 10 SECOND STARTS '2025-04-12 10:40:00' ENDS '2025-04-12 10:45:00' ON COMPLETION PRESERVE DISABLE DO INSERT INTO myeventtable (eventTime, eventName)
VALUES(NOW(), "event1")$$

CREATE DEFINER=`root`@`127.0.0.1` EVENT `event2` ON SCHEDULE EVERY 150 SECOND STARTS '2025-04-12 10:40:00' ENDS '2025-04-13 10:40:00' ON COMPLETION PRESERVE ENABLE DO INSERT INTO myeventtable (eventTime, eventName)
VALUES(NOW(), "event2")$$

CREATE DEFINER=`root`@`127.0.0.1` EVENT `eventAuthor` ON SCHEDULE EVERY 1 DAY STARTS '2025-04-12 15:00:00' ON COMPLETION PRESERVE ENABLE DO BEGIN
	INSERT INTO myeventtable(eventTime, eventName)
    VALUES(NOW(), "eventAuthor");
    DELETE FROM authors
    WHERE AuthorId NOT IN (
        SELECT DISTINCT AuthorId FROM books 
    );
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
