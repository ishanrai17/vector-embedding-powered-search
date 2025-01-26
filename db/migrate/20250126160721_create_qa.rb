class CreateQa < ActiveRecord::Migration[8.0]
  def change
    execute "CREATE EXTENSION IF NOT EXISTS vector"

    execute "
      CREATE TABLE qas (
          id BIGSERIAL PRIMARY KEY,
          question VARCHAR NOT NULL,
          answer VARCHAR NOT NULL,
          embedding vector(384) NOT NULL
      );"

    execute "CREATE INDEX ON qas USING hnsw (embedding vector_l2_ops)"
  end
end
