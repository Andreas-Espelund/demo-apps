local argokit = import '../../../argokit/v2/jsonnet/argokit.libsonnet';
local app = argokit.appAndObjects.application;

// Define health probe for your /health endpoint
local probe = app.probe(path='/health', port=8080);

app.new(name='go-webserver-testapp', image='go-http-server', port=8080)
+ app.withLiveness(probe)
+ app.withReadiness(probe)
+ app.withReplicas(1) // Single replica for testing
+ app.forHostnames('webserver.local') // Local hostname