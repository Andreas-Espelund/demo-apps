local job = import '../../../applications/nibas-data-exporter.libsonnet';
local projects = import '../gcp_projects.libsonnet';
local image = import 'nibas-data-exporter-version';

local job_name = 'nibas-data-exporter';

job(
  image=image,
  job_name=job_name,
  service_account_name=job_name + '@' + projects.nibas + '.iam.gserviceaccount.com',
  gcp_kubernetes_project=projects.kubernetes,
  gcp_project=projects.nibas
)
