#### Prerequisites

- GCP account configured and authenticated

```bash
$ gcloud auth application-default login
```

Note: project-id can be configured directly in `main.tf` or by passing `-var 'gcp_project=XXX'` to the `terraform plan` command.

- GCP project created

- Terraform installed

```bash
$ brew install terraform
```


#### First deployment

This will deploy the whole infrastructure using default VM image
`ubuntu-os-cloud/ubuntu-minimal-1804-lts`

Plan and verify what will happen:


```bash
# Plan
$ terraform plan -out tf.plan

# Execute the plan
$ terraform apply "tf.plan"
```

#### Upgrade VMs to new image

For flexibility, we define the image as a variable so we can define it in the command line:

```bash

# Plan
$ terraform plan -var 'image_id=ubuntu-os-cloud/ubuntu-minimal-2004-lts' -out tf.plan

# Execute the plan
$ terraform apply "tf.plan"
```

#### Cleanup

Destroy all resources in the project

```bash
$ terraform destroy
```
