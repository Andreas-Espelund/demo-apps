local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-proddump-backup-secret') {
  secrets: [
    {
      fromSecret: 'cloudsql-nibas-backup-nibas',
      toKey: 'NIBAS_BACKUP',
    },
    {
      fromSecret: 'cloudsql-nibas-backup-instance',
      toKey: 'NIBAS_BACKUP_INSTANCE',
    },
  ],
  metadata+: {
    annotations: {
      'argocd.argoproj.io/sync-wave': '-1',
    },
  },
}
