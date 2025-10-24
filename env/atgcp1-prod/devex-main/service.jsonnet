local service = import '../../../applications/service.libsonnet';

service(
  name='backup-service',
  env='prod',
  version='1.15.3'
)
