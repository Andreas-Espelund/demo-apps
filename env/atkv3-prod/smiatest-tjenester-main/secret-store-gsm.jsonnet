local secretstore = import '../../../applications/gsm/gsm-secret-store.libsonnet';
local projects = import '../gcp_projects.libsonnet';

secretstore(projects.matrikkeltjenesterTest)