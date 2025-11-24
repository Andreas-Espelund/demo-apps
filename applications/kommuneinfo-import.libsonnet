function(image, environment, kommuneinfo_host, kommuneinfo_ip, nibas_host, 
        nibas_ip, job_name, service_account_name, gcp_project, gcp_kubernetes_project, suspend_cron = false) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'SKIPJob',
    metadata: {
      name: job_name,
    },
    spec: {
      container: {
        image: image,
        envFrom: [
          { secret: 'kommuneinfo-db-secret' },
          { secret: 'nibas-db-secret' },
        ],
        resources: {
          limits: {
            memory: '2G',
          },
          requests: {
            cpu: '200m',
            memory: '1G',
          },
        },
        gcp: {
          auth: {
            serviceAccount: service_account_name,
          },
        },
        accessPolicy: {
          outbound: {
            external: [
              {
                host: kommuneinfo_host,
                ip: kommuneinfo_ip,
                ports: [
                  {
                    name: 'psql',
                    protocol: 'TCP',
                    port: 5432,
                  },
                ],
              },
              {
                host: nibas_host,
                ip: nibas_ip,
                ports: [
                  {
                    name: 'psql',
                    protocol: 'TCP',
                    port: 5432,
                  },
                ],
              },
              { host: 'register.geonorge.no' },
            ],
          },
        },
      },
      cron: {
        schedule: '0 2 * * *',
        suspend: suspend_cron
      },
    },
  },

  {
    apiVersion: 'skip.kartverket.no/v1alpha1',
    kind: 'WorkloadIdentityInstance',
    metadata: {
      name: job_name 
    },
    spec: {
      parameters: {
        gcpKubernetesProject: gcp_kubernetes_project,
        gcpProject: gcp_project,
        gcpServiceAccount: service_account_name,
        serviceAccount: job_name + '-skipjob'
      }
    }
  },

  {
      apiVersion: 'skip.kartverket.no/v1alpha1',
      kind: 'ServiceAccountInstance',
      metadata: {
        name: job_name,
      },
      spec: {
        parameters: {
          displayName: 'Kommuneinfo Importer',
          name: job_name,
        },
      },
    }
]