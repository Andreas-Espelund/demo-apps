
local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

argokit.GSMSecret('nibas-dataexporter-apikeys-secret') {
  secrets: [
    {
      fromSecret: 'api-key-matrikkel',
      toKey: 'NIBAS_API_KEY',
    },
  ],
}
