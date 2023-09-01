## Creación de una aplicación de prueba

Ejecutar el script `CreateDemoApp.sh` con las variables deseadas.

### Ejecución del script

|   Parameter   | Type     | Description                                                 |
|:-------------:|:---------|:------------------------------------------------------------|
| `clusterName` | `string` | **Required**. Nombre del cluster                            |
|   `region`    | `string` | **Required**. Región donde se encuentra el cluster          |
|   `profile`   | `string` | **Required**. Perfil de consola con las credenciales de AWS |

```shell
  sh ./CreateDemoApp.sh \
  --clusterName "value" \
  --region "us-east-1" \
  --profile "value"
```
**Nota: Antes de ejecutar el proceso, validar que el controller se encuentre ya desplegado.**
```shell
kubectl get pods -n kube-system -o wide
```

### Validación

1. Después de ejecutar el script se debe esperar unos 5 minutos antes de validar el despliegue con el siguiente comando:

```shell
  kubectl get -f .
```
**Nota: Si el proceso marcó "_Error from server (InternalError): error when creating "04.Ingress.yaml": Internal error 
occurred: failed calling webhook "vingress.elbv2.k8s.aws": failed to call webhook: 
Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1-ingress?timeout=10s": no 
endpoints available for service "aws-load-balancer-webhook-service"__. Se debe Realizar la validación del controller y volver a ejecutar el proceso.**
```shell
kubectl apply -f .
```


2. Abrir en un navegador el `ADDRESS` para corroborar que el despliegue fue exitoso.

## Authors

- [Jesus Quevedo](https://www.github.com/jquevedo1196)

