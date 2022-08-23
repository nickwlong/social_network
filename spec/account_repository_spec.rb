require 'account_repository'

RSpec.describe AccountRepository do

    def reset_accounts_table
        seed_sql = File.read('spec/seeds_social_network_test.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
    end    


    before(:each) do 
        reset_accounts_table
    end

    describe '#all' do
        it 'creates an array of all accounts as objects' do
            repo = AccountRepository.new

            accounts = repo.all

            expect(accounts.length).to eq 2

            expect(accounts[0].id).to eq 1
            expect(accounts[0].email).to eq 'nick@hotmail.com'
            expect(accounts[0].username).to eq 'nick'

            expect(accounts[1].id).to eq 2
            expect(accounts[1].email).to eq 'jim@hotmail.com'
            expect(accounts[1].username).to eq 'jimmo'   
        end
    end
    describe '#find' do
        it 'returns the account object of a particular id' do
            repo = AccountRepository.new

            account = repo.find(1)

            expect(account.id).to eq 1
            expect(account.email).to eq 'nick@hotmail.com'
            expect(account.username).to eq 'nick'
        end
    end
    describe '#create' do
        it 'creates a new account' do
            repo = AccountRepository.new

            new_account = Account.new
            new_account.email = 'fake@fake.com'
            new_account.username = 'sonotfake'

            repo.create(new_account)

            accounts = repo.all
            expect(accounts.last.email).to eq 'fake@fake.com'
            expect(accounts.last.username).to eq 'sonotfake'
        end
    end
    describe '#update' do
        it 'updates an account with new details' do
            repo = AccountRepository.new

            account = Account.new
            account.email = 'fake@fake.com'
            account.username = 'sonotfake'
            account.id = '1'

            repo.update(account)

            changed_account = repo.find(1)
            expect(changed_account.email).to eq 'fake@fake.com'
            expect(changed_account.username).to eq 'sonotfake'
        end
    end
    describe '#delete' do
        it 'deletes account of id 1' do
            repo = AccountRepository.new

            repo.delete(1)
            all_accounts = repo.all
            expect(all_accounts.length).to eq 1
            expect(all_accounts.first.id).to eq 2
        end
        it 'deletes both existing accounts' do
            repo = AccountRepository.new

            repo.delete(1)
            repo.delete(2)
            all_accounts = repo.all
            expect(all_accounts.length).to eq 0
        end
    end
end