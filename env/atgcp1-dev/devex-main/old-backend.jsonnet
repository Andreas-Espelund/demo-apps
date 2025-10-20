local application = import '../../../applications/old-backend.libsonnet';

local cloudSqlConfig = import '../../../utils/cloudSql.libsonnet';
local version = '1.2.3.4';

application(
  env='dev',
  version=version,
  gsmProjectId='devex-dev-1234',
  cloudSqlConfig={
    connectionName: 'devex-dev-1234:europe-north1:devex-pg-01-dev',
    ip: '10.10.10.10',
    serviceAccount: 'devex-pg-01-demo@devex-dev-1234.iam.gserviceaccount.com',
  },
  dbUser='devex-pg-01-demo@devex-dev-1234.iam',
  replyUrl='https://devex.atgcp1-dev.host.com/callback'
)
