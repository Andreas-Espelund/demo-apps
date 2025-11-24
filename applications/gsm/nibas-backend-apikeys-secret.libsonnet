local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-backend-apikeys-secret') {
  secrets: [
    {
      fromSecret: 'api-key-matrikkel',
      toKey: 'api.key.matrikkel',
    },
    {
      fromSecret: 'nibas-arbeidsliste-api-key',
      toKey: 'nibas.arbeidsliste.api-key',
    },
  ],
}
