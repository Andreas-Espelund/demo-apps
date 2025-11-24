local valgdata = import '../../../applications/valgdata.libsonnet';
local image = import 'smia-valgdata-version';


valgdata(
  image=image,
  valgdata_secret='<VALGDATA_SECRET_NAME>',
  valgdata_bucket='<VALGDATA_BUCKET>',
) {
  spec+: {
    ingresses: [
      'valgdata.atkv3-dev.<INTERNAL_DOMAIN>',
    ],
  },
}
