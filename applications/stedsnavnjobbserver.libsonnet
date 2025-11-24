local stedsnavn = import '../lib/stedsnavn-libsonnet/v1/stedsnavn.libsonnet';

local defaultResources = {
  limits: {
    memory: '2G',
  },
  requests: {
    cpu: '10m',
    memory: '1G',
  },
};

function(image, configAndSecrets, logbackXmlStr, java_ops=[], port=8081, metricsPort=8082, appname='stedsnavnjobbserver', tracingRatio=0.0, resources=defaultResources, replicas={}, worstCaseShutdownSeconds=-1, ingresses=[])
  stedsnavn.AppAndObjects {
    application+::
      stedsnavn.TomeeApplication(appname, image, java_ops, port, metricsPort, tracingRatio)
      + {
        spec+: {
          ingresses: ingresses,
          [if (replicas != {}) then 'replicas']: replicas,
          resources: resources,
        },
      },

    objects+:: [],
  }
  //Properties and secrets
  + stedsnavn.appAndObjects.HashedConfigMapAsEnv(appname, stedsnavn.utils.PrefixKeys(configAndSecrets.config))
  + stedsnavn.appAndObjects.HashedExternalGSMSecretAsEnv(appname, stedsnavn.utils.PrefixKeys(configAndSecrets.secrets))

  //Logback
  + stedsnavn.appAndObjects.HashedConfigMapAsMount(appname + '-logback', '/tmp/log', { 'logback.xml': logbackXmlStr })
