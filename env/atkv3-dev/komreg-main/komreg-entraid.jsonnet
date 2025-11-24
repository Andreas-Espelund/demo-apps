local komreg_entraid = import '../../../applications/auth/common/entraid.libsonnet';
local authConstants = import '../../../applications/auth/komreg/constants.jsonnet';

komreg_entraid(
  app='komreg-entraid',
  replyUrls=[
    { url: 'https://komreg-backend.atkv3-dev.<INTERNAL_DOMAIN>' + authConstants.replyPath },
  ],
  authedGroupId=authConstants.AAD_TF_TEAM_SMIA_ID,
  azureAdApplicationSecretName=authConstants.azureAdApplicationSecretName,
)
