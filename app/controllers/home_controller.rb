class HomeController < ApplicationController
  def index
    # render page views/home/index.html
    render file: 'app/views/home/index.html', layout: false
  end

  def search
    results = perform_search(params[:query])
    render json: results
  end

  private

  def perform_search(query)
    embedding = Embedder.MiniLM(query)
    pg_embedding = "ARRAY[#{embedding.join(',')}]::vector"
    ActiveRecord::Base.connection.execute(<<-SQL
      SELECT question, answer, 
            1 - (embedding <=> #{pg_embedding}) AS similarity
      FROM qas
      WHERE 1 - (embedding <=> #{pg_embedding}) > 0.7
      ORDER BY similarity DESC
      LIMIT 5;
      SQL
    )
  end
end