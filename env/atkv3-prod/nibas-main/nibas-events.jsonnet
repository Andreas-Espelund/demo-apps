local events = import '../../../applications/nibas-events.libsonnet';
local version = import 'nibas-events-version';
local databases = import '../databases.libsonnet';

events(
  version=version,
  ingress='nibas-events.atkv3-prod.<INTERNAL_DOMAIN>',
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibasEvent.host,
  db_ip=databases.nibasEvent.ip,
)