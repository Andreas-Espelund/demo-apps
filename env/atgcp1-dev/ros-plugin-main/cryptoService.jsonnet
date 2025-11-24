local cryptoService = import '../../../applications/cryptoService.libsonnet';
local version = import 'image-url-crypto-service';

cryptoService(
    version=version,
    gsmProjectId='<GSM_PROJECT_ID>'
)