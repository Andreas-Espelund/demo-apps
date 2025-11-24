local cypress = import '../../../applications/nibas-cypress-job.libsonnet';
local databases = import '../databases.libsonnet';
local version = import 'nibas-cypress-version';

cypress(
  version=version,
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibasE2e.host,
  db_ip=databases.nibasE2e.ip,
)
