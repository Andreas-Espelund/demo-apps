local frontend = import '../../../applications/nibas-frontend.libsonnet';
local namespace = import 'namespace';
local version = import 'nibas-frontend-version';

frontend(
  version=version,
  ingress=['nibas-e2e.atkv3-dev.<INTERNAL_DOMAIN>'],
  secret='nibas-e2e-frontend-secret',
  namespace=namespace
)
