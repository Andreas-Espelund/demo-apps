local rosPluginBackend = import '../../../applications/ros-plugin-backend.libsonnet';
local version = import 'image-url-ros-plugin-backend';

rosPluginBackend(
    env='dev',
    version=version,
    gsmProjectId='<GSM_PROJECT_ID>',
)