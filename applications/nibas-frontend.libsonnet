local caddyConfig = import './common/caddy-frontend.libsonnet';

function(version, ingress, secret='nibas-frontend-secret', namespace='nibas-main') [
  caddyConfig(
    name='nibas-frontend',
    image=version,
    ingress=ingress,
    accessPolicy={
      outbound: {
        rules: [
          { application: 'nibas-backend', namespace: namespace },
        ],
        external: [
          { host: '<EXTERNAL_HOST_1>' },
          { host: '<EXTERNAL_HOST_2>' },
          { host: '<EXTERNAL_HOST_3>' },
          { host: '<EXTERNAL_HOST_4>' },
          { host: 'api.github.com' },
        ],
      },
    },
    env=[
      {
        name: 'BACKEND_HOST',
        value: 'nibas-backend.' + namespace + ':8080',
      },
    ],
    namespace=namespace,
  ) + {
    spec: super.spec + {
      envFrom: [
        { secret: secret },
      ],
    } + (if namespace == 'nibas-main' then {
           podSettings: {
             annotations: {
               'sidecar.istio.io/userVolume': std.manifestJson([
                 {
                   name: 'istio-oauth2',
                   secret: {
                     secretName: 'nibas-frontend-auth-policy-envoy-secret',
                   },
                 },
               ]),
               'sidecar.istio.io/userVolumeMount': std.manifestJson([
                 {
                   name: 'istio-oauth2',
                   mountPath: '/etc/istio/config',
                   readOnly: true,
                 },
               ]),
             },
           },
         } else {}),
  },
]
