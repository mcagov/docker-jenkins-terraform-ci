FROM 676563297163.dkr.ecr.eu-west-2.amazonaws.com/jenkins-base:latest

LABEL maintainer="info@catapult.cx"
LABEL org.label-schema.description="Default image for terrafom builds"

USER root

RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm" && \
    yum install -y session-manager-plugin.rpm && \
    rm -rf session-manager-plugin.rpm

RUN dnf install findutils -y && \
    git clone https://github.com/tfutils/tfenv.git /usr/local/.tfenv && \
    ln -s /usr/local/.tfenv/bin/* /usr/local/bin && \
    chown -R jenkins:jenkins /usr/local/.tfenv && \
    tfenv install 1.3.7  && \
    tfenv install 1.4.6  && \
    tfenv install 1.5.7  && \
    tfenv install 1.6.2  && \
    tfenv install 1.6.6  && \
    tfenv use 1.4.6 && \
    git clone https://github.com/iamhsa/pkenv.git /usr/local/.pkenv && \
    ln -s /usr/local/.pkenv/bin/* /usr/local/bin && \
    chown -R jenkins:jenkins /usr/local/.pkenv && \
    pkenv install 1.8.7  && \
    pkenv install 1.9.4  && \
    pkenv install 1.10.0  && \
    pkenv install 1.10.1  && \
    pkenv use 1.8.7 && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/local/bin && \
    chmod 0755 /usr/local/bin/kubectl

ADD icSsh /home/jenkins/icSsh
RUN chown -R jenkins:jenkins /home/jenkins/icSsh && \
    chown -R jenkins:jenkins /usr/local/.tfenv && \
    chown -R jenkins:jenkins /usr/local/.pkenv && \
    chmod +x /home/jenkins/icSsh

USER jenkins
WORKDIR /home/jenkins

RUN echo -n "tfenv:             " && \
    tfenv --version && echo ""  && \
    cd  /home/jenkins && \
    echo -n "terraform :         " && terraform --version && \
    echo -n "packer    :         " && packer --version  && \
    echo -n "kubectl   :         " && kubectl version --client
