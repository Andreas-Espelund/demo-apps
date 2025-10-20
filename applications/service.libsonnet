local argokit = import '../argokit/v2/jsonnet/argokit.libsonnet';
local application = argokit.appAndObjects.application;

function(name, env, version)
  application.new(name=name, image=version, port=5555)
  + application.forHostnames('service-api.com')
  + application.withEnvironmentVariable('DB_PASS', 'passord123')
  + application.withOutboundPostgres(host='postgres.com', ip='10.0.0.1')
