## Mandar logs de los pods a CloudWatch con FluentBit

### Creación de roles dentro del cluster para usuarios IAM

Ejecutar el script `ClusterLogging.sh` con las variables deseadas.

|   Parameter   | Type     | Description                                                  |
|:-------------:|:---------|:-------------------------------------------------------------|
| `clusterName` | `string` | **Required**. Nombre del cluster                             |
|   `profile`   | `string` | **Required**. Perfil de consola con las credenciales de AWS  |
|   `account`   | `number` | **Required**. Cuenta de AWS                                  |
|  `roleName`   | `string` | **Required**. Nombre del FargatePodExecutionRole del cluster |

```shell
  sh ./ClusterLogging.sh \
  --clusterName "value" \
  --profile "value" \
  --account 1234567890 \
  --roleName "eksctl-CLUSTER-NAME-cluster-FargatePodExecutionRole-AAAAAAAAA"
```

### Validación

1. Validar que el ConfigMap se creó correctamente.
```shell
  kubectl -n aws-observability get cm
```

2. Borrar un pod, para que se genere nuevamente y empiece a mandar logs a CloudWatch.

## Authors

- [Jesus Quevedo](https://www.github.com/jquevedo1196)

