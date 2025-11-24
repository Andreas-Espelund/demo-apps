local job = import '../../../applications/nibas-proddump.libsonnet';
local version = import 'nibas-db-copy-prod-to-dev-version';

job(
  version=version,
  service_account='<GCP_SERVICE_ACCOUNT>',
)
