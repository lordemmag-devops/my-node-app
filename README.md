# DevOps Learning Project: Node.js App on Google Cloud Run

This project demonstrates a DevOps workflow by deploying a simple Node.js application to Google Cloud Platform (GCP) Cloud Run using Docker, Terraform, and GitHub Actions. It’s designed for learning key DevOps concepts like CI/CD, infrastructure as code (IaC), and containerization.

## Project Overview
- **Application**: A basic Node.js Express app serving a "Hello, DevOps!" page.
- **Infrastructure**: Deployed on GCP Cloud Run, a serverless container platform.
- **Tools**:
  - **Docker**: Containerizes the Node.js app.
  - **Terraform**: Defines and provisions GCP infrastructure.
  - **GitHub Actions**: Automates testing, building, and deployment.
  - **GCP**: Hosts the app on Cloud Run with a service account for access.

## Prerequisites
- A Google Cloud Platform account (free tier available).
- A GitHub account.
- Docker installed on your local machine (e.g., Docker Desktop for macOS).
- Terraform installed (`brew install terraform` on macOS).
- Node.js and npm installed for local testing.
- GCP CLI (`gcloud`) installed and authenticated.

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

### 2. Set Up Google Cloud
1. Create a GCP project in the GCP Console.
2. Enable the Cloud Run API and Artifact Registry API.
3. Create a service account with `Cloud Run Admin` and `Artifact Registry Writer` roles.
4. Download the service account JSON key and store it securely.
5. Set up Google Cloud CLI:
   ```bash
   gcloud auth login
   gcloud config set project <your-gcp-project-id>
   ```

### 3. Configure GitHub Secrets
In your GitHub repository, go to Settings > Secrets and variables > Actions > New repository secret:
- `GCP_PROJECT_ID`: Your GCP project ID.
- `GCP_SA_KEY`: The JSON key for your service account (base64-encoded: `base64 service-account-key.json`).
- `GCP_REGION`: Your preferred region (e.g., `us-central1`).

### 4. Initialize Terraform
```bash
cd terraform
terraform init
terraform apply -var="project_id=$GCP_PROJECT_ID" -var="region=$GCP_REGION"
```

### 5. Local Testing
1. Build and run the Docker container locally:
   ```bash
   docker build -t my-node-app .
   docker run -p 8080:8080 my-node-app
   ```
2. Open `http://localhost:8080` to see "Hello, DevOps!".

### 6. Push to GitHub
Commit and push changes to trigger the GitHub Actions pipeline:
```bash
git add .
git commit -m "Initial commit"
git push origin main
```

## CI/CD Pipeline
The GitHub Actions workflow (`.github/workflows/deploy.yml`) handles:
- **Linting and Testing**: Runs ESLint and tests (if added).
- **Build**: Creates a Docker image.
- **Push**: Pushes the image to GCP Artifact Registry.
- **Deploy**: Deploys to Cloud Run.

## File Structure
```
├── .dockerignore       # Excludes unnecessary files from Docker
├── .github
│   └── workflows
│       └── deploy.yml  # GitHub Actions CI/CD pipeline
├── Dockerfile          # Docker configuration
├── package.json        # Node.js dependencies
├── server.js           # Node.js Express app
├── terraform
│   ├── main.tf        # Terraform configuration
│   └── variables.tf   # Terraform variables
└── README.md           # This file
```

## Learning Objectives
- Understand containerization with Docker.
- Learn infrastructure as code with Terraform.
- Set up a CI/CD pipeline using GitHub Actions.
- Deploy a serverless application on GCP Cloud Run.
- Manage secrets and permissions in a cloud environment.

## Next Steps
- Add unit tests to `server.js` and update the pipeline to run them.
- Explore GCP monitoring and logging for Cloud Run.
- Experiment with auto-scaling settings in Cloud Run.
- Extend the app with additional routes or features.