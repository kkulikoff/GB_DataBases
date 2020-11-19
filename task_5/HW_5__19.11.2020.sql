DROP DATABASE IF EXISTS TASK5;
CREATE DATABASE IF NOT EXISTS TASK5;

USE TASK5;

-- RUN TASK 5-1
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

--  создаем таблицу users
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at DATETIME,
    updated_at DATETIME
    ) COMMENT = 'Покупатели';
    
 --  наполняем таблицу users   
INSERT INTO 
	users (name, birthday_at, created_at, updated_at)
VALUES
	('Антон','1989-12-24', NULL, NULL),
	('Яна','1990-03-07', NULL, NULL),
	('Ольга','1991-07-05', NULL, NULL),
	('Мария','1989-01-21', NULL, NULL),
	('Алексей','1993-02-06', NULL, NULL),
	('Тимофей','2019-01-12', NULL, NULL);
    
-- присваиваем created_at и updated_at текущие значения даты
UPDATE users
    SET created_at = NOW() where created_at is NULL;
UPDATE users
	SET updated_at = NOW() where updated_at is NULL;
    
-- RUN TASK 5-2
-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR
-- и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к 
-- типу DATETIME, сохранив введённые ранее значения

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at VARCHAR(255),
    updated_at VARCHAR(255)
    ) COMMENT = 'Покупатели';

INSERT INTO 
	users (name, birthday_at, created_at, updated_at)
VALUES
	('Антон','1989-12-24', '19.11.2020 10:15', '19.11.2020 10:15'),
	('Яна','1990-03-07', '19.11.2020 10:15', '19.11.2020 10:15'),
	('Ольга','1991-07-05', '19.11.2020 10:15', '19.11.2020 10:15'),
	('Мария','1989-01-21', '19.11.2020 10:15', '19.11.2020 10:15'),
	('Алексей','1993-02-06', '19.11.2020 10:15', '19.11.2020 10:15'),
	('Тимофей','2019-01-12', '19.11.2020 10:15', '19.11.2020 10:15');

-- преобразование формата к календарному значению
SELECT STR_TO_DATE(created_at, '%d.%m.%Y %k:%i') FROM users;
UPDATE
	users
SET
	created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
    updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

DESCRIBE users;
-- изменяем тип столбцов с текстовых на дату
ALTER TABLE
	users
CHANGE
	created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE
	users
CHANGE
	updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- RUN TASK 5-3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые
-- разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL PRIMARY KEY,
    storehouse_id INT UNSIGNED,
    product_id INT UNSIGNED,
    value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) COMMENT = 'Запаксы на складе';

INSERT INTO 
	storehouses_products (storehouse_id, product_id, value)
VALUES
	(1, 543, 0),
    (1, 789, 2500),
    (1, 3432, 0),
    (1, 826, 30),
    (1, 719, 500),
    (1, 638, 1);
    
SELECT * FROM storehouses_products ORDER BY value;
SELECT id, value, IF(value > 0, 0, 1) AS sort FROM storehouses_products ORDER BY value;

-- RUN TASK 5-4 
-- (по желанию) Из таблицы users необходимо извлечь пользователей,
-- родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

SELECT name, DATE_FORMAT(birthday_at, '%M') FROM users;
SELECT name FROM users WHERE DATE_FORMAT(birthday_at, '%M') IN ('December', 'July');

-- RUN TASK 5-5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
  
SELECT * FROM catalogs WHERE ID IN (5, 1, 2);
SELECT FIELD(0, 5, 1, 2);
SELECT id, name, FIELD(id, 5, 1, 2) AS pos FROM catalogs WHERE id IN (5, 1, 2);

-- RUN TASK 5-6
-- Подсчитайте средний возраст пользователей в таблице users.
SELECT
	TIMESTAMPDIFF (YEAR, birthday_at, NOW()) AS age
FROM
	users;
    
SELECT
	AVG (TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age
FROM
	users;
    
-- RUN TASK 5-7
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT name, birthday_at FROM users;
SELECT MONTH(birthday_at), DAY(birthday_at) FROM users;
SELECT YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at) FROM users;

SELECT CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at)) AS day FROM users;

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day
FROM
	users;
    
-- без повторов
SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day
FROM
	users
GROUP BY
	day;

-- произведем подсчет
SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
    COUNT(*) AS total
FROM
	users
GROUP BY
	day;
    
-- сортировка обратная

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
    COUNT(*) AS total
FROM
	users
GROUP BY
	day
ORDER BY
	total DESC;
    
-- RUN TASK 5-8
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы.
SELECT id FROM catalogs;
SELECT EXP(SUM(LN(id))) FROM catalogs;
SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;
