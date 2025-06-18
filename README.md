# Truth Teller Rails Application

This is a Ruby on Rails 8 application designed for document management, chunking, and AI-powered analysis (including embeddings and due diligence question evaluation). It features user authentication, client management, document upload and chunking, and integration with OpenAI for advanced document analysis.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Setup](#setup)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Background Jobs](#background-jobs)
- [Testing](#testing)
- [Deployment](#deployment)
- [License](#license)

---

## Features

- **User Authentication**: Uses Devise and JWT for secure API authentication.
- **Client Management**: Users can create and manage clients.
- **Document Upload & Chunking**: Documents are uploaded, stored, and automatically split into chunks for processing.
- **Vector Embeddings**: Each document chunk is embedded using AI models and stored for similarity search.
- **Due Diligence Question (DDQ) Evaluation**: Integrates with OpenAI to evaluate answers to DDQ using document context.
- **API-First**: JSON:API serialization for all resources.
- **Background Processing**: Uses Sidekiq for async jobs (chunking, embedding, email).

---

## Architecture

- **Models**: `User`, `Client`, `Document`, `DocumentChunk`
- **Controllers**: RESTful API under `app/controllers/api/v1/`
- **Jobs**: Background jobs for document chunking and embedding
- **Services**: Business logic (e.g., DDQ evaluation) in `app/services/`
- **Serializers**: JSON:API formatting in `app/serializers/`
- **Storage**: Uses Shrine for file uploads, PostgreSQL with pgvector for vector search, Redis for Sidekiq

---

## Setup

### Prerequisites

- Ruby 3.4.4
- Rails 8.0.2
- Docker & Docker Compose (for local development)
- PostgreSQL (with pgvector extension)
- Redis

### Installation

1. **Clone the repository:**
   ```sh
   git clone <repo-url>
   cd ontra
   ```

2. **Install dependencies:**
   ```sh
   bundle install
   ```

3. **Set up environment variables:**
   - Copy `.env.example` to `.env` and fill in required values (e.g., `OPENAI_API_KEY`).

4. **Set up the database:**
   ```sh
   rails db:create db:migrate
   ```

5. **Start services (Postgres, Redis) with Docker Compose:**
   ```sh
   docker-compose up -d
   ```

---

## Configuration

- **Database**: PostgreSQL with `pgvector` for vector search.
- **Background Jobs**: Sidekiq (uses Redis).
- **File Storage**: Shrine (local or cloud, configurable).
- **AI Integration**: OpenAI API key required for DDQ and embeddings.

---

## Running the Application

```sh
rails server
```

Or with Docker:

```sh
docker-compose up --build
```

---

## API Endpoints

All endpoints are under `/api/v1/` and require JWT authentication unless otherwise noted.

### Users

- `GET /api/v1/users/current` — Get current user info

### Clients

- `GET /api/v1/clients` — List clients
- `POST /api/v1/clients` — Create a client

### User-Client Association

- `GET /api/v1/users/:user_id/clients` — List a user's clients
- `POST /api/v1/users/:user_id/clients/:client_id` — Associate user with client

### Documents

- `GET /api/v1/documents` — List documents
- `POST /api/v1/documents` — Upload a document (multipart with `file` and `document` JSON)

### DDQ (Due Diligence Questions)

- `POST /api/v1/ddq_questions` — Evaluate an answer to a DDQ using document context and OpenAI

---

## Background Jobs

- **ChunkDocumentJob**: Splits uploaded documents into chunks for processing.
- **GenerateDocumentChunkEmbeddingJob**: Generates vector embeddings for each chunk.
- **SendConfirmationEmailJob**: Handles email confirmations (if enabled).

Jobs are processed asynchronously via Sidekiq.

---

## Testing

```sh
bundle exec rspec
```

---

## Deployment

- Use the provided `Dockerfile` and `docker-compose.yml` for containerized deployment.
- Ensure environment variables and secrets are set in production.

---

## License

[MIT](LICENSE)
