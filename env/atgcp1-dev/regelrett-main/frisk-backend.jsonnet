local application = import '../../../applications/frisk-backend.libsonnet';
local version = import 'image-url-frisk-backend';

application(
    env='dev',
    version=version,
    clientId='<CLIENT_ID>',
    gsmProjectId='<GSM_PROJECT_ID>',
    databaseHost='<DATABASE_HOST>',
)