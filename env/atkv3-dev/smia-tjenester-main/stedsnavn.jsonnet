local stedsnavn = import '../../../applications/stedsnavn.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'stedsnavn-version';

local ingress = 'stedsnavn-api.atkv3-dev.<INTERNAL_DOMAIN>';

stedsnavn(
  image=image,
  db_host=databases.stedsnavn.host,
  db_ip=databases.stedsnavn.ip,
) {
  spec+: {
    env: [
      {
        name: 'STEDSNAVN_INGRESS',
        value: ingress,
      },
    ],
    ingresses: [
      ingress,
    ],
  },
}
