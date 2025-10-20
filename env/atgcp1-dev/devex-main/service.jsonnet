local service = import '../../../applications/service.libsonnet';

service(
  name='database-service',
  env='prod',
  version='1.14.2'
)
