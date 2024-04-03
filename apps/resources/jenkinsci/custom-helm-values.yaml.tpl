controller:
  jenkinsUrl: 
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      ingressClassName: nginx
  installPlugins:
    - kubernetes:4203.v1dd44f5b_1cf9
    - workflow-aggregator:596.v8c21c963d92d
    - git:5.2.1
    - configuration-as-code:1775.v810dc950b_514
    - neuvector-vulnerability-scanner:2.3
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
