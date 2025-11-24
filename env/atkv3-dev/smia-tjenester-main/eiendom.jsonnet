local eiendom = import '../../../applications/eiendom.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'eiendom-version';

local ingress = 'eiendom.atkv3-dev.<INTERNAL_DOMAIN>';

eiendom(
  image=image,
  db_host=databases.eiendom.host,
  db_ip=databases.eiendom.ip,
) {
  spec+: {
    env: [
      {
        name: 'EIENDOM_INGRESS',
        value: ingress,
      },
    ],
    ingresses: [
      ingress,
    ],
  },
}
