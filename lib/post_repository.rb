require_relative './post.rb'

class PostRepository

    def all
        sql = 'SELECT id, title, content, view_count, account_id FROM posts;'
        result = DatabaseConnection.exec_params(sql, [])

        posts = []

        result.each do |record|
            posts << post_object_from_table(record)
        end
        return posts
    end

    def find(id)
        sql = 'SELECT id, title, content, view_count, account_id FROM posts WHERE id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
        return post_object_from_table(result[0])
    end
  
  
    def create(post)
        sql = 'INSERT INTO posts (title, content, view_count, account_id) VALUES ($1, $2, $3, $4)'
        params = [post.title, post.content, post.view_count, post.account_id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end
  
    def update(post)
        sql = 'UPDATE posts SET title = $1, content = $2, view_count = $3, account_id = $4 WHERE id = $5;'
        params = [post.title, post.content, post.view_count, post.account_id, post.id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end
  
    def delete(id)
        sql = 'DELETE FROM posts WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
    end

    private

    def post_object_from_table(record)
        post = Post.new
        post.id = record["id"].to_i
        post.title = record["title"]
        post.content = record["content"]
        post.view_count = record["view_count"].to_i
        post.account_id = record["account_id"].to_i
        return post
    end

end