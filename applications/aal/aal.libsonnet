local resources(
  serverName,
  projectID,
  aalRegisterImage,
  aalKlientImage,
  aalIntegratorImage,
  arkenRootUri,
  arkenProjectNumber,
  arkenResponsiblePersonRecNo,
  altinnPlatformRootUri,
  altinnApplicationsRootUri,
  maskinportenUriRoot,
  maskinportenJwtIssuer,
  maskinportenJwtKeyId=null,
  aalRegisterApplicationConfig={},
  aalRegisterConfigMap={},
  aalRegisterSecret={},
  aalRegister={},
  aalKlientNginxConfigMap={},
  aalKlient={},
  aalIntegratorConfig={},
  aalIntegratorSecret={},
  aalIntegrator={},
  aalRouting={},
  aalGsm={},
      ) =
  local aalRegisterConfigTemplate = (import 'aal-register-config.libsonnet')(aalRegisterApplicationConfig, serverName);
  local aalRegisterSecretTemplate = import 'aal-register-secret.jsonnet';
  local aalRegisterTemplate = (import 'aal-register.libsonnet')(aalRegisterImage, aalRegisterConfigTemplate.applicationConfig);

  local aalKlientTemplate = (import 'aal-klient.libsonnet')(serverName, aalKlientImage);

  local aalIntegratorTemplate = (import 'aal-integrator.libsonnet')(
    aalIntegratorImage,
    registerConfig=aalRegisterConfigTemplate.applicationConfig,
    arkenRootUri=arkenRootUri,
    arkenProjectNumber=arkenProjectNumber,
    arkenResponsiblePersonRecNo=arkenResponsiblePersonRecNo,
    altinnPlatformRootUri=altinnPlatformRootUri,
    altinnApplicationsRootUri=altinnApplicationsRootUri,
    maskinportenUriRoot=maskinportenUriRoot,
    maskinportenJwtIssuer=maskinportenJwtIssuer,
    maskinportenJwtKeyId=maskinportenJwtKeyId,
    configOverride=aalIntegratorConfig
  );
  local aalIntegratorSecretTemplate = import 'aal-integrator-secret.jsonnet';
  local aalGsmTemplate = (import 'aal-gsm.libsonnet')(projectID);
  local aalRoutingTemplate = (import 'aal-routing.libsonnet')(serverName);

  [
    aalKlientTemplate.application + aalKlient,
    aalKlientTemplate.nginxConfigMap + aalKlientNginxConfigMap,
    aalRegisterTemplate + aalRegister,
    aalRoutingTemplate + aalRouting,
    aalGsmTemplate + aalGsm,
    aalRegisterSecretTemplate + aalRegisterSecret,
    aalRegisterConfigTemplate.configMap + aalRegisterConfigMap,
    aalIntegratorSecretTemplate + aalIntegratorSecret,
    aalIntegratorTemplate + aalIntegrator,
  ];

resources
