ELASTIC KUBERNETES SERVICE Brief explanation:

![image](https://github.com/olusegun45/EKS/blob/main/EC2/Architecture.JPG?raw=true)

Amazon Elastic Kubernetes Service (EKS) is a managed service for deploying and running containerized applications using Kubernetes. When you run an EKS cluster, the underlying infrastructure consists of a set of Amazon Elastic Compute Cloud (EC2) instances that serve as the nodes for your cluster. These instances run the Kubernetes control plane components, such as the API server, controller manager, and etcd, as well as your application containers.

The EC2 instances are created and managed by Amazon EKS, and you can specify the instance type and the number of nodes in your cluster. The instances run in an Amazon Virtual Private Cloud (VPC), and you can use security groups and network access control lists (ACLs) to control access to your cluster.

Amazon EKS handles the complex tasks of setting up and maintaining the Kubernetes control plane, so you can focus on deploying and running your applications. The service provides automatic upgrades, automatic failover, and multiple availability zones to ensure high availability and resiliency of your cluster.

EKS on EC2 OR EKS on Fargate:

Amazon Elastic Kubernetes Service (EKS) can run on either Amazon EC2 instances or Amazon Fargate. The main difference between these two options is the way that they manage the underlying infrastructure for your Kubernetes cluster.

EKS on EC2 instances:

1.  The nodes in your EKS cluster run on Amazon EC2 instances.
2.  You have full control over the instances, including the instance type, operating system, and the configuration of the instances.
3.  You are responsible for managing the instances, including updates, scaling, and security.
4.  This option provides the most flexibility and customization options for your cluster.

EKS on Fargate:

1.  The nodes in your EKS cluster run on Amazon Fargate, a serverless compute engine for containers.
2.  Fargate manages the underlying instances for you, so you don't have to worry about updates, scaling, or security.
3.  You don't have direct access to the instances, so you can't install additional software or configure the instances in a custom way.
4.  This option is the easiest and most streamlined option for running EKS, but it may not be suitable for all use cases because of the lack of customization options.

In summary, the choice between EKS on EC2 instances and EKS on Fargate depends on the requirements and use case of your Kubernetes cluster. EKS on EC2 instances provides more flexibility and control, while EKS on Fargate is more streamlined and easier to use.




to coment out all at once: "select all and press CTRL /"