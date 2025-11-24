local authConstants = import '../../../applications/auth/komreg/constants.jsonnet';
local komreg_ztoperator = import '../../../applications/auth/komreg/komreg-ztoperator.libsonnet';

komreg_ztoperator('komreg-backend', 'komreg-main', authConstants.devEntraidClientId)
