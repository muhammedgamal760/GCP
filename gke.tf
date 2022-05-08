resource "google_container_cluster" "jimmy-private-gke" {
  name     = "jimmy-private-gke"
  location = "us-east1-b"
#   node_locations = ["us-east1-b"]
  initial_node_count = 2
  remove_default_node_pool = true
  network = "jimmy-vpc"
  subnetwork = "restricted-subnet"
  default_max_pods_per_node = 10
  ip_allocation_policy {
  cluster_secondary_range_name = "pods"
  services_secondary_range_name = "services"
  }
  master_authorized_networks_config {
  cidr_blocks {
    cidr_block = "10.0.1.4/32"
  }
  }
  private_cluster_config {
  enable_private_endpoint = true
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "172.16.0.32/28"
} 
  workload_identity_config {
  workload_pool = "jimmy-gcp-348513.svc.id.goog"
}

}

resource "google_container_node_pool" "jimmy-node-pool" {
  name       = "jimmy-node-pool"
  location = "us-east1-b"
#   node_locations = ["us-east1-b"]
  cluster    = google_container_cluster.jimmy-private-gke.name
  node_count = 2
  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
    service_account = google_service_account.jimmy-sa2.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}