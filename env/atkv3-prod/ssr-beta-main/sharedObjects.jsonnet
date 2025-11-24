local stedsnavn = import '../../../lib/stedsnavn-libsonnet/v1/stedsnavn.libsonnet';

local config = import 'config.libsonnet';
local fileshare = config.common.fileshare;

stedsnavn.k8s.List(
  [
    stedsnavn.argokit.GSMSecretStore('<GCP_PROJECT_ID>'),
    stedsnavn.k8s.PersistentVolumeClaim(fileshare.lucene.name),
  ]
)
