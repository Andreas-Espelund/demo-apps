function(name, version, schedule, ttl) {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'SKIPJob',
    metadata: {
        name: name,
    },
    spec: {
        cron: {
            schedule: schedule,
        },
        job: {
            ttlSecondsAfterFinished: ttl,
        },
        container: {
            image: version,
            env: [
                {
                    name: 'URL',
                    value: 'http://sikkerhetsmetrikker.sikkerhetsmetrikker-main:8080',
                },
            ],
            resources: {
                requests: {
                    cpu: '25m',
                    memory: '256Mi',
                },
            },
            accessPolicy: {
                outbound: {
                    rules: [
                        {
                            application: 'sikkerhetsmetrikker',
                        },
                    ],
                },
            },
        },
    },
}