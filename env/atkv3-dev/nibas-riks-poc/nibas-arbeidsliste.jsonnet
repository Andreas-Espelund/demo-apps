local arbeidsliste = import '../../../applications/nibas-arbeidsliste.libsonnet';
local databases = import '../databases.libsonnet';
local namespace = import 'namespace';
local version = import 'nibas-arbeidsliste-version';


arbeidsliste(
  version=version,
  ingress='nibas-arbeidsliste-' + namespace + '.atkv3-dev.<INTERNAL_DOMAIN>',
  spring_profiles='prod',
  service_account='<GCP_SERVICE_ACCOUNT>',
  db_host=databases.nibas.host,
  db_ip=databases.nibas.ip,
  namespace=namespace,
)
