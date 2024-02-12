.PHONY: install-neuvector
install-neuvector:
	#Add the neuvector Helm repository
	helm repo add neuvector https://neuvector.github.io/neuvector-helm/
	helm repo update; echo ""
	#Create the neuvector Kubernetes namespace
	kubectl create namespace cattle-neuvector-system || true; echo ""
	#Configure the NeuVector values file by adding the custom admin password
	cp ./resources/neuvector/custom-helm-values.yaml.tpl ./resources/neuvector/custom-helm-values.yaml
	read -p "Enter the NeuVector admin password: " NV_ADMIN_PASSWORD; sed -i '' "s@Password.*@Password: \"$$NV_ADMIN_PASSWORD\"@g" ./resources/neuvector/custom-helm-values.yaml; echo ""
	#Install the neuvector Chart
	helm install neuvector neuvector/core --values ./resources/neuvector/custom-helm-values.yaml -n cattle-neuvector-system || true; echo ""
	while [ -z "$$LB_EXTERNAL_IP" ]; do echo "LB not ready."; sleep 5; LB_EXTERNAL_IP="$$(kubectl -n cattle-neuvector-system get svc neuvector-service-webui --output jsonpath='{.status.loadBalancer.ingress[0].ip}')"; done; echo ""
	kubectl -n cattle-neuvector-system apply -f ./resources/neuvector/neuvector-service-rest.yaml || true; echo ""
	while [ -z "$$LB_EXTERNAL_IP" ]; do echo "LB not ready."; sleep 5; LB_EXTERNAL_IP="$$(kubectl -n cattle-neuvector-system get svc neuvector-service-rest --output jsonpath='{.status.loadBalancer.ingress[0].ip}')"; done; echo ""
	SERVICE_IP="$$(kubectl get svc -n cattle-neuvector-system neuvector-service-webui -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"; echo neuvectorUrl:\"https://$$SERVICE_IP:8443\"; echo ""

.PHONY: install-ingress-nginx
install-ingress-nginx:
	#Add the ingress-nginx (community) Helm repository
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update; echo ""
	#Create the ingress-nginx Kubernetes namespace
	kubectl create namespace ingress-nginx || true; echo ""
	#Install the ingress-nginx Chart with Kubernetes LoadBalancer service (disabled the ability to reach the LB via HTTP)
	helm install ingress-nginx ingress-nginx/ingress-nginx --set controller.service.enableHttp=false -n ingress-nginx || true; echo ""
	while [ -z "$$LB_EXTERNAL_IP" ]; do echo "LB not ready."; sleep 5; LB_EXTERNAL_IP="$$(kubectl -n ingress-nginx get svc ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')"; done; echo ""

.PHONY: install-jenkins
install-jenkins:
	#Add the jenkins Helm repository
	helm repo add jenkins https://charts.jenkins.io
	helm repo update; echo ""
	#Create the jenkins Kubernetes namespace
	kubectl create namespace jenkins || true; echo ""
	#Configure the Jenkins values file by adding the IP of the LoadBalancer created by Ingress as the Jenkins URL and the NeuVector admin password
	cp ./resources/jenkinsci/custom-helm-values.yaml.tpl ./resources/jenkinsci/custom-helm-values.yaml
	sed -i '' "s@jenkinsUrl.*@jenkinsUrl: \"https:\/\/$$(kubectl -n ingress-nginx get svc ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}').sslip.io\"@g" ./resources/jenkinsci/custom-helm-values.yaml; echo ""
	sed -i '' "s@controllerApiUrl.*@controllerApiUrl: \"https:\/\/$$(kubectl -n cattle-neuvector-system get svc neuvector-service-rest --output jsonpath='{.status.loadBalancer.ingress[0].ip}').sslip.io:10443\"@g" ./resources/jenkinsci/custom-helm-values.yaml; echo ""
	sed -i '' "s@password.*@password: $$(cat ./resources/neuvector/custom-helm-values.yaml | grep Password | awk -F: '{print $$2}' | sed 's/ //g')@g" ./resources/jenkinsci/custom-helm-values.yaml; echo ""
	#Install the jenkins Chart
	helm install jenkins jenkins/jenkins --values ./resources/jenkinsci/custom-helm-values.yaml -n jenkins || true; echo ""
	while [[ "$$JENKINS_CONTAINER_STATUS" != "2/2" ]]; do echo "Jenkins Controller pod is not ready."; sleep 5; JENKINS_CONTAINER_STATUS="$$(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller --no-headers | awk '{print $$2}')"; done; echo ""
	cat resources/jenkinsci/custom-helm-values.yaml | grep jenkinsUrl | sed 's/ //g'; echo ""
	#Add demo pipelines
	kubectl -n jenkins exec -it "$$(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller --no-headers | awk '{print $$1}')" -- mkdir /var/jenkins_home/jobs/scan-a-specific-docker-image || true #scan-a-specific-docker-image Job
	kubectl -n jenkins cp ../pipelines/scan-a-specific-docker-image/config.xml "$$(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller --no-headers | awk '{print $$1}')":/var/jenkins_home/jobs/scan-a-specific-docker-image/config.xml || true #scan-a-specific-docker-image Pipeline
	kubectl -n jenkins rollout restart statefulsets.apps jenkins || true #Reload Jenkins config
	while [[ "$$JENKINS_CONTAINER_STATUS" != "2/2" ]]; do echo "Jenkins Controller pod is not ready."; sleep 5; JENKINS_CONTAINER_STATUS="$$(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller --no-headers | awk '{print $$2}')"; done; echo ""

.PHONY: get-jenkins-admin-password
get-jenkins-admin-password:
	kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

.PHONY: upgrade-jenkins
upgrade-jenkins:
	helm upgrade jenkins jenkins/jenkins --values ./resources/jenkinsci/custom-helm-values.yaml -n jenkins || true; echo ""

.PHONY: uninstall-jenkins
uninstall-jenkins:
	#Uninstall jenkins
	helm uninstall jenkins -n jenkins || true
	JENKINS_CONTROLLER_POD="1"; while [[ ! -z "$$JENKINS_CONTROLLER_POD" ]]; do echo "Jenkins Controller pod still running."; sleep 5; JENKINS_CONTROLLER_POD="$$(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller --no-headers)"; done; echo ""
	kubectl delete namespace jenkins || true

.PHONY: uninstall-ingress-nginx
uninstall-ingress-nginx:
	#Uninstall ingress-nginx
	helm uninstall ingress-nginx -n ingress-nginx || true
	INGRESS_CONTROLLER_POD="1"; while [[ ! -z "$$INGRESS_CONTROLLER_POD" ]]; do echo "Ingress Controller pod still running."; sleep 5; INGRESS_CONTROLLER_POD="$$(kubectl -n ingress-nginx get pods -l app.kubernetes.io/component=controller --no-headers)"; done; echo ""
	kubectl delete namespace ingress-nginx || true

.PHONY: uninstall-neuvector
uninstall-neuvector:
	#Uninstall neuvector
	helm uninstall neuvector -n cattle-neuvector-system || true
	NEUVECTOR_PODS="1"; while [[ ! -z "$$NEUVECTOR_PODS" ]]; do echo "NeuVector pods are still running."; sleep 5; NEUVECTOR_PODS="$$(kubectl -n cattle-neuvector-system get pods --no-headers)"; done; echo ""
	kubectl -n cattle-neuvector-system delete -f ./resources/neuvector/neuvector-service-rest.yaml
	kubectl delete namespace cattle-neuvector-system || true
