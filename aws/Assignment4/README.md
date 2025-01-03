Assignement 04 

Objective: 
The goal of this assignment is to design and implement infrastructure of your individual tool using Terraform IaC (Infrastructure as Code) based on your architecture diagram. You will follow best practices, manage the Terraform state file in S3, and ensure consistent provider versioning throughout your code. 
Steps: 

Create an Infrastructure Architecture Diagram: 

-  Design an architecture diagram that outlines the infrastructure components you    plan to create. This should include networking, servers, load balancers,   auto-scaling groups, and any other necessary components. 
           -  Submit the architecture diagram for review and approval before moving to the    implementation phase. 

Implement the Infrastructure with Terraform: 

           -    Based on the approved architecture diagram, write Terraform code to provision the infrastructure. 
           -    Write static Terraform code to implement the infrastructure as per the reviewed architecture diagram.Good To Do: Terraform State Management-    Terraform State Management: Store the Terraform state file (tfstate) in an S3 bucket to enable remote state management.