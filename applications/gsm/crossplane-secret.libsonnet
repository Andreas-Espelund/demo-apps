
local argokit = import '../../argokit/jsonnet/argokit.libsonnet';
local secret_name = 'crossplane-sa-key';

argokit.GSMSecret(secret_name) {
  secrets: [
    {
      fromSecret: secret_name,
      toKey: 'creds',
    },
  ],
}
