local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-db-secret') {
  secrets: [
    {
      fromSecret: 'spring-datasource-username',
      toKey: 'spring.datasource.username',
    },
    {
      fromSecret: 'spring-datasource-password',
      toKey: 'spring.datasource.password',
    },
  ],
  metadata+: {
    annotations: {
      'argocd.argoproj.io/sync-wave': '-1',
    },
  },
}
