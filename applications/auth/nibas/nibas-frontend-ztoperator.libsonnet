local common_entra_ztoperator = import '../common/entra-ztoperator.libsonnet';
local authConstants = import './constants.jsonnet';

function(namespace, entraidClientId) [
  common_entra_ztoperator('nibas-frontend', namespace, entraidClientId) + {
    spec+: {
      outputClaimToHeaders: [
        { claim: 'name', header: 'X-Auth-Name' },
      ],
      autoLogin: {
        enabled: true,
        logoutPath: authConstants.logoutPath,
        redirectPath: authConstants.replyPath,
        scopes: [entraidClientId + '/.default'],
      },
      oAuthCredentials: {
        clientIDKey: 'AZURE_APP_CLIENT_ID',
        clientSecretKey: 'AZURE_APP_CLIENT_SECRET',
        secretRef: authConstants.azureAdApplicationSecretName,
      },
    },
  },
]
