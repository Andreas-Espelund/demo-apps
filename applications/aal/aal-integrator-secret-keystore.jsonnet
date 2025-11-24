local extSecrets = import 'lib/external-secrets.libsonnet';
{
  apiVersion: 'external-secrets.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'aal-integrator-external-secret-keystore',
  },
  spec: {
    data: [
        extSecrets.remoteRef('integrator_keystore', 'keystore.p12'),
    ],
    refreshInterval: '1h',
    secretStoreRef: {
      kind: 'SecretStore',
      name: 'gsm',
    },
    target: {
      name: 'aal-integrator-secret',
    },
  },
}
