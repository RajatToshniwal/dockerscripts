FROM centos:6
MAINTAINER Rajat Toshniwal
# update yum
RUN yum update -y && yum clean all
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel
# Install python2.7
ADD Python-2.7.8.tgz /opt/
ADD setuptools-1.4.2.tar.gz /opt/
WORKDIR /opt
#    tar xvfz Python-2.7.8.tgz && \
RUN    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python
# Install setuptools + pip
RUN    cd setuptools-1.4.2 && \
    python2.7 setup.py install
# Mongo Installation
RUN echo -e "[mongodb-org-3.2]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/6Server/mongodb-org/3.4/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc" > /etc/yum.repos.d/mongodb-org.repo
RUN yum install -y mongodb-org
RUN service mongod start
#Download Tomcat 7 and copy to /usr/local RUN yum -y install tar
#RUN mkdir -p /opt/java7
#ADD jdk-7u72-linux-x64.tar.gz /opt/java7
RUN mkdir -p /opt/java7 && cd /opt/java7 && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u72-b14/jdk-7u72-linux-x64.tar.gz" && tar xvzf jdk-7u72-linux-x64.tar.gz
WORKDIR /opt/java7
RUN alternatives --install /usr/bin/java java /opt/java7/jdk1.7.0_72/bin/java 1
RUN alternatives --install /usr/bin/jar jar /opt/java7/jdk1.7.0_72/bin/jar 1
RUN alternatives --install /usr/bin/javac javac /opt/java7/jdk1.7.0_72/bin/javac 1
RUN echo "JAVA_HOME=/opt/java7/jdk1.7.0_72" >> /etc/environment
ADD apache-tomcat-7.0.76.tar.gz /usr/share/
#RUN cd /usr/share/ && wget http://apache.cs.utah.edu/tomcat/tomcat-7/v7.0.76/bin/apache-tomcat-7.0.76.tar.gz  && tar -xvzf apache-tomcat-7.0.76.tar.gz
WORKDIR /usr/share/
RUN mv  apache-tomcat-7.0.76 tomcat7
RUN echo "JAVA_HOME=/opt/jdk1.7.0_72/" >> /etc/default/tomcat7
RUN groupadd tomcat
RUN useradd -s /bin/bash -g tomcat tomcat
RUN chown -Rf tomcat.tomcat /usr/share/tomcat7
RUN  /usr/share/tomcat7/bin/startup.sh
EXPOSE 8080
