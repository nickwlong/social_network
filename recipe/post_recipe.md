# post Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `posts`*

```
# EXAMPLE

Table: posts

Columns:
id | name | cohort_name
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql


TRUNCATE TABLE accounts, posts RESTART IDENTITY; 


INSERT INTO accounts (email, username) VALUES
('nick@hotmail.com', 'nick'),
('jim@hotmail.com', 'jimmo');

INSERT INTO posts (title, content, view_count, network_user_id) VALUES 
('How to be cool', 'Just be', '3', '1'),
('How to be chill', 'Just being', '14', '2');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < seeds_social_network_test.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)

class Post
  attr_accessor :id, :title, :content, :view_count, :account_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class postRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, view_count, account_id FROM posts;

    # Returns an array of post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, view_count, account_id FROM posts WHERE id = $1;

    # Returns a single post object.
  end


  def create(post)

    #Inserts attributes of an post object into the database
    #Executes the SQL query:
    #INSERT INTO posts (id, title, content, view_count, account_id) VALUES ($1, $2, $3, $4);
    #Returns nothing
  end

  def update(post)
    #Updates details of an post of a certain id
    #Executes the SQL query:
    #UPDATE posts SET title = $1, content = $2, view_count = $3, account_id = $4 WHERE id = $5;
  end

  def delete(id)
    #Deletes an post based on the post id
    #Executes the SQL query:
    #DELETE FROM posts WHERE id = $1;
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all posts

repo = PostRepository.new

posts = repo.all

posts.length # =>  2

posts[0].id # => "1"
posts[0].title # => 'How to be cool'
posts[0].content # => 'Just be'
posts[0].view_count # => '3'
posts[0].account_id # => '1'

posts[1].id # => '2'
posts[1].email_address # => 'How to be chill'
posts[1].username # => 'Just being'
posts[1].view_count # => '14'
posts[1].account_id # => '2'



# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

posts.id # => "1"
posts.title # => 'How to be cool'
posts.content # => 'Just be'
posts.view_count # => '3'
posts.account_id # => '1'

#3 
#Create a new post

repo = PostRepository.new

post = Post.new
post.title = 'Fake News'
post.content = 'Is fake'
post.view_count = '34'
post.account_id = '2'

repo.create(post)

posts = repo.all
post.last.title # => 'Fake News'
post.last.content # => 'Is fake'
post.last.view_count # => '34'
post.last.account_id # => '2'


#4
#Update an post

repo = PostRepository.new

post = Post.new
post.title = 'Oopsy'
post.content = 'Big oopsy update'
post.view_count = '1400'
post.account_id = '2'

repo.update(post)
changed_post = repo.find(1)
changed_post.title # => 'Oopsy'
changed_post.content # => 'Big oopsy update'
changed_post.view_count # => '1400'
changed_post.account_id # => '2'

#5
#Delete a post
repo = PostRepository.new

repo.delete(1)
all_posts = repo.all
all_posts.length # => 1
all_posts.first.id # => 2

#Delete both posts

repo = PostRepository.new

repo.delete(1)
repo.delete(2)
all_posts = repo.all
all_posts.length # => 0


# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'posts' })
  connection.exec(seed_sql)
end

describe postRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
