local stedsnavn = import '../../../applications/stedsnavn.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'stedsnavn-version';

stedsnavn(
  image=image,
  db_host=databases.stedsnavn.host,
  db_ip=databases.stedsnavn.ip,
) {
  spec+: {
    replicas: {
      min: 2,
      max: 5,
    },
    env: [
      {
        name: 'STEDSNAVN_INGRESS',
        value: '<PUBLIC_API_DOMAIN>',
      },
    ],
  },
}
