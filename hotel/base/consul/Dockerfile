FROM hashicorp/consul:latest

USER root

RUN apk update \
  && apk add openrc util-linux htop vim openssh \
  && sed -i s/^#ttyS0/ttyS0/ /etc/inittab \
  && echo "root:root" | chpasswd \
  && echo ttyS0 > /etc/securetty \
  && rc-update add devfs boot \
  && rc-update add procfs boot \
  && rc-update add sysfs boot \
  && rc-update add sshd \
  && rc-update add local default

COPY consul /etc/init.d/consul
COPY devpts /etc/init.d/devpts

RUN rc-update add consul default
RUN rc-update add devpts boot

RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3gfpNn+kXCAbalFIBoXe08uJhdtpCmHPvK6wrN1Fmp firecracker-root' > /root/.ssh/authorized_keys && \
    chmod 700 /root /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root /root/.ssh /root/.ssh/authorized_keys
