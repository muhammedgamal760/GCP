resource "google_compute_firewall" "jimmy-firewall-ssh" {
  name    = "jimmy-firewall-ssh"
  network = google_compute_network.jimmy-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"] 
  target_tags = ["jimmy"]
}
