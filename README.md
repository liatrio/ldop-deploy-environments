## LDOP Deploy Environments

This is a terraform configuration to set up dev, qa, and prod tomcat environments
to deploy to.

To run:

```
terraform apply
```

Enter your keypair name and a product name (ex. petclinic).

Environments will be available at dev.{product}.liatr.io, qa.{product}.liatr.io, and {product}.liatr.io

