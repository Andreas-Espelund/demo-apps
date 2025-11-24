
local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-events-apikeys-secret') {
    secrets: [
      {
        fromSecret: 'api-key-publisher',
        toKey: 'api.key.publisher',
      },
      {
        fromSecret: 'api-key-consumer',
        toKey: 'api.key.consumer',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
}
