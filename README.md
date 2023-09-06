# monitoring-osk-using-strimzi

## Preqrequisites:
Please ensure you have kubectl, terraform and minikube installed.


## Steps to follow:
- Clone the Github Repo. The files have already been modified where needed To see details of the modifications, please refer here: [Setup Prometheus and Grafana for OSK with Strimzi](https://docs.google.com/document/d/15TYyR7RR-FyGzo55X9pvoc8UY_BsLaXc4ltiO0VzKu8/edit)

- Start minikube: 
```
 minikube start
 ```
- Create namespaces: kafka and monitoring: 
```
 kubectl create ns kafka
 kubectl create ns monitoring
```
- Update your path in line 5 of main.tf.
- Initialize terraform:
```
 terraform init
```
- Execute the Terraform File:
```
 terraform apply
```
> If there is an error with port-forwarding and services not being found, please wait for the all the services to be up and running and then apply again.
- Manually create datasource and dashboard in Grafana in datasource url. You can use one of the json files from /monitoring-osk-using-strimzi/strimzi-0.35.1/examples/metrics/grafana-dashboards 
> Provide datasource URL as: http://host.docker.internal:9090
