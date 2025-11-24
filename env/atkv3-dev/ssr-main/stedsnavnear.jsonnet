local StedsnavnEar = import '../../../applications/stedsnavnear.libsonnet';
local stedsnavn = import '../../../lib/stedsnavn-libsonnet/v1/stedsnavn.libsonnet';
local database = (import '../../../databases/oracle-databases.libsonnet').utils.getDatabase('ssrtest');

local config = import 'config.libsonnet';
local fileshare = config.common.fileshare;

local appname = 'stedsnavnear';

StedsnavnEar(
  image=import 'stedsnavn-ear-version',
  replicas=if database.status == 'up' then 2 else 0,
  configAndSecrets=config.stedsnavnear,
  logbackXmlStr=importstr 'stedsnavn-ear/logback.xml',
  worstCaseShutdownSeconds=std.parseInt(config.stedsnavnear.config.STEDSNAVN_SHUTDOWN_TIMEOUT_SECONDS),
  tracingRatio=0.0,
  ingresses=['<STEDSNAVN_INGRESS>'],
  java_ops=['--add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED'],
)

//Access Policies
+ stedsnavn.appAndObjects.accessPolicies.outbound.http('<WMS_HOST>')
+ stedsnavn.appAndObjects.accessPolicies.outbound.http('<GRAPH_API_HOST>')
+ stedsnavn.appAndObjects.accessPolicies.outbound.http('<LOGIN_HOST>')
+ stedsnavn.appAndObjects.accessPolicies.outbound.oracle('<ORACLE_HOST>', '<ORACLE_IP>')

//Mounting of volumes for lucene
+ stedsnavn.appAndObjects.FileFrom({
  persistentVolumeClaim: fileshare.lucene.name,
  mountPath: fileshare.lucene.path,
})
