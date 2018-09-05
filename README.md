# Containerized NATS release for k8s


## Configuration

The scripts use minikube by default, start it first `minikube start`.

* `FISILE_ROLE_MANIFEST` needs to point to an absolute path

## Testing

You can connect to the deployed NATS server:

```
% sudo ip ro add 10.96.0.0/12 via 192.168.99.100
% curl $(kubectl --namespace my-nats get svc nats-public -o jsonpath="{.spec.clusterIP}"):4222
```

## Known Issues

If you can't download from gcp you need the gcloud CLI, and it needs to be authenticated.
