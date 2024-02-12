controller:
  secret:
    enabled: true
    data:
      userinitcfg.yaml: 
        always_reload: true
        users:
        -
          Fullname: admin
          Password: 
          Role: admin

manager:
  svc:
    type: LoadBalancer

containerd:
  enabled: true
