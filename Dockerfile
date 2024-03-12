FROM jenkins/jenkins:lts-jdk17
# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y jq
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl  && mv ./kubectl /usr/local/bin/kubectl
RUN curl  -L https://app.harness.io/public/shared/tools/chaos/hce-cli/0.0.2/hce-cli-0.0.2-linux-amd64 > hce-cli && chmod +x hce-cli && mv hce-cli /usr/local/bin/hce-cli 
# drop back to the regular jenkins user - good practice
USER jenkins
