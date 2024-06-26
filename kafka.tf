resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  namespace  = kubernetes_namespace.kafka.metadata[0].name

  values = [
    <<EOF
        replicaCount: 3
        resources:
        requests:
            memory: "1Gi"
            cpu: "500m"
        limits:
            memory: "2Gi"
            cpu: "1"
        EOF
  ]

  # depends_on =  [kubernetes_namespace.kafka]
  depends_on = [module.eks, kubernetes_namespace.kafka]
}
