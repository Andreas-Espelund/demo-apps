local rosaService = import '../../../applications/rosa.libsonnet';
local version = import 'image-url-rosa';

rosaService(
  version=version,
  env='dev',
  gsmProjectId='<GSM_PROJECT_ID>',
  databaseHost='<DATABASE_HOST>',
  databasePort=5432,
)
