local argokit = import '../../../argokit/jsonnet/argokit.libsonnet';

[
  argokit.NamespaceAdminGroup('<ADMIN_GROUP_EMAIL>'),
  argokit.Roles {
    members: [
      '<USER_EMAIL>',
    ],
  },
]
