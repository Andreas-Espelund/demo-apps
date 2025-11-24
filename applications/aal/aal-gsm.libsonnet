function(projectID) {
  apiVersion: 'external-secrets.io/v1',
  kind: 'SecretStore',
  metadata: {
    name: 'gsm',
  },
  spec: {
    provider: {
      gcpsm: {
        projectID: projectID,
      },
    },
  },
}
