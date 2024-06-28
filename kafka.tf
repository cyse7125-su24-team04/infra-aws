resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  namespace  = kubernetes_namespace.kafka.metadata[0].name

  values = [
    <<EOF
    listeners:
      client:
        protocol: PLAINTEXT
      controller:
        protocol: PLAINTEXT
      interbroker:
        protocol: PLAINTEXT  
    provisioning:
      enabled: true
      replicationFactor: 3
      numPartitions: 3
    controller:
      persistence:
        size: 1Gi
      initContainerResources:
        requests:
          memory: "50Mi"
          cpu: "50m"
        limits:
          memory: "100Mi"
          cpu: "100m"
      resources:
        requests:
          memory: "500Mi"
          cpu: "100m"
        limits:
          memory: "850Mi"
          cpu: "1"
    EOF
  ]

  # depends_on =  [kubernetes_namespace.kafka]
  depends_on = [module.eks, kubernetes_namespace.kafka]
}

resource "helm_release" "postgres" {
  name       = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = kubernetes_namespace.webapp_cve_consumer.metadata[0].name

  values = [
    <<EOF
global:    
  postgresql:
    auth:
      postgresPassword: var.postgresPassword
      username: var.username
      password: var.password
      database: var.database
    service:
      ports:
        postgresql: var.postgresqlPort
primary:        
  resourcesPreset: "medium"
EOF
  ]

  depends_on = [module.eks, kubernetes_namespace.webapp_cve_consumer]
}
