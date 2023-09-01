## Introduction
Este repositorio contiene un recopilado de elementos que pueden ser usados como template en la creación de un cluster de
kubernetes en EKS Fargate

## Qué es Kubernetes?
Kubernetes es un sistema de gestión de contenedores de aplicaciones. Se utiliza para automatizar la implementación, escalado y gestión de aplicaciones en contenedores. Fue desarrollado por Google y ha sido donado a la comunidad de código abierto.

Kubernetes permite a los desarrolladores describir la estructura de sus aplicaciones y sus requisitos en forma de recursos de Kubernetes, como pods, servicios y volúmenes. A partir de estas descripciones, Kubernetes se encarga de implementar y gestionar la ejecución de las aplicaciones en un clúster de servidores. Esto incluye la gestión de la disponibilidad, el escalado y la actualización de las aplicaciones.

Kubernetes es una tecnología ampliamente utilizada en la industria y es compatible con una amplia gama de plataformas, incluyendo la nube pública y privada, así como en los centros de datos. Es una solución escalable y flexible que permite a los equipos de desarrollo centrarse en el desarrollo de sus aplicaciones, mientras que Kubernetes se encarga de la gestión de la infraestructura subyacente.


## Qué es EKS?
EKS es el acrónimo de Amazon Elastic Container Service for Kubernetes, que es un servicio de nube gestionado por Amazon Web Services (AWS) que permite ejecutar aplicaciones empresariales en contenedores en clusters de Kubernetes. Con EKS, los usuarios pueden aprovechar la escalabilidad y la flexibilidad de Kubernetes para implementar y gestionar sus aplicaciones en la nube, mientras que AWS se encarga de la gestión de los componentes subyacentes, como la infraestructura de servidores y la configuración de seguridad.

EKS es una solución escalable, disponible y segura para implementar aplicaciones en contenedores en la nube, lo que permite a los equipos de desarrollo centrarse en el desarrollo y el funcionamiento de sus aplicaciones, en lugar de preocuparse por la gestión de la infraestructura subyacente.

## Qué es EKS Fargate?
EKS Fargate es una opción de ejecución para Amazon Elastic Kubernetes Service (EKS) que permite a los usuarios ejecutar aplicaciones de contenedor en el servidor de Amazon Web Services (AWS) sin la necesidad de administrar los servidores subyacentes. Con EKS Fargate, los usuarios pueden enfocarse en escribir y desplegar aplicaciones de contenedor, sin tener que preocuparse por la gestión de la infraestructura subyacente.

EKS Fargate es una opción para las personas que buscan una forma fácil y sin preocupaciones de ejecutar aplicaciones de contenedor en AWS, ya que toda la gestión de la infraestructura se realiza automáticamente por el servicio. Además, EKS Fargate es una opción ideal para aplicaciones de contenedor que requieren escalabilidad automática, alta disponibilidad y seguridad de nivel empresarial.

## Qué es EKS vs EKS Fargate?
Amazon Elastic Kubernetes Service (EKS) es un servicio de administración de Kubernetes en la nube proporcionado por Amazon Web Services (AWS). Con EKS, puede crear, administrar y escalar fácilmente aplicaciones de contenedores en un clúster de Kubernetes. EKS se encarga de la gestión y el mantenimiento de la infraestructura subyacente para ejecutar su clúster de Kubernetes, lo que significa que no tiene que preocuparse por la disponibilidad, el tamaño o la escalabilidad de los nodos de trabajo.

En cambio, Amazon Elastic Container Service for Kubernetes (EKS Fargate) es una implementación alternativa de EKS que utiliza Fargate de AWS como plataforma de ejecución de contenedores. En lugar de ejecutar los nodos de trabajo en instancias EC2, Fargate los ejecuta directamente en el nivel de infraestructura de la nube de AWS. Esto significa que no tiene que administrar o dimensionar manualmente la infraestructura subyacente y que puede enfocarse en la gestión y la escalabilidad de sus aplicaciones.

