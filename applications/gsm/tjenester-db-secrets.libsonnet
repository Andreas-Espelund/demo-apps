local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

{
  StedsnavnDBSecrets: argokit.GSMSecret('stedsnavn-db-secret') {
    secrets: [
      {
        fromSecret: 'stedsnavn-db-user',
        toKey: 'STEDSNAVN_DB_USER',
      },
      {
        fromSecret: 'stedsnavn-db-password',
        toKey: 'STEDSNAVN_DB_PASSWORD',
      },
      {
        fromSecret: 'stedsnavn-db-uri',
        toKey: 'STEDSNAVN_DB_URI',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
  },
  NibasDBSecrets: argokit.GSMSecret('nibas-db-secret') {
    secrets: [
      {
        fromSecret: 'nibas-db-user',
        toKey: 'NIBAS_DB_USER',
      },
      {
        fromSecret: 'nibas-db-password',
        toKey: 'NIBAS_DB_PASSWORD',
      },
      {
        fromSecret: 'nibas-db-uri',
        toKey: 'NIBAS_DB_URI',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
  },
  KommuneinfoDBSecrets: argokit.GSMSecret('kommuneinfo-db-secret') {
    secrets: [
      {
        fromSecret: 'kommuneinfo-db-user',
        toKey: 'KOMMUNEINFO_DB_USER',
      },
      {
        fromSecret: 'kommuneinfo-db-password',
        toKey: 'KOMMUNEINFO_DB_PASSWORD',
      },
      {
        fromSecret: 'kommuneinfo-db-uri',
        toKey: 'KOMMUNEINFO_DB_URI',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
  },
  KommuneinfoTestDBSecrets: argokit.GSMSecret('kommuneinfo-db-secret') {
    secrets: [
      {
        fromSecret: 'kommuneinfo-test-db-user',
        toKey: 'KOMMUNEINFO_DB_USER',
      },
      {
        fromSecret: 'kommuneinfo-test-db-password',
        toKey: 'KOMMUNEINFO_DB_PASSWORD',
      },
      {
        fromSecret: 'kommuneinfo-test-db-uri',
        toKey: 'KOMMUNEINFO_DB_URI',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
  },
  EiendomDBSecrets: argokit.GSMSecret('eiendom-db-secret') {
    secrets: [
      {
        fromSecret: 'eiendom-db-user',
        toKey: 'EIENDOM_DB_USER',
      },
      {
        fromSecret: 'eiendom-db-password',
        toKey: 'EIENDOM_DB_PASSWORD',
      },
      {
        fromSecret: 'eiendom-db-uri',
        toKey: 'EIENDOM_DB_URI',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
  },
  ValgdataGCPSecret: argokit.GSMSecret('valgdata-secret') {
    secrets: [
      {
        fromSecret: 'nibas-service-account-key',
        toKey: 'GOOGLE_APPLICATION_CREDENTIALS_JSON',
      },
    ],
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-1',
      },
    },
  },
}
