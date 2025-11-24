function(serverName) {
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Routing',
  metadata: {
    name: 'aal-routing',
  },
  spec: {
    hostname: serverName,
    routes: [
      {
        pathPrefix: '/backend',
        targetApp: 'aal-register',
        rewriteUri: false,
      },
      {
        pathPrefix: '/',
        targetApp: 'aal-klient',
        rewriteUri: false,
      },
    ],
  },
}
