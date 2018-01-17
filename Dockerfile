FROM centos:7.4.1708

RUN yum makecache fast \
    && yum provides '*/applydeltarpm' \
    && yum -y install \
              --setopt=tsflags=nodocs \
              --disableplugin=fastestmirror \
            deltarpm \
            bash-completion \
            epel-release \
            initscripts \
            sudo \
    && yum clean all \
    && yum -y upgrade \
    && yum clean all

CMD ["/bin/bash"]