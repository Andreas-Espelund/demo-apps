local backend = import '../../../applications/komreg-backend.libsonnet';
local version = import 'komreg-backend-version';

backend(
    version=version,
    environment='dev',
    project_id='<GCP_PROJECT_ID>',
    matrikkel_db_host='<MATRIKKEL_DB_HOST>',
    matrikkel_db_ip='<MATRIKKEL_DB_IP>',
    komreg_db_host='<KOMREG_DB_HOST>',
    komreg_db_ip='<KOMREG_DB_IP>'
)
