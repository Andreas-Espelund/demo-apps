function(image, job_name, service_account_name, gcp_kubernetes_project, gcp_project, suspend_cron=false) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'SKIPJob',
    metadata: {
      name: job_name,
    },
    spec: {
      container: {
        image: image,
        resources: {
          limits: {
            memory: '12G',
          },
          requests: {
            cpu: '250m',
            memory: '4G',
          },
        },
        gcp: {
          auth: {
            serviceAccount: service_account_name,
          },
        },
        env: [
          {
            name: 'CLOUD',
            value: 'true',
          },
          {
            name: 'BUCKET_NAME',
            value: 'landing-zone-' + gcp_project,
          },
        ],
        envFrom: [
          { secret: 'nibas-dataexporter-apikeys-secret' },
        ],
        accessPolicy: {
          outbound: {
            rules: [
              {
                application: 'nibas-backend',
                namespace: 'nibas-main',
              },
            ],
          },
        },
      },
      job: {
        ttlSecondsAfterFinished: 600,
      },
      cron: {
        schedule: '0 2 * * *',
        suspend: suspend_cron,
      },
    },
  },

  {
    apiVersion: 'skip.kartverket.no/v1alpha1',
    kind: 'ServiceAccountInstance',
    metadata: {
      name: job_name,
    },
    spec: {
      parameters: {
        displayName: 'NIBAS Data Exporter',
        name: job_name,
      },
    },
  },

  {
    apiVersion: 'skip.kartverket.no/v1alpha1',
    kind: 'BucketAccessInstance',
    metadata: {
      name: 'landing-zone-bucket-access',
    },
    spec: {
      parameters: {
        accessTo: {
          bucketName: 'landing-zone-' + gcp_project,
          gcpServiceAccount: service_account_name,
          gcpProject: gcp_project,
        },
        accessFrom: {
          gcpKubernetesProject: gcp_kubernetes_project,
          kubernetesServiceAccount: job_name + '-skipjob',
        },
      },
    },
  },
]
