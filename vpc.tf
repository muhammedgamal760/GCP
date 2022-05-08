resource "google_compute_network" "jimmy-vpc" {
  project                 = "jimmy-gcp-348513"
  name                    = "jimmy-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}