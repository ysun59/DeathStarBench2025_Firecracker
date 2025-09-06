FROM redis:latest

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        udev systemd-sysv openssh-server dnsutils iproute2 curl socat iperf3 iputils-ping fio \
        kmod tmux rng-tools hwloc-nox vim trace-cmd linuxptp strace msr-tools cpuid less htop && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    passwd -d root

COPY redis.service /etc/systemd/system/redis.service

RUN systemctl enable redis.service && \
    rm -f /etc/systemd/system/multi-user.target.wants/systemd-resolved.service && \
    rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service && \
    rm -f /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service && \
    ln -s /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount && \
    systemctl enable tmp.mount && \
    systemctl disable e2scrub_reap.service && \
    rm -vf /etc/systemd/system/timers.target.wants/*

RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3gfpNn+kXCAbalFIBoXe08uJhdtpCmHPvK6wrN1Fmp firecracker-root' > /root/.ssh/authorized_keys && \
    chmod 700 /root /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root /root/.ssh /root/.ssh/authorized_keys
