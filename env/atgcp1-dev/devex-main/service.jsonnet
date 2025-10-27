local service = import '../../../applications/service.libsonnet';

service(
  name='backup-service',
  env='dev',
  version='2.20.3'
)