En resumen, EKS es una solución de Kubernetes en la nube que requiere una gestión activa de la infraestructura subyacente, mientras que EKS Fargate es una implementación más simplificada que proporciona una gestión automatizada de la infraestructura subyacente.

## Requsitos previos

Es necesario contar con los siguientes elementos:

* Cuenta de aws
* Docker

## Ejecución Completa

### Creación del ambiente de ejecución

1. Construir docker con dependencias
```shell
  docker build -t ci-cd-server .
```

2. Levantar el contenedor
```shell
  docker run -ti -d --name server ci-cd-server
```

3. Ingresar al contenedor
```shell
  docker exec -ti server sh
```

4. Configurar las credenciales de AWS
   1. Configurar AccessKey, SecretKey, Region y Formato de salida
```shell
  aws configure --profile nombrePerfil
```
      
### Ejecución del script python

Ejecutar el archivo python `generate_all.py` con las variables necesarias dentro del contenedor.

|   Parameter   | Type     | Description                                                 |
|:-------------:|:---------|:------------------------------------------------------------|
| `clusterName` | `string` | **Required**. Nombre del cluster                            |
|   `region`    | `string` | **Required**. Región donde se encuentra el cluster          |
|   `profile`   | `string` | **Required**. Perfil de consola con las credenciales de AWS |
|   `account`   | `number` | **Required**. Cuenta de AWS                                 |
| `subnetPrivA` | `string` | **Required**. ID de la subnet a (privada)                   |
| `subnetPrivB` | `string` | **Required**. ID de la subnet b (privada)                   |
| `subnetPubA`  | `string` | **Required**. ID de la subnet a (pública)                   |
| `subnetPubB`  | `string` | **Required**. ID de la subnet b (pública)                   |
|     `vpc`     | `string` | **Required**. ID de la VPC                                  |
| `policyName`  | `string` | **Required**. Nombre de la política de AWS                  |
| `policyFile`  | `string` | **Required**. Path de la política crear                     |
| `clusterName` | `string` | **Required**. Nombre del cluster                            |
|  `groupEKS`   | `string` | **Required**. Nombre del grupo dentro del EKS               |

```shell
  python3 ./generate_all.py \
  --clusterName "value" \
  --region "us-east-1" \
  --profile "value" \
  --account 1234567890 \
  --subnetPrivA "subnet-1234567890" \
  --subnetPrivB "subnet-1234567890" \
  --subnetPubA "subnet-1234567890" \
  --subnetPubB "subnet-1234567890" \
  --vpc "vpc-1234567890" \
  --groupName "EKS-Managers-TEST-CHALLENGE" \
  --userName "EKS-MANAGER-TEST-CHALLENGE" \
  --policyName "AmazonEKSManagerTEST-CHALLENGEPolicy" \
  --policyFile "AmazonEKSManagerTEST-CHALLENGEPolicy.json" \
  --groupEKS "manager-TEST-CHALLENGE" 
  # Sustituír TEST-CHALLENGE en los útlimos 5 params
```
### Qué se creará?

1. Cluster de kubernetes tipo fargate
2. Se agregarán tags a las subnets para poder ser visibles por el cluster de EKS 
   1. En caso de no contar con una VPC checar la sección de [Crear VPC](VPC)
3. Se crearán cuentas de servicio en el cluster de tipo manager y así no usar la cuenta owner
4. Se agregará el Ingress Controller de AWS para gestionar los servicios de tipo Load Balancer
5. Se creará una aplicación de prueba (nginx) para validar que el cluster está correctamente configurado
6. Se conectará el cluster con CloudWatch para logging y metrics



### Validación

1. Validar en la consola de AWS que se creó el cluster.
2. Abrir en un navegador el `ADDRESS` para corroborar que el despliegue fue exitoso.


## Secciones
* [Creación del Cluster](CreateCluster)
* [Roles (RBAC)](Roles)
* [Aplicación de ejemplo](ExampleApp)
* [Logging](Logging)



## Authors

- [Jesus Quevedo](https://www.github.com/jquevedo1196)
