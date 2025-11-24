local common_entra_ztoperator = import '../common/entra-ztoperator.libsonnet';

function(namespace, entraidClientId) [
  common_entra_ztoperator('nibas-backend', namespace, entraidClientId) + {
    spec+: {
      ignoreAuthRules: [{
        paths: ['/v1/ekstern/*', '/actuator/health/*', '/actuator/prometheus', '/api-docs*', '/swagger-ui*'],
      }],
    },
  },
]
