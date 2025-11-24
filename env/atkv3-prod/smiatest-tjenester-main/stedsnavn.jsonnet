local stedsnavn = import '../../../applications/stedsnavn.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'stedsnavn-version';

stedsnavn(
  image=image,
  db_host=databases.stedsnavn.host,
  db_ip=databases.stedsnavn.ip,
) {
  spec+: {
    env: [
      {
        name: 'STEDSNAVN_INGRESS',
        value: '<TEST_API_DOMAIN>',
      },
    ],
  },
}
