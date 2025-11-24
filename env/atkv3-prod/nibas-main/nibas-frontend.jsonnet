local frontend = import '../../../applications/nibas-frontend.libsonnet';
local version = import 'nibas-frontend-version';

frontend(
  version=version,
  ingress=['nibas.<INTERNAL_DOMAIN>'],
)
