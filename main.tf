#Change path as per the location of your repository
variable "repository_path" {
  description = "Common path to /Users/sraj/Desktop"
  type        = string
  default     = "/Users/sraj/Desktop"
}
#to create cluster rolebindings
resource "kubernetes_cluster_role_binding" "strimzi_cluster_operator_namespaced" {
  metadata {
    name = "strimzi-cluster-operator-namespaced"
  }

  role_ref {
    kind     = "ClusterRole"
    name     = "strimzi-cluster-operator-namespaced"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "strimzi-cluster-operator"
    namespace = "kafka"
  }
}

resource "kubernetes_cluster_role_binding" "strimzi_cluster_operator_entity_operator_delegation" {
  metadata {
    name = "strimzi-cluster-operator-entity-operator-delegation"
  }

  role_ref {
    kind     = "ClusterRole"
    name     = "strimzi-entity-operator"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "strimzi-cluster-operator"
    namespace = "kafka"
  }
}

resource "kubernetes_cluster_role_binding" "strimzi_cluster_operator_topic_operator_delegation" {
  metadata {
    name = "strimzi-cluster-operator-topic-operator-delegation"
  }

  role_ref {
    kind     = "ClusterRole"
    name     = "strimzi-topic-operator"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "strimzi-cluster-operator"
    namespace = "kafka"
  }
}


resource "null_resource" "execute_bash_script" {
  triggers = {
    bash_script = filebase64("${var.repository_path}/monitoring-osk-using-strimzi/apply-files.sh")
  }

  provisioner "local-exec" {
    command = "chmod +x apply-files.sh"
  }

  provisioner "local-exec" {
    command = "./apply-files.sh"
  }
}

resource "null_resource" "kafka-metrics" {
    provisioner "local-exec" {
    command = "kubectl apply -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/kafka-metrics.yaml -n kafka"
  }
}


resource "null_resource" "prometheus_operator" {
 provisioner "local-exec" {
    command = "kubectl create -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/prometheus-install/bundle.yaml -n monitoring"
  }
}

resource "null_resource" "create_additional_scrape_configs_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic additional-scrape-configs --from-file=${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/prometheus-additional-properties/prometheus-additional.yaml -n monitoring"
  }
}

resource "null_resource" "prometheus_additional" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/prometheus-additional-properties/prometheus-additional.yaml -n monitoring"
  }
}


resource "null_resource" "strimzi_pod_monitor" {
  provisioner "local-exec" {
    command = "kubectl create -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/prometheus-install/strimzi-pod-monitor.yaml -n monitoring"
  }
}

resource "null_resource" "prometheus_rules" {
  provisioner "local-exec" {
    command = "kubectl create -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/prometheus-install/prometheus-rules.yaml -n monitoring"
  }
}

resource "null_resource" "prometheus" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/prometheus-install/prometheus.yaml -n monitoring"
  }
}

resource "null_resource" "prometheus_port_forward" {
  depends_on = [null_resource.prometheus]  # Depend on the prometheus resource
  provisioner "local-exec" {
    command = "kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring"
  }
}
# ... Similar resource blocks for other Kubernetes manifests ...


resource "null_resource" "grafana" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.repository_path}/monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/grafana-install/grafana.yaml -n monitoring"
  }
}


# Use a local-exec provisioner to perform port-forwarding


resource "null_resource" "grafana_port_forward" {
 depends_on = [null_resource.grafana]  # Depend on the Grafana resource
 provisioner "local-exec" {
    command = "kubectl port-forward svc/grafana 3000:3000 -n monitoring"
  }
}

# Use external data sources to retrieve data for dashboards, alerts, etc.


#Create Grafan dashboard manually


# ... Other external data sources ...

# Use local-exec provisioner to run kubectl commands for applying other resources

# ... Additional resource blocks for applying other Kubernetes manifests ...


# Define Kafka Connector properties

