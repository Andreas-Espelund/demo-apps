local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-arbeidsliste-secret') {
  secrets: [
    {
      fromSecret: 'nibas-arbeidsliste-api-key',
      toKey: 'nibas.arbeidsliste.api-key',
    },
    {
      fromSecret: 'nibas-arbeidsliste-db-username',
      toKey: 'spring.datasource.username',
    },
    {
      fromSecret: 'nibas-arbeidsliste-db-password',
      toKey: 'spring.datasource.password',
    },
    {
      fromSecret: 'matrikkelen-username',
      toKey: 'MATRIKKELEN_USERNAME',
    },
    {
      fromSecret: 'matrikkelen-password',
      toKey: 'MATRIKKELEN_PASSWORD',
    },
  ],
  metadata+: {
    annotations: {
      'argocd.argoproj.io/sync-wave': '-1',
    },
  },
}
