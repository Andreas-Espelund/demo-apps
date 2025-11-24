local kommuneinfoImport = import '../../../applications/kommuneinfo-import.libsonnet';
local databases = import '../databases.libsonnet';
local projects = import '../gcp_projects.libsonnet';
local image = import 'kommuneinfo-import-version';

local job_name = 'kommuneinfo-import';
kommuneinfoImport(
  environment='prod',
  job_name=job_name,
  service_account_name=job_name + '@' + projects.matrikkeltjenesterTest + '.iam.gserviceaccount.com',
  gcp_kubernetes_project=projects.kubernetes,
  gcp_project=projects.matrikkeltjenesterTest,
  image=image,
  kommuneinfo_host=databases.kommuneinfoTest.host,
  kommuneinfo_ip=databases.kommuneinfoTest.ip,
  nibas_host=databases.nibas.host,
  nibas_ip=databases.nibas.ip,
)
