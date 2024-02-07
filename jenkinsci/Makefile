.PHONY: install-jenkins
install-jenkins:
	helm repo add jenkins https://charts.jenkins.io
	helm repo update; echo ""
	kubectl create namespace jenkins || true; echo ""
	cp ./resources/custom-helm-values.yaml.tpl ./resources/custom-helm-values.yaml
	helm install jenkins jenkins/jenkins --values ./resources/custom-helm-values.yaml -n jenkins || true; echo ""
	while [ -z "$$LB_EXTERNAL_IP" ]; do echo "LB not ready."; sleep 5; LB_EXTERNAL_IP="$$(kubectl -n jenkins get svc jenkins --output jsonpath='{.status.loadBalancer.ingress[0].ip}')"; done; echo ""
	sed -i '' "s/jenkinsUrl.*/jenkinsUrl: $$(kubectl -n jenkins get svc jenkins --output jsonpath='{.status.loadBalancer.ingress[0].ip}').sslip.io/g" ./resources/custom-helm-values.yaml; echo ""
	echo JENKINS URL: https://"$$(kubectl -n jenkins get svc jenkins --output jsonpath='{.status.loadBalancer.ingress[0].ip}')".sslip.io:8080

.PHONY: get-jenkins-admin-password
get-jenkins-admin-password:
	kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

.PHONY: upgrade-jenkins
upgrade-jenkins:
	helm upgrade jenkins jenkins/jenkins --values ./resources/custom-helm-values.yaml -n jenkins || true; echo ""

.PHONY: uninstall-jenkins
uninstall-jenkins:
	helm uninstall jenkins -n jenkins || true
	JENKINS_CONTROLLER_POD="1"; while [[ ! -z "$$JENKINS_CONTROLLER_POD" ]]; do echo "Jenkins Controller pod still running."; sleep 5; JENKINS_CONTROLLER_POD="$$(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller --no-headers)"; done; echo ""
	kubectl delete namespace jenkins || true
