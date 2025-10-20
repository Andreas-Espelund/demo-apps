local argokit = import '../argokit/v2/jsonnet/argokit.libsonnet';
local application = argokit.appAndObjects.application;

local probe = application.probe(path='/health', port=8080);

function(
  env,
  name='demo-backend',
  version,
  gsmProjectId,
  secretStoreName='devex-demo-gsm',
  esoName='devex-demo-secrets',
  kubernetesSecretEntraIdSecretName='entraid-secret',
  cloudSqlConfig,
  dbUser,
  replyUrl,
)
  application.new(name=name, image=version, port=8080)
  + application.withLiveness(probe)
  + application.withReadiness(probe)
  + application.forHostnames('backend.atgcp1-' + env + 'host.com')

  // Static environment variables
  + application.withEnvironmentVariables({
    RR_SERVER_DOMAIN: 'demo.atgcp1-' + env + '.host.com',
    RR_SERVER_PROTOCOL: 'https',
    RR_SERVER_HTTP_PORT: '8080',
    RR_SERVER_ROOT_URL: 'https://demo.atgcp1-' + env + '.host.com',
    FRONTEND_URL_HOST: 'demo.atgcp1-' + env + '.host.com',
    TENANT_ID: 'f9f9f-abcd-1234-gagaga-lgtm-123',
    AUTH_PROVIDER_URL: 'https://demo.atgcp1-' + env + '.host.com/callback',
    DB_NAME: dbUser,
    DB_PASSWORD: '',
    FRISK_FRONTEND_URL_HOST: 'https://frisk.atgcp1-' + env + '.host.com',
    RR_OAUTH_TENANT_ID: 'f9f9f-abcd-1234-gagaga-lgtm-123',
    RR_DATABASE_HOST: 'localhost:5432',
    RR_DATABASE_NAME: 'demo',
    RR_DATABASE_USER: dbUser,
    RR_DATABASE_PASSWORD: '',
    RR_SERVER_ALLOWED_ORIGINS: 'frisk.atgcp1-' + env + '.host.com',
  })

  // Environment variables from secrets with specific keys
  + application.withEnvironmentVariableFromSecret('RR_OAUTH_CLIENT_ID', kubernetesSecretEntraIdSecretName, 'RR_APP_CLIENT_ID')
  + application.withEnvironmentVariableFromSecret('RR_OAUTH_CLIENT_SECRET', kubernetesSecretEntraIdSecretName, 'RR_APP_CLIENT_SECRET')

  // Access policies - inbound
  + application.withInboundSkipApp('demo-frontend')
  + application.withInboundSkipApp('frisk-backend')

  // Access policies - outbound
  + application.withOutboundHttp('api.airtable.com')
  + application.withOutboundHttp('graph.microsoft.com')

  // External secrets for environment variables
  + application.withEnvironmentVariablesFromExternalSecret(
    esoName,
    secrets=[
      { fromSecret: 'demo-airtable-token', toKey: 'AIRTABLE_ACCESS_TOKEN' },
      { fromSecret: 'demo-airtable-token', toKey: 'DE_SCHEMA_DRIFTSKONTINUITET_AIRTABLE_ACCESS_TOKEN' },
      { fromSecret: 'demo-superuser', toKey: 'DE_OAUTH_SUPER_USER_GROUP' },
      { fromSecret: 'demo-airtable-token', toKey: 'DE_SCHEMA_SIKKERHETSKONTROLLER_AIRTABLE_ACCESS_TOKEN' },
      { fromSecret: 'demo-airtable-token', toKey: 'DE_AIRTABLE_ACCESS_TOKEN' },
    ],
    secretStoreRef=secretStoreName
  )


  // Azure AD Application
  + application.withAzureAdApplication(
    name='demo-service-entraid',
    namespace='demo-main',
    groups=[{ id: 'adsfdsa-gdadf-12346g-dadhjj' }],
    secretPrefix='DE',
    replyUrls=[replyUrl],
    preAuthorizedApplications=[
      {
        cluster: ' ',
        namespace: ' ',
        application: if env == 'dev' then '123456789-asdfghjkl-ddsddw'
        else if env == 'prod' then 'asdfg-12345-qwerty-45678',
      },
    ]
  )

  // config som ikke er støttet av argokit, kan skrives som 'vanlig' jsonnet
  + {
    application+: {
      spec+: {
        gcp: cloudSqlConfig,
        filesFrom: [
          {
            mountPath: '/etc/demo/provisioning/schemasources',
            secret: 'provisioning-file',
          },
        ],
      },
    },
    objects+:: [
      argokit.externalSecrets.store.new(secretStoreName, gsmProjectId),

      argokit.externalSecrets.secret.new(
        'provisioning-file',
        secrets=[
          { fromSecret: 'demo-defaults', toKey: 'defaults.yaml' },
        ],
        secretStoreRef=secretStoreName
      ),

      {
        apiVersion: 'networking.istio.io/v1',
        kind: 'DestinationRule',
        metadata: {
          name: 'istio-sticky' + name,
        },
        spec: {
          host: name,
          trafficPolicy: {
            loadBalancer: {
              consistentHash: {
                httpCookie: {
                  name: 'ISTIO-STICKY',
                  path: '/',
                  ttl: '0',
                },
              },
            },
          },
        },
      },
    ],
  }
