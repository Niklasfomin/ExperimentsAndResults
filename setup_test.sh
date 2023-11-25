#!/bin/bash
namespace="cws"

kubectl create namespace $namespace
kubectl apply -f setup/pvc.yaml --namespace $namespace
kubectl apply -f setup/management.yaml --namespace $namespace
kubectl wait --for=condition=ready pod management --namespace $namespace

# Label the pods for correct deployment of CWS

kubectl label nodes minikube-m02 minikube-m03 cwsexperiment=true  
kubectl label nodes minikube-m04 cwsscheduler=true
kubectl cp setup/nanoseqPatch.diff $namespace/management:/input/
kubectl cp setup/commands_test.sh $namespace/management:/input/

kubectl apply -f setup/accounts.yaml --namespace $namespace

# if you face any problems, run this manually in the pod.
kubectl exec  --namespace $namespace management -- /bin/bash /input/commands_test.sh
