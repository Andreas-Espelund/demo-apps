local nibas_entraid = import '../../../applications/auth/common/entraid.libsonnet';
local authConstants = import '../../../applications/auth/nibas/constants.jsonnet';
local namespace = import 'namespace';

nibas_entraid(
  app=namespace + '-entraid',
  replyUrls=[
    { url: 'https://' + namespace + '.atkv3-dev.<INTERNAL_DOMAIN>' + authConstants.replyPath },
  ],
  authedGroupId=authConstants.AAD_TF_TEAM_SMIA_ID,
  azureAdApplicationSecretName=authConstants.azureAdApplicationSecretName,
)
