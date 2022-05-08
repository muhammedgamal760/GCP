resource "google_compute_router" "jimmyy-router" {
  name    = "jimmyy-router"
  region  = "us-east1"
  network = google_compute_network.jimmy-vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "jimmy-nat" {
  name                               = "jimmy-nat"
  router                             = google_compute_router.jimmyy-router.name
  region                             = google_compute_router.jimmyy-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.management-subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}