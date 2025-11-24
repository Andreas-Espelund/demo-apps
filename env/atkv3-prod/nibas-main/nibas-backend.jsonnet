local backend = import '../../../applications/nibas-backend.libsonnet';
local databases = import '../databases.libsonnet';
local version = import 'nibas-backend-version';

backend(
  version=version,
  ingress='nibas-api.atkv3-prod.<INTERNAL_DOMAIN>',
  spring_profiles='prod',
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibas.host,
  db_ip=databases.nibas.ip,
)
