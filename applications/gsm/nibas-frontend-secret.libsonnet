local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-frontend-secret') {
  secrets: [
    {
      fromSecret: 'BAAT-username',
      toKey: 'BAAT_USERNAME',
    },
    {
      fromSecret: 'BAAT-password',
      toKey: 'BAAT_PASSWORD',
    },
    {
      fromSecret: 'matrikkelen-wfs-url',
      toKey: 'MATRIKKELEN_WFS_URL',
    },
    {
      fromSecret: 'matrikkelen-wfs-credentials',
      toKey: 'MATRIKKELEN_WFS_CREDENTIALS',
    },
    {
      fromSecret: 'repo-pr-access',
      toKey: 'REPO_PR_ACCESS',
    },
  ],
}
