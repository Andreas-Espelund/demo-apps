local service = import '../../../applications/service.libsonnet';

service(
  name='backup-service',
  env='dev',
  version='1.15.2'
)
