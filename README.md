# Add_Load_Balancer_Using_Terraform

☁️ Load Balancer Deployment Using Terraform on Azure
📌 Project Description
This project demonstrates how to create and test an Azure Load Balancer setup using Terraform. It provisions complete infrastructure as code, including two virtual machines behind a public-facing load balancer. The goal is to ensure high availability and automatic traffic distribution.

🎯 Project Objectives
Deploy cloud infrastructure using Terraform
Use a Public Load Balancer to distribute traffic between two VMs
Ensure fault tolerance: when one VM is stopped, traffic is redirected to the other
Practice Infrastructure as Code (IaC) with Azure resources

🧰 Tools & Technologies Used
Cloud Provider: Microsoft Azure
IaC Tool: Terraform
Terraform Language: HCL (HashiCorp Configuration Language)

Resources Used:
Resource Group
Virtual Network (VNet)
Subnets
Public IP
Network Interfaces (NICs)
Network Security Groups (NSGs)
2 Virtual Machines (Ubuntu/Windows based)
Load Balancer (with frontend IP, backend pool, health probe, and rules)

⚙️ How I Did It (Steps)
Terraform Setup:
Wrote main.tf with provider and resource blocks
Declared authentication and region

Infrastructure Creation:
Created a Resource Group, VNet, and Subnets
Deployed two VMs (VM-01 and VM-02) in the same region
Attached NICs, NSGs, and associated them with the VMs

Load Balancer Setup:
Provisioned a Public IP
Created Frontend IP config, Backend address pool, and Health probe
Added Load Balancing Rules for traffic on port 80

Tested Load Balancer:
Accessed the app via the Load Balancer’s public IP
Stopped VM-01 to verify that traffic automatically routed to VM-02
Confirmed seamless traffic switching

✅ Result:
The public IP of the load balancer distributes incoming traffic to the VMs.
If one VM is down, the load balancer automatically redirects traffic to the healthy VM.
Achieved a basic high availability setup using Terraform and Azure Load Balancer.

💡 Learning Outcomes
Practical experience with Terraform resource blocks and provisioning

Hands-on understanding of Azure Load Balancer configuration

Gained confidence in infrastructure automation and fault-tolerant architecture

