## Creación de cluster EKS Fargate

### Ejecución del script

Ejecutar el script `CreateAndConfigureCluster.sh` con las variables necesarias.

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

```shell
  sh ./CreateAndConfigureCluster.sh \
  --clusterName "value" \
  --region "us-east-1" \
  --profile "value" \
  --account 1234567890 \
  --subnetPrivA "subnet-1234567890" \
  --subnetPrivB "subnet-1234567890" \
  --subnetPubA "subnet-1234567890" \
  --subnetPubB "subnet-1234567890" \
  --vpc "vpc-1234567890"
```

### Validación

1. Validar en la consola de AWS que se creó el cluster.
2. Comprobar que se actualizó el contexto de kubectl ejecutando el comando:

```shell
  kubectl get ns
```

3. Crear un servicio de prueba para validar que las subnets fueron correctamente configuradas.
   Leer [ExampleApp](../ExampleApp/)

## Authors

- [Jesus Quevedo](https://www.github.com/jquevedo1196)

