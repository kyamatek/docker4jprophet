FROM ubuntu:14.04

ENV USER ubuntu
ENV HOME /home/${USER}

SHELL ["/bin/bash", "-c"]

RUN useradd -m ${USER}

RUN gpasswd -a ${USER} sudo

WORKDIR ${HOME}

RUN apt-get update -y && \
    apt-get install software-properties-common -y && \
    apt-get update && \
    apt-get install -y git \
                    wget \
                    vim \
                    build-essential \
				    subversion \
				    perl \
				    curl \
				    unzip \
				    cpanminus \
				    make \
                    && \
    wget https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz && \
    tar xvf ./openjdk-12.0.2_linux-x64_bin.tar.gz && \
    mv ./jdk-12.0.2/ /usr/local/ && \
    echo -e "\n# Java configuration" >> .bashrc && \
    echo 'export JAVA_HOME=/usr/local/jdk-12.0.2' >> .bashrc && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin' >> .bashrc && \
    echo $JAVA_HOME && \
    apt-get install -y language-pack-ja && \
    update-locale LANG=ja_JP.UTF-8 && \
    echo 'export LANG=ja_JP.UTF-8' >> .bashrc && \
    source .bashrc
    #rm -rf /var/lib/apt/lists/*

# install maven3.6.3
RUN wget https://ftp.riken.jp/net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz && \
    tar -xf apache-maven-3.6.3-bin.tar.gz && \
    mv apache-maven-3.6.3/ apache-maven/ && \
    mv apache-maven/ /opt/ && \
    echo 'export MVN_HOME="/opt/apache-maven"' >> /etc/profile.d/maven.sh && \
    echo 'export PATH="${MVN_HOME}/bin:${PATH}"' >> /etc/profile.d/maven.sh && \
    echo 'source /etc/profile.d/maven.sh' >> .bashrc && \
    source .bashrc

RUN apt-get install -y python3 python3-pip
# USER ${USER}

RUN git clone https://github.com/posl/jprophet && \
    echo "alias jp='cd /home/ubuntu/jprophet/src/main/java/jp/posl/jprophet'" >> .bashrc && \
    source .bashrc

# ----------- Step 1. Clone defects4j from github --------------
WORKDIR /
RUN git clone https://github.com/rjust/defects4j.git defects4j

# ----------- Step 2. Initialize Defects4J ---------------------
WORKDIR /defects4j
RUN cpanm --installdeps .
RUN ./init.sh

# ----------- Step 3. Add Defects4J's executables to PATH: ------
ENV PATH="/defects4j/framework/bin:${PATH}"  
#--------------

# USER root

RUN apt-get install -y sudo && \
    sed -i -e 's/%sudo.*ALL/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

WORKDIR ${HOME} 

COPY run.sh ./jprophet
COPY random_generator.py ./jprophet
COPY lines.txt ./jprophet
COPY d4j /usr/local/bin
RUN chmod a+x /usr/local/bin/d4j && \
    mkdir d4j

#USER ${USER}