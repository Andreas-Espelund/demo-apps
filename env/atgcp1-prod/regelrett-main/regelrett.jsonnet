local application = import '../../../applications/regelrett.libsonnet';
local cloudSqlConfig = import '../../../utils/cloudSql.libsonnet';
local gcpAuth = import '../../../utils/gcpAuth.libsonnet';
local version = import 'image-url-regelrett';

application(
  env='prod',
  version=version,
  gsmProjectId='<GSM_PROJECT_ID>',
  cloudSqlConfig=cloudSqlConfig(
    connectionName='<CONNECTION_NAME>',
    ip='<DB_IP>',
    serviceAccount='<SERVICE_ACCOUNT>',
  ),
  dbUser='<DB_USER>',
  replyUrl='<REPLY_URL>'
)
