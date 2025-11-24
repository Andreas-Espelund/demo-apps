local StedsnavnJobbserver = import '../../../applications/stedsnavnjobbserver.libsonnet';
local stedsnavn = import '../../../lib/stedsnavn-libsonnet/v1/stedsnavn.libsonnet';
local database = (import '../../../databases/oracle-databases.libsonnet').utils.getDatabase('ssrprod');

local config = import 'config.libsonnet';
local fileshare = config.common.fileshare;

local appname = 'stedsnavnjobbserver';

StedsnavnJobbserver(
  image=import 'stedsnavn-jobbserver-version',
  replicas=if database.status == 'up' then 1 else 0,
  configAndSecrets=config.stedsnavnjobbserver,
  logbackXmlStr=importstr 'stedsnavn-jobbserver/logback.xml',
  worstCaseShutdownSeconds=std.parseInt(config.stedsnavnjobbserver.config.STEDSNAVN_SHUTDOWN_TIMEOUT_SECONDS),
  tracingRatio=0.0,
  ingresses=['ssr-prod-jobbserver.atkv3-prod.<INTERNAL_DOMAIN>'],
  java_ops=['--add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED'],
)

//Access Policies
+ stedsnavn.appAndObjects.accessPolicies.outbound.oracle('<ORACLE_HOST>', '<ORACLE_IP>')
+ stedsnavn.appAndObjects.accessPolicies.outbound.http('<GRAPH_API_HOST>')
+ stedsnavn.appAndObjects.accessPolicies.outbound.http('<LOGIN_HOST>')

//Mounting of volumes for lucene
+ stedsnavn.appAndObjects.FileFrom({
  persistentVolumeClaim: fileshare.lucene.name,
  mountPath: fileshare.lucene.path,
})
