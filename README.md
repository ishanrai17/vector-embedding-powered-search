# Search Engine powered a vector database

## Introduction
This project provides a search engine using vector embeddings for semantic similarity.

## Description
This search engine is primarily designed to provide accurate and relevant information related to COVID-19. By leveraging vector embeddings, it ensures that users can find semantically similar content, making it easier to access critical information during the pandemic. We have built this project on top of a QA dataset specifically curated for COVID-19 related questions, enhancing the search engine's ability to deliver precise and contextually relevant results.

## Workflow  

1. **Data Ingestion**  
   - All raw data is stored in a centralized data store.

2. **Embedding Generation**  
   - Periodic embedding generation is handled by **Sidekiq workers**.
   - Workers integrate with the Hugging Face **MiniLM-L6-v2** embedding model via a rate-limited API to generate vector embeddings for textual data which is stored in the database.
   - The activation frequency of workers can be fine-tuned to comply with rate-limiting requirements.

3. **Search Functionality**  
   - The search engine remains operational even if the dataset has been processed partially.
   - When a search query is submitted:
     - Vector embeddings are generated for the query using the same Hugging Face API integration.
     - A **cosine similarity** check is performed against the stored embeddings in the database to retrieve relevant results.

4. **Database**  
   - **PostgreSQL** with the `pgvector` extension is used to store and manage vector embeddings, supporting efficient similarity-based queries.


## Features  

- **Containerized Architecture**  
  - The entire project is containerized using **Docker**.  
  - **Docker Compose** is used for orchestration and managing services.

- **Efficient Similarity Search**  
  - Implements high-performance approximate nearest neighbor searches using **cosine similarity**.

- **Seamless Embedding Integration**  
  - Integrates with Hugging Face's **MiniLM-L6-v2** embedding model via a rate-limited API for consistent and accurate embedding generation.

- **Optimized Database**  
  - Utilizes **PostgreSQL** with the `pgvector` extension for storing vector embeddings and performing fast similarity-based searches.


## Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/vector-embedding-powered-search.git
    ```
2. **Install Docker Desktop:**
    Ensure Docker Desktop is installed on your machine. [Download Docker Desktop](https://www.docker.com/products/docker-desktop).

3. **Add your Hugging Face API key:**
    Add your API key in the .env file:
    ```plaintext
    HUGGING_FACE_API_KEY=your_api_key_here
    ```

4. **Build and run the containers:**
    Navigate to the project directory and execute:
    ```bash
    docker-compose up --build
    ```

5. **Easy Setup:**
    You can configure Sidekiq workers to update the database periodically. However, since the COVID-19 news database is not very large, you can process all vector embeddings in one go without being rate-limited. To achieve this, uncomment the relevant code in the database seed file.

6. **Perform Migration:**
    Navigate into the web container and run the following commands to migrate and seed the database:
    ```bash
    rails db:migrate db:seed
    ```

7. **Access the Application:**
    Open your web browser and go to `http://localhost:3000` to start using the search engine.
    Open your web browser and go to `http://localhost:3000` to start using the search engine.

## Demo
When the answer exists in the dataset:  
![Demo Video](./demo/successful_query.gif)

When the answer does not exist in the dataset:  
![Demo Video](./demo/empty_query.gif)

## Usage
1. Generate embeddings for your data.
2. Index them using the custom EmbeddingJob worker or manually through the rails console.
3. Run queries on the webpage and retrieve semantically similar items.
