local service = import '../../../applications/service.libsonnet';

service(
  name='database-service',
  env='dev',
  version='1.14.2'
)
