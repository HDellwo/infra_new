**Simple Terraform configuration for AWS Infrastructure**

This Terraform configuration creates a basic AWS infrastructure with two EC2 instances: 
* **Public EC2 instance:** Placed in a public subnet with a public IP address.
* **Private EC2 instance:** Placed in a private subnet with internet access through a NAT Gateway. 

The networking components (VPC, subnets, route tables, and NAT Gateway) are modularized for better organization and reusability. 

[Image of AWS Infrastructure Diagram](infrastructure.png)
