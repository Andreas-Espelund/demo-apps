local aalRegisterConfigTemplate(applicationConfig, serverName) =
  local applicationConfigWithDefaults = {
    aal: {
      klient: {
        url: 'https://' + serverName,
      },
      role: {
        MATRIKKELSOK: 'svcmataal',
        INTEGRATOR: 'svcaal',
      },
      ad: {
        url: '<LDAP_URL>',
      },
    },
    server: {
      port: 7004,
    },
  } + applicationConfig;
  {
    applicationConfig: applicationConfigWithDefaults,
    configMap: {
      apiVersion: 'v1',
      kind: 'ConfigMap',
      metadata: {
        name: 'aal-register-config',
      },
      data: {
        'application.yaml': std.manifestYamlDoc(applicationConfigWithDefaults),
      },
    },
  };

aalRegisterConfigTemplate
