controller:
  jenkinsUrl: 
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      ingressClassName: nginx
  installPlugins:
    - kubernetes:4306.vc91e951ea_eb_d
    - workflow-aggregator:600.vb_57cdd26fdd7
    - git:5.7.0
    - configuration-as-code:1915.vcdd0a_d0d2625
    - neuvector-vulnerability-scanner:2.4
  JCasC:
    configScripts:
      neuvector: |
        unclassified:
          neuvector:
            controllerApiUrl: ""
            disableTLSCertVerification: true
            password: ""
            registries:
            - nickname: "dockerhub"
              regPassword: ""
              regUsername: ""
              regUrl: "https://registry.hub.docker.com/"
            scannerImage: "neuvector/scanner:latest"
            scannerRegistryPassword: ""
            scannerRegistryURL: "docker.io"
            source: "NeuVector Scanner on Jenkins"
            timeout: 0
            user: "admin"
