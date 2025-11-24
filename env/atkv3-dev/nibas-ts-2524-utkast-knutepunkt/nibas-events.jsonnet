local events = import '../../../applications/nibas-events.libsonnet';
local databases = import '../databases.libsonnet';
local namespace = import 'namespace';
local version = import 'nibas-events-version';

events(
  version=version,
  ingress='nibas-events-' + namespace + '.atkv3-dev.<INTERNAL_DOMAIN>',
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibasEvent.host,
  db_ip=databases.nibasEvent.ip,
  namespace=namespace,
)
