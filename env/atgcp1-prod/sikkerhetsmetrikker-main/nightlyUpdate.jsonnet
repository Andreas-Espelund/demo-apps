local application = import '../../../applications/skipJob.libsonnet';
local version = import 'image-url-nightly-update';

application(
    name='nightly-update',
    version=version,
    schedule='15 0 * * *',
    ttl=86400,
)