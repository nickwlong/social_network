CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  email text,
  username text
);

-- Then the table with the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  view_count int,
-- The foreign key name is always {other_table_singular}_id
  network_user_id int,
  constraint fk_network_user1 foreign key(network_user_id)
    references accounts(id)
    on delete cascade
);

INSERT INTO accounts (email, username) VALUES
('nick@hotmail.com', 'nick'),
('jim@hotmail.com', 'jimmo'),
('superdog@hotmail.com', 'sdawg'),
('wonderkite@hotmail.com', 'kitto');

INSERT INTO posts (title, content, view_count, network_user_id) VALUES 
('How to be cool', 'Just be', '3', '1'),
('How to be chill', 'Just be', '14', '1'),
('Eat carrots', 'Eat carrots as part of a health diet', '220', '2'),
('Woof', 'Just woof', '4', '3'),
('T', 'abcdef', '1', '4');
