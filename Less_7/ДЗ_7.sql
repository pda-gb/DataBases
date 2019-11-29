 
/*
 * [7]ПЗ Видеоурок “Сложные запросы”
 * 1.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
2.Выведите список товаров products и разделов catalogs, который соответствует товару.
3.(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

 */


-- 1.

use shop;

SELECT 
  users.name
FROM
  users
JOIN
  orders
ON users.id = orders.user_id; -- on = where только быстрее
 
 
-- 2.

SELECT
  products.name AS `товар`,
  catalogs.name AS `раздел товаров`
FROM
  products
JOIN
  catalogs
ON products.catalog_id = catalogs.id;


-- 3.
