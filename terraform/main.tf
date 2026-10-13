provider "local" {}

# 1. Simular la creacion de un servidor (como si fuera una instancia EC2 de AWS)
resource "local_file" "servidor_produccion" {
  content  = "Servidor Debian 12 - IP: 192.168.1.45"
  filename = "${path.module}/servidor_simulado.txt"
}

# 2. Puente de conexion entre Terraform y Ansible:
#    Terraform genera el inventario hosts.ini que Ansible necesita para saber
#    sobre que maquina debe trabajar.
resource "local_file" "generar_inventario_ansible" {
  content  = <<EOF
[produccion]
localhost ansible_connection=local

[produccion:vars]
entorno=produccion_critica
EOF
  filename = "../ansible/hosts.ini"

  # Obliga a Terraform a crear primero el servidor y despues el inventario
  depends_on = [local_file.servidor_produccion]
}
