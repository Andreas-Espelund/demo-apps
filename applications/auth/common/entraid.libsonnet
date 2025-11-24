function(app, replyUrls=[{ url: '' }], authedGroupId, azureAdApplicationSecretName) [
  {
    apiVersion: 'nais.io/v1',
    kind: 'AzureAdApplication',
    metadata: {
      name: app,
    },
    spec: {
      secretName: azureAdApplicationSecretName,
      allowAllUsers: false,
      claims: {
        groups: [
          {
            id: authedGroupId,
          },
        ],
      },
      replyUrls: replyUrls,
    },
  },
]
