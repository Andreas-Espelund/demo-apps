local netpol(name, port=5000) = {
  apiVersion: 'networking.k8s.io/v1',
  kind: 'NetworkPolicy',
  metadata: {
    name: name + '-allow-tcp',
  },
  spec: {
    ingress: [
      {
        from: [
          {
            namespaceSelector: {
              matchLabels: {
                'kubernetes.io/metadata.name': 'istio-gateways',
              },
            },
            podSelector: {
              matchLabels: {
                istio: 'ingressgateway',
              },
            },
          },
        ],
        ports: [
          {
            port: port,
            protocol: 'TCP',
          },
        ],
      },
    ],
    podSelector: {
      matchLabels: {
        app: name,
      },
    },
    policyTypes: [
      'Ingress',
    ],
  },
};

local prefix_match(name, port=5000) = {
  name: name,
  match: [
    {
      port: 443,
      uri: {
        prefix: '/' + name + '/v1',
      },
    },
  ],
  route: [
    {
      destination: {
        host: name,
        port: {
          number: port,
        },
      },
    },
  ],
};

function(environment) [
  local host = if (environment == 'test') then '<TEST_API_HOST>' else '<PROD_API_HOST>';
  local gateway = if (environment == 'test') then '<TEST_GATEWAY>' else '<PROD_GATEWAY>';
  {
    apiVersion: 'networking.istio.io/v1',
    kind: 'VirtualService',
    metadata: {
      name: 'api-ingresses',
    },
    spec: {
      gateways: [
        'istio-gateways/' + gateway,
      ],
      hosts: [
        host,
      ],
      http: [
        prefix_match('kommuneinfo'),
        prefix_match('stedsnavn'),
        prefix_match('eiendom'),
        prefix_match('valgdata', 8080),
      ],
    },
  },
  netpol('kommuneinfo'),
  netpol('stedsnavn'),
  netpol('eiendom'),
  netpol('valgdata', 8080),
]
