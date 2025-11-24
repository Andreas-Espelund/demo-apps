local argokit = import '../../../argokit/jsonnet/argokit.libsonnet';

[
  // Gives the following users access to edit their namespace
  argokit.Roles {
    members: [
      '<USER_EMAIL_1>',
      '<USER_EMAIL_2>',
    ],
  },
]
