local job = import '../../../applications/nibas-proddump-backup.libsonnet';
local version = import 'nibas-db-copy-prod-to-backup-version';

job(
  version=version,
  service_account='<GCP_SERVICE_ACCOUNT>',
  source_db={ host: '<SOURCE_DB_HOST>', ip:'<SOURCE_DB_IP>' },
  target_db={ host: '<TARGET_DB_HOST>', ip:'<TARGET_DB_IP>' },
)
