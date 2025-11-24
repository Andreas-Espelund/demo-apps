local application = import '../../../applications/security-champion-api.libsonnet';
local version = import 'image-url-security-champion-api';

application(
  version=version,
  env='dev',
  gsmProjectId='<GSM_PROJECT_ID>',
  databaseHost='<DATABASE_HOST>',
)
