local argokit = import '../argokit/v2/jsonnet/argokit.libsonnet';
local app = argokit.appAndObjects.application;


app.new(name='test-app', image='gcr.io/google-samples/gb-frontend:v5', port=3000)
