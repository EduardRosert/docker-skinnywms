# docker-skinnywms
[![Docker Automated build](https://img.shields.io/docker/cloud/automated/eduardrosert/skinnywms.svg)](https://hub.docker.com/r/eduardrosert/skinnywms)
[![Docker Build Status](https://img.shields.io/docker/cloud/build/eduardrosert/skinnywms.svg)](https://hub.docker.com/r/eduardrosert/skinnywms)

[skinnywms](https://github.com/ecmwf/skinnywms) packaged to run in a docker container with a simple demo application.

# Run with Docker
The image is available on Dockerhub as ``eduardrosert/skinnywms``. If you have Docker already installed on your machine, just do the following to run the image.

## Run the image on your machine
Run the demo applicaton and publish port ``5000``. The ``--rm`` switch makes sure that docker leaves no temporary files behind, when you stop the image:
```bash
docker run --rm -p 5000:5000 eduardrosert/skinnywms
```
Now you can type http://localhost:5000 on the machine running docker to access the demo application.

## Run interactive shell
Run interactive shell ``/bin/bash`` in docker image ``eduardrosert/skinnywms`` or any other command for that matter overriding the default CMD instruction from the docker image:
```bash
docker run --rm -i -t -p 5000:5000 eduardrosert/skinnywms /bin/bash
```

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
