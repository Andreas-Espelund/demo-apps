local argokit = import '../../argokit/jsonnet/argokit.libsonnet';

function(project_id) (
  argokit.GSMSecretStore(project_id) {
    metadata+: {
      annotations: {
        'argocd.argoproj.io/sync-wave': '-2',
      },
    },
  }
)
