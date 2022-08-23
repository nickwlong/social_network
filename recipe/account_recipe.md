# Account Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `accounts`*

```
# EXAMPLE

Table: accounts

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
# Table name: accounts

# Model class
# (in lib/account.rb)
class Account
end

# Repository class
# (in lib/account_repository.rb)
class AccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: accounts

# Model class
# (in lib/account.rb)

class Account
  attr_accessor :id, :email_address, :username
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: accounts

# Repository class
# (in lib/account_repository.rb)

class AccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email_address, username FROM accounts;

    # Returns an array of Account objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email_address, username FROM accounts; WHERE id = $1;

    # Returns a single Account object.
  end


  def create(account)

    #Inserts attributes of an account object into the database
    #Executes the SQL query:
    #INSERT INTO accounts (email_address, username) VALUES ($1, $2);
    #Returns nothing
  end

  def update(account)
    #Updates details of an account of a certain id
    #Executes the SQL query:
    #UPDATE accounts SET email_address = $1, username = $2 WHERE id = $3;
  end

  def delete(account)
    #Deletes an account based on the account id
    #Executes the SQL query:
    #DELETE FROM accounts WHERE id = $1;
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all accounts

repo = AccountRepository.new

accounts = repo.all

accounts.length # =>  2

accounts[0].id # => "1"
accounts[0].email_address # => 'nick@hotmail.com'
accounts[0].username # => 'nick'

accounts[1].id # => '2'
accounts[1].email_address # => 'jim@hotmail.com'
accounts[1].username # => 'jimmo'


# 2
# Get a single account

repo = AccountRepository.new

account = repo.find(1)

accounts.id # => "1"
accounts.email_address # => 'nick@hotmail.com'
accounts.username # => 'nick'

#3 
#Create a new account

repo = AccountRepository.new

account = Account.new
account.email_address = 'fake@fake.com'
account.username = 'sonotfake'

repo.create(account)

accounts = repo.all
accounts.last.email_address # => 'fake@fake.com'
accounts.last.username # => 'sonotfake'

#4
#Update an account

repo = AccountRepository.new

account = Account.new
account.email = 'fake@fake.com'
account.username = 'sonotfake'
account.id = '1'

repo.update(account)
changed_account = repo.find(1)
changed_account.email # => 'fake@fake.com'
changed_account.username # => 'sonotfake'

#5
#Delete an account
repo = AccountRepository.new

repo.delete(1)
all_accounts = repo.all
all_accounts.length # => 1
all_accounts.first.id # => 2

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/account_repository_spec.rb

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'accounts' })
  connection.exec(seed_sql)
end

describe accountRepository do
  before(:each) do 
    reset_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
