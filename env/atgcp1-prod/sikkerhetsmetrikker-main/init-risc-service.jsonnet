local application = import '../../../applications/init-risc-service.libsonnet';
local version = import 'image-url-init-risc-service';

application(
    env='prod',
    version=version,
    clientId='<CLIENT_ID>',
    gsmProjectId='<GSM_PROJECT_ID>',
)