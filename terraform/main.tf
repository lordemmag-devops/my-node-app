
provider "google" {
  #credentials = base64decode(var.GCP_CREDENTIALS)
  project     = var.project_id
  region      = var.region
}

resource "google_artifact_registry_repository" "app_repo" {
  location      = var.region
  repository_id = "my-node-app-repo"
  format        = "DOCKER"
}

resource "google_cloud_run_service" "app_service" {
  name     = "my-node-app"
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/my-node-app-repo/my-node-app:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "public_access" {
  location    = google_cloud_run_service.app_service.location
  project     = google_cloud_run_service.app_service.project
  service     = google_cloud_run_service.app_service.name

  policy_data = jsonencode({
    bindings = [
      {
        role    = "roles/run.invoker"
        members = ["allUsers"]
      }
    ]
  })
}

output "cloud_run_url" {
  value = google_cloud_run_service.app_service.status[0].url
}

# Test Github actions
