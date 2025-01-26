class CreateQaEmbeddings < ActiveRecord::Migration[8.0]
  def change
    create_table :qa_embeddings do |t|
      t.string :question, null: false
      t.string :answer, null: false

      # Adjust dimensions based on your embedding model (e.g., OpenAI's text-embedding-ada-002 uses 1536)
      t.vector :embedding, dimensions: 1536, null: false

      t.timestamps
    end

    # Add an index for vector similarity search
    add_index :qa_embeddings, :embedding, using: :hnsw
  end
end
