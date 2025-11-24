local aal = import '../../../applications/aal/aal.libsonnet';

aal(
  serverName='<AAL_SERVER_NAME>',
  projectID='<GCP_PROJECT_ID>',
  aalKlientImage=import 'smia-aal-klient-version',
  aalRegisterImage=import 'smia-aal-register-version',
  aalIntegratorImage=import 'smia-aal-integrator-version',
  aalRegisterApplicationConfig=import 'aal-register-application-config.libsonnet',
  arkenRootUri = '<ARKEN_ROOT_URI>', 
  arkenProjectNumber = '<ARKEN_PROJECT_NUMBER>', 
  arkenResponsiblePersonRecNo = '<ARKEN_RESPONSIBLE_PERSON_REC_NO>',
  altinnPlatformRootUri = '<ALTINN_PLATFORM_ROOT_URI>',
  altinnApplicationsRootUri = '<ALTINN_APPLICATIONS_ROOT_URI>',
  maskinportenUriRoot = '<MASKINPORTEN_URI_ROOT>',
  maskinportenJwtIssuer = '<MASKINPORTEN_JWT_ISSUER>',
  maskinportenJwtKeyId = '<MASKINPORTEN_JWT_KEY_ID>',
  aalRegister={
    spec+: {
      accessPolicy+: {
        outbound+: {
          external+: [
            {
              host: '<LDAP_HOST_1>',
              ip: '<LDAP_IP_1>',
              ports+: [
                {
                  name: 'ldaps',
                  port: 636,
                  protocol: 'TCP',
                },
              ],
            },
            {
              host: '<LDAP_HOST_2>',
              ip: '<LDAP_IP_2>',
              ports+: [
                {
                  name: 'ldaps',
                  port: 636,
                  protocol: 'TCP',
                },
              ],
            },
            {
              host: '<ORACLE_HOST>',
              ip: '<ORACLE_IP>',
              ports+: [
                {
                  name: 'oracle',
                  port: 1521,
                  protocol: 'TCP',
                },
              ],
            },
            {
              host: '<HTTP_HOST>',
              ports: [
                { name: 'http', port: 8080, protocol: 'HTTP' },
              ],
            },
          ],
        },
      },
    },
  },
  aalIntegratorConfig={
    altinn +: {
      pollInterval: "0 */5 * * * *"
    }
  },
  aalIntegrator={
    spec+: {
      accessPolicy+: {
        outbound+: {
          external+: [
            { host: '<ALTINN_PLATFORM_HOST>' },
            { host: '<ALTINN_APPS_HOST>' },
            { host: '<MASKINPORTEN_HOST>' },
            {
              host: '<ARKEN_HOST>',
              ports: [
                { name: 'https', port: 44300, protocol: 'HTTPS' },
              ],
            },
          ],
        },
      },
    },
  },
)
