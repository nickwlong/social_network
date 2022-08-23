

TRUNCATE TABLE accounts, posts RESTART IDENTITY; 


INSERT INTO accounts (email, username) VALUES
('nick@hotmail.com', 'nick'),
('jim@hotmail.com', 'jimmo');

INSERT INTO posts (title, content, view_count, account_id) VALUES 
('How to be cool', 'Just be', '3', '1'),
('How to be chill', 'Just being', '14', '2');