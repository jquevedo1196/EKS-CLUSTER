## EKS RBAC (Roles)

### Creación de roles dentro del cluster para usuarios IAM

Ejecutar el script `CreateUserAndRoles.sh` con las variables deseadas.

|   Parameter   | Type     | Description                                                 |
|:-------------:|:---------|:------------------------------------------------------------|
|   `region`    | `string` | **Required**. Región donde se encuentra el cluster          |
|   `profile`   | `string` | **Required**. Perfil de consola con las credenciales de AWS |
|  `groupName`  | `string` | **Required**. Nombre del grupo de usuarios a crear          |
|  `userName`   | `string` | **Required**. Nombre del usuario a crear                    |
| `policyName`  | `string` | **Required**. Nombre de la política de AWS                  |
| `policyFile`  | `string` | **Required**. Path de la política crear                     |
| `clusterName` | `string` | **Required**. Nombre del cluster                            |
|   `account`   | `number` | **Required**. Cuenta de AWS                                 |
|  `groupEKS`   | `string` | **Required**. Nombre del grupo dentro del EKS               |

```shell
  sh ./CreateUserAndRoles.sh \
  --region "us-east-1" \
  --profile "value" \
  --groupName "EKS-Managers" \
  --userName "EKS-MANAGER" \
  --policyName "AmazonEKSManagerPolicy" \
  --policyFile "AmazonEKSManagerPolicy.json" \
  --clusterName "value" \
  --account 1234567890 \
  --groupEKS "manager"
```

Después de su ejecución, se generará un archivo llamado `credentials`. Este archivo contendrá las credenciales
del usuario de AWS generado con el rol de _Manager_.

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

