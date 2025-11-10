{
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'test-validation',
  },
  spec: {
    image: '1.2.3.4',
    meta: 20000,
    potato_mode: false,
    //port: 3000,
  },
}
