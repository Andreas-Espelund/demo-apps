local nibas_entraid = import '../../../applications/auth/common/entraid.libsonnet';
local authConstants = import '../../../applications/auth/nibas/constants.jsonnet';

nibas_entraid(
  app='nibas-prod-entraid',
  replyUrls=[
    { url: 'https://nibas.<INTERNAL_DOMAIN>' + authConstants.replyPath },
  ],
  authedGroupId=authConstants.AAD_NIBAS_PROD_USERS_ID,
  azureAdApplicationSecretName=authConstants.azureAdApplicationSecretName,
)
