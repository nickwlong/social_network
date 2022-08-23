require 'post_repository'

RSpec.describe PostRepository do

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
            repo = PostRepository.new

            posts = repo.all
            
            expect(posts.length).to eq 2
            
            expect(posts[0].id).to eq 1
            expect(posts[0].title).to eq 'How to be cool'
            expect(posts[0].content).to eq 'Just be'
            expect(posts[0].view_count).to eq 3
            expect(posts[0].account_id).to eq 1
            
            expect(posts[1].id).to eq 2
            expect(posts[1].title).to eq 'How to be chill'
            expect(posts[1].content).to eq 'Just being'
            expect(posts[1].view_count).to eq 14
            expect(posts[1].account_id).to eq 2 
        end
    end
    describe '#find' do
        it 'returns the account object of a particular id' do
            repo = PostRepository.new

            post = repo.find(1)

            expect(post.id).to eq 1
            expect(post.title).to eq 'How to be cool'
            expect(post.content).to eq 'Just be'
            expect(post.view_count).to eq 3
            expect(post.account_id).to eq 1
        end
    end
    describe '#create' do
        it 'creates a new account' do
            repo = PostRepository.new

            post = Post.new
            post.title = 'Fake News'
            post.content = 'Is fake'
            post.view_count = 34
            post.account_id = 2

            repo.create(post)

            posts = repo.all
            expect(posts.last.title).to eq 'Fake News'
            expect(posts.last.content).to eq 'Is fake'
            expect(posts.last.view_count).to eq 34
            expect(posts.last.account_id).to eq 2
        end
    end
    describe '#update' do
        it 'updates an account with new details' do
            repo = PostRepository.new

            post = Post.new
            post.id = 1
            post.title = 'Oopsy'
            post.content = 'Big oopsy update'
            post.view_count = 1400
            post.account_id = 2
            
            repo.update(post)
            changed_post = repo.find(1)
            expect(changed_post.title).to eq 'Oopsy'
            expect(changed_post.content).to eq 'Big oopsy update'
            expect(changed_post.view_count).to eq 1400
            expect(changed_post.account_id).to eq 2
        end
    end
    describe '#delete' do
        it 'deletes account of id 1' do
            repo = PostRepository.new

            repo.delete(1)
            all_posts = repo.all
            expect(all_posts.length).to eq 1
            expect(all_posts.first.id).to eq 2
        end
        it 'deletes both existing accounts' do
            repo = PostRepository.new

            repo.delete(1)
            repo.delete(2)
            all_posts = repo.all
            expect(all_posts.length).to eq 0
        end
    end
end