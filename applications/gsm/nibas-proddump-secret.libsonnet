local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-proddump-secret') {
    secrets: [
      {
        fromSecret: 'nibas-proddump-targetdb-uri',
        toKey: 'DB_TARGET_URI',
      },
      {
        fromSecret: 'nibas-proddump-eventsdb-uri',
        toKey: 'DB_EVENTS_URI',
      },
      {
        fromSecret: 'nibas-proddump-targetdb-arbeidsliste-uri',
        toKey: 'DB_ARBEIDSLISTE_TARGET_URI',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
}
