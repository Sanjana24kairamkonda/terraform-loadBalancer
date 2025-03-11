# Create a network
resource "google_compute_network" "default" {
  name                    = "default-network"
  auto_create_subnetworks  = true
}

# Create a backend instance group
resource "google_compute_instance_group_manager" "default" {
  name                    = "backend-instance-group"
  zone                    = var.zone
  version {
    instance_template = google_compute_instance_template.backend-instance-template.self_link
  }
  target_size             = var.backend_instance_count
  update_strategy         = "ROLLING_UPDATE"
}

# Create a health check for backend instances
resource "google_compute_http_health_check" "default" {
  name                = "http-health-check"
  request_path        = "/"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

# Create a backend service
resource "google_compute_backend_service" "default" {
  name                  = "backend-service"
  health_checks         = [google_compute_http_health_check.default.self_link]
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  connection_draining {
    draining_timeout_sec = 300
  }

  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}

# Create an HTTP(S) Load Balancer (Frontend)
resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

resource "google_compute_global_address" "default" {
  name = "loadbalancer-ip"
}

# SSL Certificate (Optional)
resource "google_compute_managed_ssl_certificate" "default" {
  name = "ssl-certificate"
  managed {
    domains = ["sanjana.com"]
  }
}
