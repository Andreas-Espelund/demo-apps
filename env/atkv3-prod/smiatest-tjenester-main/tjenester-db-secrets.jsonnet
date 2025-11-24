local secrets = import '../../../applications/gsm/tjenester-db-secrets.libsonnet';

[
  secrets.KommuneinfoDBSecrets,
  secrets.NibasDBSecrets,
  secrets.EiendomDBSecrets,
  secrets.StedsnavnDBSecrets,
  secrets.ValgdataGCPSecret,
]
