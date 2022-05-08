# resource "google_service_account" "jimmy-sa1" {
#   account_id   = "jimmy-sa1"
#   display_name = "jimmy"
#   project = "jimmy-gcp-348513"
  
# }

data "google_iam_policy" "owner" {
  binding {
    role = "roles/owner"

    members = [
      "serviceAccount:${google_service_account.jimmy-sa2.email}",
    ]
  }
}

resource "google_project_iam_member" "jimmy-iam" {
  project = "jimmy-gcp-348513"
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.jimmy-sa2.email}"
}

resource "google_service_account" "jimmy-sa2" {
  account_id   = "jimmy-sa2"
  display_name = "jimmy"
  project = "jimmy-gcp-348513"
}

resource "google_service_account_iam_policy" "jimmy-owner" {
  service_account_id = google_service_account.jimmy-sa2.name
  policy_data        = data.google_iam_policy.owner.policy_data
}


resource "google_compute_instance" "jimmy-private-vm" {
  name         = "jimmy-private-vm"
  machine_type = "n1-standard-1"
  zone         = "us-east1-b"

  tags = ["jimmy"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "jimmy-vpc"
    subnetwork = "management-subnet"
  }

  metadata = {
    name = "private-vm"
  }

  allow_stopping_for_update = true


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.jimmy-sa2.email
    scopes = ["cloud-platform"]
  }
}