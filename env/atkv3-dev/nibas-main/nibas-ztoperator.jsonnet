local authConstants = import '../../../applications/auth/nibas/constants.jsonnet';
local nibas_backend_ztoperator = import '../../../applications/auth/nibas/nibas-backend-ztoperator.libsonnet';
local nibas_frontend_ztoperator = import '../../../applications/auth/nibas/nibas-frontend-ztoperator.libsonnet';
local namespace = import 'namespace';

nibas_frontend_ztoperator(namespace, authConstants.devEntraidClientId) +
nibas_backend_ztoperator(namespace, authConstants.devEntraidClientId)
