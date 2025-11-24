function(app, namespace, entraidClientId) {
  apiVersion: 'ztoperator.kartverket.no/v1alpha1',
  kind: 'AuthPolicy',
  metadata: {
    name: app + '-auth-policy',
    namespace: namespace,
  },
  spec: {
    enabled: true,
    selector: {
      matchLabels: {
        app: app,
      },
    },
    wellKnownURI: 'https://login.microsoftonline.com/<TENANT_ID>/v2.0/.well-known/openid-configuration',
    audience: [entraidClientId],
  },
}
