local frontend = import '../../../applications/nibas-frontend.libsonnet';
local namespace = import 'namespace';
local version = import 'nibas-frontend-version';

frontend(
  version=version,
  ingress=[namespace + '.atkv3-dev.<INTERNAL_DOMAIN>'],
  namespace=namespace,
)
