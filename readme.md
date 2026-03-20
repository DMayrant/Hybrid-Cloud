# AWS Direct Connect and Site-to-site VPN 🛜 WAN

Most businesses have multi-cloud integration for additional storage, cost optimization, data archives and disaster recovery. Understanding networking is important to isolating workloads in both the cloud and on-premise, and for communication between both environments. AWS direct Connect is a networking service that allows an on-premise environment to connect to multiple clouds within the same region without using the public internet. Network bandwidth requirements need to be specified ranging from 1 Gbps to 100 Gbps. While hosted connections through partners allow 50 Mbps to 10 Gbps depending on bandwidth requirements 

Site-to-site VPN 🌏

A site-to-site VPN provides a secure encrypted layer 3 IPsec tunnel and is often used with AWS DX, since DX doesn't encrypt traffic by default. The VPN consist of the customer gateway that acts as the VPN connecter on the on-premise side and virtual private gateway that acts as VPN connector for the cloud. To use a site-to-site VPN with AWS DX, low latency is needs to be required with predictable bandwidth and larger data volumes being transferred between on-premise and the cloud. The goal is establish high redundancy and low latency while maintaining cost optimization 

# Terraform commands 🚧

```bash
terraform init
terraform fmt 
terraform plan
terraform apply
```
To view specific services 

```bash 
terraform state show <resource>
terraform state list | grep <resource>
```
![image alt](https://github.com/DMayrant/Hybrid-Cloud/blob/main/Hybrid-Cloud.jpeg?raw=true)
