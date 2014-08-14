ALTER TABLE posts ADD COLUMN stars_count INTEGER DEFAULT 0;

UPDATE posts SET stars_count = IFNULL((SELECT COUNT(id) FROM stars WHERE stars.post_id = posts.id GROUP BY posts.id), 0);
