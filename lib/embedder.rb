# lib/embedder.rb

class Embedder
    def self.MiniLM(text) 
        # Hugging Face Inference API endpoint for text embedding
        uri = URI('https://api-inference.huggingface.co/pipeline/feature-extraction/sentence-transformers/all-MiniLM-L6-v2')
        # Prepare the request
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{ENV['TEMP_TOKEN']}"
        })
        
        # Set request body
        request.body = { inputs: text }.to_json
        # Send request and parse response
        response = http.request(request)
        case response.code.to_i
        when 200
            JSON.parse(response.body)
        else
            raise "API Error: #{response.code} - #{response.body}"
        end
    end
end