 
/*
 
 Урок 5. Видеоурок. Операторы, фильтрация, сортировка и ограничение. Агрегация данных
 
 Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
 Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
3.В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

4.(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
5.(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

Практическое задание теме “Агрегация данных”

6.Подсчитайте средний возраст пользователей в таблице users
7.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.
8.(по желанию) Подсчитайте произведение чисел в столбце таблицы

 */

-- решения в конце скрипта

DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (DEFAULT, 'Процессоры'),
  (DEFAULT, 'Мат.платы'),
  (DEFAULT, 'Видеокарты');

DROP TABLE IF EXISTS cat;
CREATE TABLE cat (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

INSERT INTO
  cat
SELECT
  *
FROM
  catalogs;
SELECT * FROM cat;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


-- =================================


-- 1.
-- Так как в задании не сказано с какой БД и какой её версией пользоваться, предположил что используется shop

INSERT INTO users (name) VALUES  -- дополним пользователями
('Brandt1'),
('Brandt2'),
('Brandt3'),
('Brandt4');
UPDATE users SET created_at=NOW(), updated_at=NOW(); -- и заполним нужные колонки текущеё датой



-- 2. так как в бд таблица создана правильно, то создадим свою неравильную

DROP TABLE IF EXISTS users2;
CREATE TABLE users2 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users2 (name) VALUES  -- дополним пользователями
('Brandt11'),
('Brandt12'),
('Brandt13'),
('Brandt14');

UPDATE users2 SET created_at='20.10.2017 8:10', updated_at='20.10.2017 8:10';  -- неправильными датами
UPDATE users2 set created_at=str_to_date(created_at, '%d.%m.%Y %H:%i:%s'), updated_at=str_to_date(updated_at, '%d.%m.%Y %H:%i:%s'); -- приводим к виду datetime согласно формату
ALTER TABLE users2 MODIFY COLUMN created_at DATETIME; -- преобразуем из строки к типу datetime
ALTER TABLE users2 MODIFY COLUMN updated_at DATETIME;


-- 3.

ALTER TABLE storehouses ADD COLUMN `value` bigint; -- для начала создадим необходимое поле

INSERT into storehouses (name, value) VALUES
('w','1'),
('qwe','2'),
('werr','3'),
('ewr','324'),
('asdf','4'),
('aa','0'),
('ff','0'),
('ffff','7');

SELECT * FROM storehouses ORDER BY IF(value=0,1,0), value;


-- 4.



-- 6.

INSERT INTO users (birthday_at) VALUES
('1994-04-15'),
('2004-04-15'),
('1987-09-01'),
('1966-12-20');

SELECT  AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users; -- находим ср.возраст


-- 7.

SELECT COUNT(*), DAYNAME(DATE_FORMAT((CONCAT(YEAR(NOW()),DATE_FORMAT(birthday_at,'.%m.%d'))),'%Y.%m.%d')) AS `WEEKDAY_of_birthday` FROM users GROUP BY `WEEKDAY_of_birthday`; 



--.
