local backend = import '../../../applications/nibas-backend.libsonnet';
local databases = import '../databases.libsonnet';
local namespace = import 'namespace';
local version = import 'nibas-backend-version';

backend(
  version=version,
  ingress='nibas-e2e-api.atkv3-dev.<INTERNAL_DOMAIN>',
  spring_profiles='dev-main,eventsDisabled',
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibasE2e.host,
  db_ip=databases.nibasE2e.ip,
  nibas_db_secret='nibas-e2e-db-secret',
  namespace=namespace,
)
