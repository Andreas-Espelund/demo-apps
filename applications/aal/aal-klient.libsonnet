local nginxConfigMapName = 'aal-klient-nginx-config';

function(serverName, image, port = 7002, nginxConfig = {}) {
  application: {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'aal-klient',
    },
    spec: {
      image: image,
      port: port,
      filesFrom: [
        {
          mountPath: '/var/cache/nginx',
          emptyDir: 'nginx-cache',
        },
        {
          mountPath: '/var/run',
          emptyDir: 'runtime-data',
        },
        {
          mountPath: '/etc/nginx/conf.d',
          configMap: nginxConfigMapName,
        },
      ],
    },
  },
  nginxConfigMap: {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: nginxConfigMapName,
    },
    data: {
      'aal-klient.conf': (importstr 'aal-klient.nginx.conf') % ({
        listen: port,
        server_name: serverName,
      } + nginxConfig),
    },
  },
}
