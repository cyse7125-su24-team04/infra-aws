# infra-aws


## 1. export the aws account
```sh
export AWS_PROFILE=csye7125dev   
```

## 2. deploy
```sh
terraform init
terraform plan
terraform apply
```

## 3. Following kubectl
Run the following command to retrieve the access credentials for your cluster and configure kubectl
```
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```
