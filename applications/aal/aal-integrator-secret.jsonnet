local extSecrets = import 'lib/external-secrets.libsonnet';
{
  apiVersion: 'external-secrets.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'aal-integrator-external-secret',
  },
  spec: {
    dataFrom: [
      extSecrets.extractKey('arken_auth', prefix='arken'),
      extSecrets.extractKey('integrator_keystore_auth', prefix='keystore'),
      extSecrets.extractKey('integrator_register_auth', prefix='aalregister'),
      extSecrets.extractKey('cli_auth', prefix='cli'),
    ],
    data: [
        extSecrets.remoteRef('integrator_keystore', 'keystore'),
    ],
    refreshInterval: '1h',
    secretStoreRef: {
      kind: 'SecretStore',
      name: 'gsm',
    },
    target: {
      name: 'aal-integrator-secret',
      template: {
        engineVersion: 'v2',
        data: {
          'application.yaml':
            'spring:\n' +
            '  security:\n' +
            '    user:\n' +
            '      name: {{ .cli_username }}\n' +
            '      password: {{ .cli_password }}\n' +
            'keystore:\n' +
            '  file: config/secret/keystore.p12\n' +
            '  password: {{ .keystore_password }}\n' +
            '  alias:\n' +
            '    name: {{ .keystore_alias_name }}\n' +
            '    password: {{ .keystore_alias_password }}\n' +
            'arken:\n' +
            '  username: {{ .arken_username }}\n' +
            '  password: {{ .arken_password }}\n' +
            'aalregister:\n' +
            '  username: {{ .aalregister_username }}\n' +
            '  password: {{ .aalregister_password }}\n',
          'keystore.p12': '{{ .keystore }}',
        },
      },
    },
  },
}
