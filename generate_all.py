import logging
import argparse
import os
import boto3
import time
from kubernetes import client, config
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)


def list_roles(count, iam):
    """
    Lists the specified number of roles for the account.

    :param iam: AWS iam resource with a specific profile
    :param count: The number of roles to list.
    return list of roles
    """
    try:
        roles = list(iam.roles.limit(count=count))
        for role in roles:
            logger.info(f"Role: {role.name}")
    except ClientError:
        logger.exception("Couldn't list roles for the account.")
        raise
    else:
        return roles


def get_vars():
    """
    Esta función recupera y valida todos los parámetros de la ejecución del presente documento
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('--clusterName', help="Required. Nombre del cluster", type=str, required=True)
    parser.add_argument('--region', help="Required. Región donde se encuentra el cluster", type=str, required=True)
    parser.add_argument('--profile', help="Required. Perfil de consola con las credenciales de AWS", type=str,
                        required=True)
    parser.add_argument('--account', help="Required. Cuenta de AWS", type=int, required=True)
    parser.add_argument('--subnetPrivA', help="Required. ID de la subnet a (privada)", type=str, required=True)
    parser.add_argument('--subnetPrivB', help="Required. ID de la subnet b (privada)", type=str, required=True)
    parser.add_argument('--subnetPubA', help="Required. ID de la subnet a (publica)", type=str, required=True)
    parser.add_argument('--subnetPubB', help="Required. ID de la subnet b (publica)", type=str, required=True)
    parser.add_argument('--vpc', help="ID de la VPC", type=str, required=True)
    parser.add_argument('--groupName', help="Required. Nombre del grupo de usuarios a crear", type=str, required=False)
    parser.add_argument('--userName', help="Required. Nombre del usuario a crear", type=str, required=True)
    parser.add_argument('--policyName', help="Required. Nombre de la política de AWS", type=str, required=True)
    parser.add_argument('--policyFile', help="Required. Path de la política crear", type=str, required=True)
    parser.add_argument('--groupEKS', help="Required. Nombre del grupo dentro del EKS", type=str, required=True)
    return parser.parse_args()


def main():
    args = get_vars()

    print(f"Ejecutando el script CreateAndConfigureCluster...")
    os.system(f'cd ./CreateCluster && sh CreateAndConfigureCluster.sh \\'
              f'--clusterName "{args.clusterName}" \\'
              f'--region "{args.region}" \\'
              f'--profile "{args.profile}" \\'
              f'--account {args.account} \\'
              f'--subnetPrivA "{args.subnetPrivA}" \\'
              f'--subnetPrivB "{args.subnetPrivB}" \\'
              f'--subnetPubA "{args.subnetPubA}" \\'
              f'--subnetPubB "{args.subnetPubB}" \\'
              f'--vpc "{args.vpc}"')

    print(f"Ejecutando el script CreateUserAndRoles...")
    os.system(f'cd ./Roles && sh CreateUserAndRoles.sh \\'
              f'--region "{args.region}" \\'
              f'--profile "{args.profile}" \\'
              f'--groupName "{args.groupName}" \\'
              f'--userName {args.userName} \\'
              f'--policyName "{args.policyName}" \\'
              f'--policyFile "{args.policyFile}" \\'
              f'--clusterName "{args.clusterName}" \\'
              f'--account "{args.account}" \\'
              f'--groupEKS "{args.groupEKS}"')

    session = boto3.session.Session(profile_name=args.profile)
    iam = session.resource('iam')
    roles = list_roles(100, iam)
    fargateRole = None
    print(f"Encontramos el role {fargateRole}")
    for role in roles:
        if f"eksctl-{args.clusterName}" in role.name and (
                "ServiceRole" in role.name or "FargatePodExecutionRole" in role.name):
            fargateRole = role.name
            print(fargateRole)
            print(f"Ejecutando el script ClusterLogging...")
            os.system(f'cd ./Logging && sh ClusterLogging.sh \\'
                      f'--clusterName "{args.clusterName}" \\'
                      f'--profile "{args.profile}" \\'
                      f'--account "{args.account}" \\'
                      f'--roleName {fargateRole}')

    count = 0
    config.load_kube_config()
    api = client.AppsV1Api()
    while count <= 10:
        print("Esperando controller...")
        deployment = api.read_namespaced_deployment(name='aws-load-balancer-controller', namespace='kube-system')
        if deployment.status.available_replicas > 0 and deployment.status.ready_replicas > 0:
            print(f"Ejecutando el script CreateDemoApp...")
            os.system(f'cd ./ExampleApp && sh CreateDemoApp.sh \\'
                      f'--clusterName "{args.clusterName}" \\'
                      f'--region "{args.region}" \\'
                      f'--profile "{args.profile}"')
            break
        else:
            count += 1
            print(f"ERROR: No se encontró el controller aws-load-balancer-controller intento {count} de 10")
            time.sleep(30)


if __name__ == "__main__":
    main()
