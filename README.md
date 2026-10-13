# corporativo-gitops

Laboratorio del Módulo 2 del Diplomado en DevOps (Universidad Anáhuac Cancún).

Simula un pipeline de infraestructura como código donde Jenkins orquesta a
Terraform y a Ansible. No se crea infraestructura real: los recursos son
archivos de texto que representan un servidor y su inventario.

## Estructura

```
corporativo-gitops/
├── Jenkinsfile              Pipeline de 5 etapas
├── terraform/
│   └── main.tf              Aprovisiona el servidor simulado
├── ansible/
│   └── playbook.yml         Configura el servidor
└── evidencias/              Capturas de la ejecución
```

## Las cinco etapas del pipeline

1. **Auditoría de código.** Valida la sintaxis de Terraform y de Ansible antes
   de ejecutar nada.
2. **Planificación.** Terraform muestra qué recursos va a crear, sin crearlos.
3. **Aprobación manual.** El pipeline se detiene y espera la autorización de una
   persona. Es el control humano antes de tocar producción.
4. **Aprovisionamiento.** Terraform crea los recursos.
5. **Configuración.** Ansible configura el servidor recién creado.

## El puente entre Terraform y Ansible

Ansible necesita saber sobre qué máquina trabajar, y esa máquina no existe hasta
que Terraform la crea. Para resolverlo, Terraform genera el archivo
`ansible/hosts.ini` como parte de su ejecución.

La instrucción `depends_on` del archivo `main.tf` obliga a Terraform a crear
primero el servidor y después el inventario, en ese orden.

## Cómo ejecutarlo

Requisitos: Terraform, Ansible (vía WSL en Windows) y Jenkins.

Ejecución manual, sin Jenkins:

```powershell
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

cd ..\ansible
wsl ansible-playbook -i hosts.ini playbook.yml
```

Con Jenkins: crear un job de tipo Pipeline apuntando a este repositorio. El
`Jenkinsfile` se detecta automáticamente.

## Nota sobre el entorno

El `Jenkinsfile` usa `bat` y llama a Ansible con `wsl` porque está pensado para
un agente Jenkins sobre Windows. Ansible no se ejecuta de forma nativa en
Windows, por eso se invoca a través del subsistema de Linux.

En un agente Linux o macOS habría que reemplazar `bat` por `sh` y quitar el
prefijo `wsl`.

## Estado

El código del laboratorio está completo. Las evidencias de ejecución quedan
pendientes de cargar en la carpeta `evidencias/`.
