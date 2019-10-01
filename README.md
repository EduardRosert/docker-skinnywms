# docker-skinnywms
[skinnywms](https://github.com/ecmwf/skinnywms) packaged to run in a docker container with a simple demo application.

# Installation instructions
Follow these steps to manually create the docker image and make it available locally.

## Automatic image creation using make
```bash
#go to docker-skinnywms folder and run
make

#check if creation was successful
docker images
```
```
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
eduardrosert/skinnywms         latest              43d40f97ce60        1 minute ago        2.95GB
...
```

# Manually run image using kubernetes
If you want use a local image and don't want to pull it from dockerhub, make sure you tag the image first, otherwise by default kubernetes will try to pull the most recent version from a public repo.
```bash
docker tag eduardrosert/skinnywms:latest eduardrosert/skinnywms:localOnly
```

Create deployment
```bash
kubectl create deployment skinnywms --image eduardrosert/skinnywms:localOnly
```
Check pod status
```bash
kubectl get pods
```
result should look something like this:
```
NAME                         READY   STATUS    RESTARTS   AGE
skinnywms-756dffddd4-2xrgk   1/1     Running   0          18s
```

Expose deployment:
```bash
kubectl expose deployment skinnywms --type=LoadBalancer --port=5000
```
or if you are using a custom kubernetes cluster such as minikube or kubeadm
```bash
kubectl expose deployment skinnywms --type=NodePort --port=5000
```

List services
```bash
kubectl get service
```
you should see the service:
```
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
skinnywms    LoadBalancer   10.102.228.234   <pending>     5000:31508/TCP   10s
...
```

Make service accessable from outside
```bash
minikube service skinnywms
```

Get service url
```bash
minikube service skinnywms --url
```
example output:
```
http://192.168.99.101:31751
```

Access the demo application directly (starts a browser window)
```bash
minikube service skinnywms
```
In this example the GetCapabilities document should then be found at http://192.168.99.101:31751/wms/?request=GetCapabilities