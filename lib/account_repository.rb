require_relative './account.rb'

class AccountRepository

    def all
        sql = 'SELECT id, email, username FROM accounts;'
        result = DatabaseConnection.exec_params(sql, [])

        accounts = []

        result.each do |record|
            accounts << accounts_object_from_table(record)
        end
        return accounts
    end

    def find(id)
        sql = 'SELECT id, email, username FROM accounts WHERE id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
        return accounts_object_from_table(result[0])
    end
  
  
    def create(account)
        sql = 'INSERT INTO accounts (email, username) VALUES ($1, $2);'
        params = [account.email, account.username]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end
  
    def update(account)
        sql = 'UPDATE accounts SET email = $1, username = $2 WHERE id = $3;'
        params = [account.email, account.username, account.id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end
  
    def delete(id)
        sql = 'DELETE FROM accounts WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
    end

    private

    def accounts_object_from_table(record)
        account = Account.new
        account.id = record["id"].to_i
        account.email = record["email"]
        account.username = record["username"]
        return account
    end

end