local eiendom = import '../../../applications/eiendom.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'eiendom-version';

eiendom(
  image=image,
  db_host=databases.eiendom.host,
  db_ip=databases.eiendom.ip,
) {
  spec+: {
    replicas: {
      min: 3,
      max: 5,
    },
    env: [
      {
        name: 'EIENDOM_INGRESS',
        value: '<PUBLIC_API_DOMAIN>',
      },
    ],
  },
}
