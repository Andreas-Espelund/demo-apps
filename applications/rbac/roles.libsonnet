{
  NamespaceAdmin: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'namespace-admin',
      annotations: {
        description: 'Binds cluster-admin to the team AD/Google Group. Allows all subjects to have full rights within their namespace. Usually reserved for dev/sandbox.',
      },
    },
    subjects: [
      {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'Group',
        name: '<AD_GROUP>',
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: 'cluster-admin',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  NamespaceViewer: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'namespace-viewer',
      annotations: {
        description: 'Binds view to the team AD/Google Group. Allows all subjects to have read rights within their namespace. Usually reserved for prod.',
      },
    },
    subjects: [
      {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'Group',
        name: '<AD_GROUP>',
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: 'view',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  JobDeleteRoleBinding: {
        kind: 'RoleBinding',
        apiVersion: 'rbac.authorization.k8s.io/v1',
        metadata: {
        name: 'namespace-job-deleter-rolebinding',
        namespace: 'nibas-e2e',
        annotations: {
            description: 'Binds access to delete jobs in the nibas-e2e dev namespace to the service account.',
        },
        },
        subjects: [
            {
                kind: 'User',
                name: '<SERVICE_ACCOUNT>',
                namespace: 'nibas-e2e',
            },
        ],
        roleRef: {
            kind: 'Role',
            name: 'namespace-job-deleter-role',
            apiGroup: 'rbac.authorization.k8s.io',
        },
    }
}
