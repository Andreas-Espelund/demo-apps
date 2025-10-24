local argokit = import '../argokit/v2/jsonnet/argokit.libsonnet';
local application = argokit.appAndObjects.application;

function(name, env, version)
  application.new(name=name, image=version, port=5555)
  + application.forHostnames('service-api.com')
  + application.withOutboundSkipApp(3000)
  + application.withEnvironmentVariable('SERVICE_ENV', env)
  + application.withOutboundOracle(host='db.kartveret.no', ip='10.0.0.1')
