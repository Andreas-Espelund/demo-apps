{
  extractKey(key, prefix): {
    extract: {
      key: key,
      conversionStrategy: 'Default',
      decodingStrategy: 'None',
      metadataPolicy: 'None',
    },
    rewrite: [
      {
        transform: {
          template: prefix + '_{{ .value }}',
        },
      },
    ],
  },

  remoteRef(remoteKey, secretKey): {
    remoteRef: {
      key: remoteKey,
      metadataPolicy: 'None',
    },
    secretKey: secretKey,
  },
  
}
