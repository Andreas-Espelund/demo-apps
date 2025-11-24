[
    { 
        kind: 'Role',
        apiVersion: 'rbac.authorization.k8s.io/v1',
        metadata: {
            name: 'namespace-job-deleter-role',
            namespace: 'nibas-e2e',
            annotations: {
                description: 'Allows deleting jobs in the dev nibas-e2e namespace.',
            },
        },
        rules: [
            {
                apiGroups: ['skiperator.kartverket.no'],
                resources: ['skipjobs'],
                verbs: ['delete'],
            }
        ],
               
    }
]
