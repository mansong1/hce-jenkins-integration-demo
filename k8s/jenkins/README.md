# Steps to Setup Jenkins 

## 1. Prepare the Installation Manifests 

- Update the `kubernetes.io/hostname` label with the appropriate hostname from your Kubernetes cluster (you can derive it by performing a `kubectl get nodes --show-labels` command)
  in the [volume.yaml](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/f9337fd9f9682e9eff5b287017eb59e3697ac9c4/k8s/jenkins/volume.yaml#L33)

- Update the service type in the [service.yaml](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/f9337fd9f9682e9eff5b287017eb59e3697ac9c4/k8s/jenkins/service.yaml#L13) if needed (Default type used is `LoadBalancer`. If you are running this on-prem w/o ingress or in your machine, use `NodePort`)

## 2. Install the Jenkins Instance

- Execute `kubectl apply` of the manifests provided & wait for the Jenkins pod to enter `Running` status 

## 3. Configure Jenkins Instance

### User Access & Plugin Setup 

- Access the Jenkins dashboard using the external IP/service endpoint 

- Follow instructions on the console screen to obtain the initial login password. Use `kubectl exec <jenkins-pod-name> -it sh -n devops-tools` to enter into
  the Jenkins pod. Perform `cat /var/lib/jenkins/secrets/initialAdminPassword` to see the password. 
  
- Login with user `admin` and the password derived above. 

- Follow along to **install recommended plugins** & **create a Jenkins user** (skip new user creation if you'd like to continue using the admin credentials)

### Instance Configuration  

- In the **Manage Jenkins** page, select **Configure System**. 

- In the **Jenkins Location** section, provide the Jenkins URL

- In the **Global Properties** section, select the checkbox for **Environment Variables** and add the key:value pairs for the following Harness account details:

  - ACCOUNT_ID
  - PROJECT_ID
  - API_KEY

- In the **GitHub** section, add a **GitHub server**. Use a desired **Name**, leave the **API URL** at the default `https://api.github.com` and add 
  credentials (your GitHub Username/Password or Personal Access Token) by leveraging the Jenkins Secret Manager. Validate connectivity by clicking on the 
  **Test Connection** button. Also, select the checkbox to **Manage Hooks**. 
  
- **Apply & Save** the configuration  
  
**Note**: If you face issues in saving forms or in navigating Jenkins screens, you may want to select the checkbox to **Enable Proxy Compatibility**  in 
the **CSRF Protection** section of the **Configure Global Security** page. 

### Pipeline Configuration 

- From the **Jenkins Dashboard**, click on **New Item**, select a **Pipeline** & click **OK**

- In the **General** section. select the checkbox for **GitHub project** & provide your repo's URL

- In the **Build Triggers** section, select the checkbox for **GitHub hook trigger for GITScm polling**

- In the **Pipeline** section, select the **Pipeline script from SCM** option in the **Definition** dropdown.  
  You may leave the Lightweight checkout selected/unchecked depending upon your need. 
  
- **Save and Apply** the the configuration 

- Update the WORKFLOW_ID parameter's default value in the [Jenkinsfile](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/f9337fd9f9682e9eff5b287017eb59e3697ac9c4/Jenkinsfile#L10)
  to your Chaos Experiment ID. 
  
  
