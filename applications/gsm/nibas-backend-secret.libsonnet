local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-backend-secret') {
  secrets: [
    {
      fromSecret: 'matrikkelen-wfs-url',
      toKey: 'MATRIKKELEN_WFS_URL',
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
}
