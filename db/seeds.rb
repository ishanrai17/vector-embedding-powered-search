# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

DataStore.delete_all

CSV.foreach(Rails.root.join('storage', 'news.csv'), headers: true) do |row|
    DataStore.find_or_create_by!(
        source: row['source'],
        url: row['url'],
        question: row['question'],
        answer: row['answer'],
        wrong_answer: row['wrong_answer']
    )
end

# DataStore.where(processed: false).find_each do |record|
#     # Get the embedding for the question
    
#     embedding = Embedder.MiniLM(record.question)

#     # Insert the record into the QAs table
#     embedding_array = "ARRAY[#{embedding.join(',')}]::vector"

#     answer = record.answer.nil? ? "" : record.answer.gsub("'", "''")
#     question = record.question.nil? ? "" : record.question.gsub("'", "''")


#     ActiveRecord::Base.connection.execute(<<-SQL
#       INSERT INTO qas (question, answer, embedding)
#       VALUES ('#{question}', '#{answer}', #{embedding_array})
#       SQL
#     )

#     record.update(processed: true)
#   end
# end