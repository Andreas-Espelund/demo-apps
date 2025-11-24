local createConfig(
  registerConfig,
  arkenRootUri,
  arkenProjectNumber,
  arkenResponsiblePersonRecNo,
  altinnPlatformRootUri,
  altinnApplicationsRootUri,
  maskinportenUriRoot,
  maskinportenJwtIssuer,
  maskinportenJwtKeyId,
  config={}
      ) = {
            server: {
              port: 8081,
            },
            filestorage: {
              // True if downloaded data from application instances should be stored
              store: false,
              // Directory where downloaded data for application instances should be stored
              storagePath: 'data',
            },
            arken: {
              rootUri: arkenRootUri,
              projectNumber: arkenProjectNumber,
              responsiblePersonRecNo: arkenResponsiblePersonRecNo,
            },
            altinn: {
              uri: {
                platform: {
                  root: altinnPlatformRootUri,
                },
                applications: {
                  root: altinnApplicationsRootUri,
                },
              },
            },
            maskinporten: {
              uri: {
                root: maskinportenUriRoot,
              },
              jwt: {
                issuer: maskinportenJwtIssuer,
              },
            },
          }
          + (if maskinportenJwtKeyId != null && std.stripChars(maskinportenJwtKeyId, ' \t\n\r') != ''
             then { maskinporten+: { jwt+: { keyId: maskinportenJwtKeyId } } }
             else {})
          + config
          + {
            aalregister+: {
              uri: 'http://aal-register' + (
                if registerConfig.server.port == 80
                then ''
                else ':' + std.toString(registerConfig.server.port)
              ) + '/backend/integrator/landmaalere',
            },
          }
;

function(
  image,
  registerConfig,
  arkenRootUri,
  arkenProjectNumber,
  arkenResponsiblePersonRecNo,
  altinnPlatformRootUri,
  altinnApplicationsRootUri,
  maskinportenUriRoot,
  maskinportenJwtIssuer,
  maskinportenJwtKeyId=null,
  configOverride={}
) {
  local config = createConfig(
    registerConfig,
    arkenRootUri,
    arkenProjectNumber,
    arkenResponsiblePersonRecNo,
    altinnPlatformRootUri,
    altinnApplicationsRootUri,
    maskinportenUriRoot,
    maskinportenJwtIssuer,
    maskinportenJwtKeyId,
    configOverride
  ),
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'aal-integrator',
  },
  spec: {
    image: image,
    port: config.server.port,
    replicas: 1,
    strategy: {
      type: 'Recreate',
    },
    filesFrom: [
      {
        mountPath: '/opt/aal-integrator/config/secret',
        secret: 'aal-integrator-secret',
      },
    ],
    env: [
      {
        name: 'SPRING_APPLICATION_JSON',
        value: std.strReplace(std.manifestJson(config), '$', '$$'),
      },
    ],
    accessPolicy: {
      outbound: {
        rules: [
          {
            application: 'aal-register',
          },
        ],
      },
    },
  },
}
