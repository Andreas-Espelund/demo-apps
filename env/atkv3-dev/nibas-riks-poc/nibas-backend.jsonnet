local backend = import '../../../applications/nibas-backend.libsonnet';
local databases = import '../databases.libsonnet';
local namespace = import 'namespace';
local version = import 'nibas-backend-version';

backend(
  version=version,
  ingress='nibas-api-' + namespace + '.atkv3-dev.<INTERNAL_DOMAIN>',
  spring_profiles=if namespace == 'nibas-main' then 'dev-main' else 'dev',
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibas.host,
  db_ip=databases.nibas.ip,
  namespace=namespace,
  db_name=if namespace == 'nibas-main' then 'nibas' else namespace,
)
