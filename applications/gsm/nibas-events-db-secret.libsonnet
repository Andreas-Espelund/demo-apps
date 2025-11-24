local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-events-db-secret') {
  secrets: [
    {
      fromSecret: 'nibas-events-db-username',
      toKey: 'spring.datasource.username',
    },
    {
      fromSecret: 'nibas-events-db-password',
      toKey: 'spring.datasource.password',
    },
  ],
  metadata+: {
    annotations: {
      'argocd.argoproj.io/sync-wave': '-1',
    },
  },
}
