local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-e2e-secret') {
  secrets: [
    {
      fromSecret: 'slack-oauth-token',
      toKey: 'SLACK_OAUTH_TOKEN',
    },
    {
      fromSecret: 'nibas-e2e-service-account-key',
      toKey: 'NIBAS_E2E_SERVICE_ACCOUNT_KEY',
    },
    {
      fromSecret: 'nibas-e2e-db-uri',
      toKey: 'NIBAS_E2E_DB_URI',
    },
  ],
  metadata+: {
    annotations: {
      'argocd.argoproj.io/sync-wave': '-1',
    },
  },
}
