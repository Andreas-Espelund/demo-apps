local kommuneinfo = import '../../../applications/kommuneinfo.libsonnet';
local databases = import '../databases.libsonnet';
local image = import 'kommuneinfo-version';

kommuneinfo(
  image=image,
  db_host=databases.kommuneinfo.host,
  db_ip=databases.kommuneinfo.ip,
) {
  spec+: {
    replicas: {
      min: 2,
      max: 5,
    },
    env: [
      {
        name: 'KOMMUNEINFO_INGRESS',
        value: '<PUBLIC_API_DOMAIN>',
      },
    ],
  },
}
