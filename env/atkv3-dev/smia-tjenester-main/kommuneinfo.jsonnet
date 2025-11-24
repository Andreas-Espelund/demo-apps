local kommuneinfo = import '../../../applications/kommuneinfo.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'kommuneinfo-version';

local ingress = 'kommuneinfo.atkv3-dev.<INTERNAL_DOMAIN>';

kommuneinfo(
  image=image,
  db_host=databases.kommuneinfo.host,
  db_ip=databases.kommuneinfo.ip,
) {
  spec+: {
    env: [
      {
        name: 'KOMMUNEINFO_INGRESS',
        value: ingress,
      },
    ],
    ingresses: [
      ingress,
    ],
  },
}
