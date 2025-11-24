local authConstants = import '../../../applications/auth/nibas/constants.jsonnet';
local nibas_backend_ztoperator = import '../../../applications/auth/nibas/nibas-backend-ztoperator.libsonnet';
local nibas_frontend_ztoperator = import '../../../applications/auth/nibas/nibas-frontend-ztoperator.libsonnet';

nibas_frontend_ztoperator('nibas-main', authConstants.prodEntraidClientId) +
nibas_backend_ztoperator('nibas-main', authConstants.prodEntraidClientId)
