import boto3
import datetime
import os

def lambda_handler(event, context):
    print("Iniciando snapshot de RDS...")  # <- este log aparecerá

    rds = boto3.client('rds')
    instance_id = os.environ['RDS_INSTANCE_ID']

    timestamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%d-%H-%M')
    snapshot_id = f"{instance_id}-snapshot-{timestamp}"

    print(f"Creando snapshot: {snapshot_id}...")

    rds.create_db_snapshot(
        DBInstanceIdentifier=instance_id,
        DBSnapshotIdentifier=snapshot_id
    )

    print("Snapshot creado correctamente")

    return {
        'statusCode': 200,
        'body': f"Snapshot {snapshot_id} creado con éxito"
    }
