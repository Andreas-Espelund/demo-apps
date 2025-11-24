local common_entra_ztoperator = import '../common/entra-ztoperator.libsonnet';
local authConstants = import './constants.jsonnet';

function(app, namespace, entraidClientId) [
  common_entra_ztoperator(app, namespace, entraidClientId) + {
    spec+: {
      ignoreAuthRules: [{
        paths: ['/actuator/*'],
      }],
    },
  },
]
