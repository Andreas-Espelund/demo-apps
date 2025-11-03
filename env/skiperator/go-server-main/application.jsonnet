local argokit = import '../../../argokit/v2/jsonnet/argokit.libsonnet';
local app = argokit.appAndObjects.application;

app.new(name='go-server',image='go-http-server',port=8080)