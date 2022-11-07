# cat Dockerfile
FROM ubuntu
RUN mkdir -p /var/run/sshd
RUN apt -y update
RUN apt install -y openjdk-11-jdk
RUN apt install -y openssh-server git
RUN ssh-keygen -A
ADD ./sshd_config /etc/ssh/sshd_config
RUN echo root:password123 | chpasswd
CMD ["/usr/sbin/sshd", "-D"]