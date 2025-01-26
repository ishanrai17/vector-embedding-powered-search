class EmbeddingJob
  include Sidekiq::Job

  def perform(*args)
    # read from datastore and write into QA after calculating embedding of question
    # Use the OpenAI API to get the embedding for the question
    # Iterate through each record in the DataStore table
    DataStore.where(processed: false).limit(100).find_each do |record|
      # Get the embedding for the question
      
      embedding = Embedder.MiniLM(record.question)

      # Create a new QA record with the question, answer, and embedding
      # QA.create!(
      #   question: record.question,
      #   answer: record.answer,
      #   embedding: embedding
      # )

      # Insert the record into the QAs table
      embedding_array = "ARRAY[#{embedding.join(',')}]::vector"

      answer = record.answer.nil? ? "" : record.answer.gsub("'", "''")
      question = record.question.nil? ? "" : record.question.gsub("'", "''")


      ActiveRecord::Base.connection.execute(<<-SQL
        INSERT INTO qas (question, answer, embedding)
        VALUES ('#{question}', '#{answer}', #{embedding_array})
        SQL
      )

      # Mark the DataStore record as processed
      record.update(processed: true)
    end
  end


  private 

#   def embed_text(text)
#     # Hugging Face Inference API endpoint for text embedding
#     uri = URI('https://api-inference.huggingface.co/pipeline/feature-extraction/sentence-transformers/all-MiniLM-L6-v2')
#     # Prepare the request
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = true
#     request = Net::HTTP::Post.new(uri.path, {
#       'Content-Type' => 'application/json',
#       'Authorization' => "Bearer #{ENV['HUGGING_FACE_TOKEN']}"
#     })

#     # Set request body
#     request.body = { inputs: text }.to_json
#     # Send request and parse response
#     response = http.request(request)
#     case response.code.to_i
#     when 200
#       JSON.parse(response.body)
#     else
#       raise "API Error: #{response.code} - #{response.body}"
#     end
#   end
end
