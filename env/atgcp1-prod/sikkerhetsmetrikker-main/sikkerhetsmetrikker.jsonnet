local application = import '../../../applications/sikkerhetsmetrikker.libsonnet';
local gcpAuth = import '../../../utils/gcpAuth.libsonnet';
local version = import 'image-url-sikkerhetsmetrikker';

application(
  env='prod',
  name='sikkerhetsmetrikker',
  version=version,
  gcpAuth=gcpAuth(
    serviceAccount='<SERVICE_ACCOUNT>',
  ),
  clientId='<CLIENT_ID>',
  gsmProjectId='<GSM_PROJECT_ID>',
  dbHost='<DB_HOST>',
)
