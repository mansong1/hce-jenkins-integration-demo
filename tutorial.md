# HCE Jenkins Integration Demo Block

## Objective

- Illustrate how we can use Harness Chaos Engineering to run chaos experiments in a Jenkins CI/CD pipeline & how to rollback deployments based on chaos testing outcomes.

## Things You Need

- A Kubernetes cluster on which (an instrumented version of) the sample microservices application [online-boutique](https://github.com/GoogleCloudPlatform/microservices-demo) is deployed. Also, kubectl in your workspace.
- A Jenkins instance with basic plugins installed (including git plugin) running on the aforementioned Kubernetes cluster. Steps to set this up are explained in the subsequent sections

## Configuration 

### Step-1: Kubernetes 

- Follow instructions in the [Creating a demo application and observability infrastructure](https://developer.harness.io/tutorials/run-chaos-experiments/first-chaos-engineering#creating-a-demo-application-and-observability-infrastructure) to setup the Online-Boutique demo application

### Step-2: Harness

- Signup to the [Harness platform](https://app.harness.io) via email 

- Click on the verification email received. 

- Choose the Chaos Engineering Module. This will enable a 14-day enterprise trial license.

- You will see a modal asking to to "Enable Chaos Infrastructure To Run Your First Chaos Experiment". Proceed with setting up of the chaos infrastructure on the "default project". You can create a dedicated/new project if you wish. To setup the chaos infra, follow the steps outlined in [Connect Chaos Infrastructures](https://developer.harness.io/docs/chaos-engineering/user-guides/connect-chaos-infrastructures). 

- Add a new chaoshub by following the steps outlined in [Add Chaos Hub](https://developer.harness.io/docs/chaos-engineering/user-guides/add-chaos-hub) by using the GitHub repo URL https://github.com/ksatchit/boutique-chaos-demo

- Execute the chaos experiment **boutique-carts-cpu-starvation** following steps provided in [Launch Experiment From ChaosHub](https://developer.harness.io/docs/chaos-engineering/user-guides/construct-and-run-custom-chaos-experiments#launch-an-experiment-from-chaos-hub)

#### What Happens In This Chaos Experiment

- We hog the cpu resources in the pod belonging to the carts microservice, simulating a high-traffic situation in which the service is deprived of cpu cycles, leading to slower responses. The intent is to evaluate whether the slowness is handled within the system OR is propagated upwards to cause degraded user experience on the website's transactions.

- During this experiment, we validate the following hypotheses/constraints using "Resilience Probes":

  - Healthy Kubernetes resource status prior to and after fault injection
  - Continuous availability of the microservice under test
  - Expected levels of latency on the website upon user actions (simulated via loadgenerator)

****IMPORTANT: Note The Following Details From Your Harness Account****

1. **Account Scope Details** 

- The Account ID 
- The Project ID 
- The Chaos Experiment ID

  - These can be obtained from your session URL. For example, in this URL:
  
    `https://app.harness.io/ng/#/account/**JxE3EzyXSmWugTiJV48n6K**/chaos/orgs/default/projects/**default_project**/experiments/**d7c9d243-0219-4f7c-84g2-3004e59e4605**` 
   
    The strings marked in asterisk are the account, project & chaos experiment IDs respectively.  

2. **Account API-Key**

- From your account profile page, generate an API-Key & note the Token value. 

### Step-3: Jenkins 

#### 1. Prepare the Installation Manifests 

(Jenkins manifests are placed in k8s/jenkins) 

- Update the `kubernetes.io/hostname` label with the appropriate hostname from your Kubernetes cluster (you can derive it by performing a `kubectl get nodes --show-labels` command)
  in the [volume.yaml](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/f9337fd9f9682e9eff5b287017eb59e3697ac9c4/k8s/jenkins/volume.yaml#L33)

- Update the service type in the [service.yaml](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/f9337fd9f9682e9eff5b287017eb59e3697ac9c4/k8s/jenkins/service.yaml#L13) if needed (Default type used is `LoadBalancer`. If you are running this on-prem w/o ingress or in your machine, use `NodePort`)

#### 2. Install the Jenkins Instance

- Execute `kubectl apply` of the manifests provided & wait for the Jenkins pod to enter `Running` status 

#### 3. Configure Jenkins Instance

##### User Access & Plugin Setup 

- Access the Jenkins dashboard using the external IP/service endpoint 

- Follow instructions on the console screen to obtain the initial login password. Use `kubectl exec <jenkins-pod-name> -it sh -n devops-tools` to enter into
  the Jenkins pod. Perform `cat /var/lib/jenkins/secrets/initialAdminPassword` to see the password. 
  
- Login with user `admin` and the password derived above. 

- Follow along to **install recommended plugins** & **create a Jenkins user** (skip new user creation if you'd like to continue using the admin credentials)

##### Instance Configuration  

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

##### Pipeline Configuration 

- From the **Jenkins Dashboard**, click on **New Item**, select a **Pipeline** & click **OK**

- In the **General** section. select the checkbox for **GitHub project** & provide your repo's URL

- In the **Build Triggers** section, select the checkbox for **GitHub hook trigger for GITScm polling**

- In the **Pipeline** section, select the **Pipeline script from SCM** option in the **Definition** dropdown.  
  You may leave the Lightweight checkout selected/unchecked depending upon your need. 
  
- **Save and Apply** the the configuration 

- Update the WORKFLOW_ID parameter's default value in the [Jenkinsfile](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/f9337fd9f9682e9eff5b287017eb59e3697ac9c4/Jenkinsfile#L10)
  to your Chaos Experiment ID. 
  
## Pipeline Execution With Chaos Steps 

- Make a commit on the [cartservice deployment spec](https://github.com/ksatchit/hce-jenkins-integration-demo/blob/62691b15052e92f33ecc157a214710c04b3b80c1/k8s/cartservice.yaml#L25) to change the image to `karthiksatchitanand/cartservice:cra-0.1.0`

- Observe the triggered pipeline deploying the application changes & executing the chaos experiment. Navigate to the Harness platform to view the chaos experiment execution in progress

- Observe the Grafana dashboard to see the impact of chaos 

- Verify execution of the deployment rollback step on account of a less-than-expected [Resilience Score](https://developer.harness.io/docs/chaos-engineering/user-guides/manage-chaos-experiment-execution/analyze-chaos-experiment). 


### How It Works 

- The chaos steps in the pipeline invokes bash scripts which in turn leverages a CLI tool `hce-saas-api` to make API calls to launch, monitor and derive the resilience score for the chaos experiment. 

- This CLI tool takes the account details, API key (which we have stored as instance variables) and the chaos experiment ID (pipeline parameter) as arguments.

<img width="1538" alt="Screenshot 2023-03-31 at 8 40 54 AM" src="https://user-images.githubusercontent.com/21166217/229013285-50437312-f990-44ec-9906-2584d3646c7c.png">



