/*
 * Урок 6. Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных

Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”. Работаем с БД vk и данными, которые вы сгенерировали ранее:
- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
- Определить кто больше поставил лайков (всего) - мужчины или женщины?
 */

-- 1
-- выбираем Brandt id 1
-- SET @user1=(SELECT id FROM users WHERE firstname='Brandt');
-- SELECT @user1;   -- не работает, поэтому пока укажем напрямую ид


-- SELECT initiator_user_id FROM friend_requests WHERE status = 'approved' AND target_user_id=1
-- UNION SELECT target_user_id FROM friend_requests WHERE status = 'approved' AND initiator_user_id=1;

SELECT * FROM messages WHERE 
							(from_user_id in (SELECT initiator_user_id FROM friend_requests WHERE status = 'approved' AND target_user_id=1 UNION SELECT target_user_id FROM friend_requests WHERE status = 'approved' AND initiator_user_id=1)
							AND to_user_id=1)
							OR
							(to_user_id in (SELECT initiator_user_id FROM friend_requests WHERE status = 'approved' AND target_user_id=1 UNION SELECT target_user_id FROM friend_requests WHERE status = 'approved' AND initiator_user_id=1)
							AND from_user_id=1)
						GROUP BY 
							
							
							;




