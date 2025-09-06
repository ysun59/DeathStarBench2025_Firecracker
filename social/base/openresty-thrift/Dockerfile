FROM yg397/openresty-thrift:xenial

USER root

# udev is needed for booting a "real" VM, setting up the ttyS0 console properly
# kmod is needed for modprobing modules
# systemd is needed for running as PID 1 as /sbin/init
# Also, other utilities are installed
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        udev systemd-sysv openssh-server dnsutils iproute2 curl socat iperf3 iputils-ping fio \
        kmod tmux rng-tools hwloc-nox vim trace-cmd linuxptp strace msr-tools cpuid less dnsmasq && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    passwd -d root

# Create the following files, but unset them
RUN echo "" > /etc/machine-id

COPY dnsmasq.conf /etc/dnsmasq.conf

# This container image doesn't have locales installed. Disable forwarding the
# user locale env variables or we get warnings such as:
#  bash: warning: setlocale: LC_ALL: cannot change locale
RUN sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config

COPY openresty.service /etc/systemd/system/openresty.service

RUN systemctl enable openresty && \
    systemctl enable dnsmasq && \
    rm -f /etc/systemd/system/multi-user.target.wants/systemd-resolved.service && \
    rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service && \
    rm -f /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service && \
    cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount && \
    systemctl enable tmp.mount && \
    rm -vf /etc/systemd/system/timers.target.wants/*

# adopted from docker volume
COPY ./nginx-web-server/lua-scripts /usr/local/openresty/nginx/lua-scripts
COPY ./nginx-web-server/pages /usr/local/openresty/nginx/pages
COPY ./nginx-web-server/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./nginx-web-server/jaeger-config.json /usr/local/openresty/nginx/jaeger-config.json
COPY ./gen-lua /gen-lua
COPY ./openresty-thrift/lua-thrift /usr/local/openresty/lualib/thrift

RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3gfpNn+kXCAbalFIBoXe08uJhdtpCmHPvK6wrN1Fmp firecracker-root' > /root/.ssh/authorized_keys && \
    chmod 700 /root /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root /root/.ssh /root/.ssh/authorized_keys
