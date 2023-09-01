## VPC and Tags

### Creación de VPC, subnets y tags

Ejecutar el script `CreateVPC.sh` con las variables deseadas.

|   Parameter   | Type     | Description                                                 |
|:-------------:|:---------|:------------------------------------------------------------|
|   `region`    | `string` | **Required**. Región donde se encuentra el cluster          |
|   `profile`   | `string` | **Required**. Perfil de consola con las credenciales de AWS |
| `clusterName` | `string` | **Required**. Nombre del cluster                            |


```shell
  sh ./CreateVPC.sh \
  --region "us-east-1" \
  --profile "value" \
  --clusterName "value"
```

Después de su ejecución, arrojará los outputs con los nombres de las VPC creadas.

### Acceder con el usuario creado al cluster

Se deberá agregar el perfil a la configuración de AWS.

1. Copiar el archivo `credentials`, en la ruta `~/aws/`.
2. Agregar el contexto de kubernetes a la cuenta agregada.

```shell
  aws eks --region REGION update-kubeconfig --name CLUSTER_NAME --profile manager
```

### Validación

Se deberá comprobar que es correcto ejecutando el comando:

```shell
  kubectl get ns
```

## Authors

- [Jesus Quevedo](https://www.github.com/jquevedo1196)

