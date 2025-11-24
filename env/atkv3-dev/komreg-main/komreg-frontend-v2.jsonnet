local frontend = import '../../../applications/komreg-frontend-v2.libsonnet';
local version = import 'komreg-frontend-v2-version';
local namespace = import 'namespace';

frontend(
    version=version,
    environment='dev',
    namespace=namespace
)
