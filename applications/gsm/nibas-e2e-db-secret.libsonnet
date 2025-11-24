local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-e2e-db-secret') {
  secrets: [
    {
      fromSecret: 'spring-datasource-e2e-username',
      toKey: 'spring.datasource.username',
    },
    {
      fromSecret: 'spring-datasource-e2e-password',
      toKey: 'spring.datasource.password',
    },
    {
      fromSecret: 'spring-datasource-e2e-url',
      toKey: 'spring.datasource.url',
    }
  ],
  metadata+: {
    annotations: {
      'argocd.argoproj.io/sync-wave': '-1',
    },
  },
}
