local application = import '../../../applications/frisk-frontend.libsonnet';
local version = import 'image-url-frisk-frontend';

application(
    env='prod',
    version=version,
    VITE_CLIENT_ID='<VITE_CLIENT_ID>',
)