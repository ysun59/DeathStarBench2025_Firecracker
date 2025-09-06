FROM deathstarbench/hotel-reservation AS base

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        udev systemd-sysv openssh-server dnsutils iproute2 curl socat iperf3 iputils-ping fio \
        kmod tmux hwloc-nox vim trace-cmd linuxptp strace msr-tools cpuid htop less && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    passwd -d root || true && \
    mkdir /etc/systemd/system/serial-getty@ttyS0.service.d

COPY serial-getty@ttyS0.override.conf /etc/systemd/system/serial-getty@ttyS0.service.d/override.conf

RUN rm -f /etc/systemd/system/multi-user.target.wants/systemd-resolved.service && \
    rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service && \
    rm -f /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service && \
    ln -s /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount && \
    systemctl enable tmp.mount || true && \
    systemctl disable e2scrub_reap.service || true && \
    rm -vf /etc/systemd/system/timers.target.wants/* || true

RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3gfpNn+kXCAbalFIBoXe08uJhdtpCmHPvK6wrN1Fmp firecracker-root' > /root/.ssh/authorized_keys && \
    chmod 700 /root /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root /root/.ssh /root/.ssh/authorized_keys

COPY attractions.service frontend.service geo.service profile.service rate.service recommendation.service reservation.service review.service search.service user.service /etc/systemd/system/




FROM base AS attractions
RUN systemctl enable attractions.service

FROM base AS frontend
RUN systemctl enable frontend.service

FROM base AS geo
RUN systemctl enable geo.service

FROM base AS profile
RUN systemctl enable profile.service

FROM base AS rate
RUN systemctl enable rate.service

FROM base AS recommendation
RUN systemctl enable recommendation.service

FROM base AS reservation
RUN systemctl enable reservation.service

FROM base AS review
RUN systemctl enable review.service

FROM base AS search
RUN systemctl enable search.service

FROM base AS user
RUN systemctl enable user.service
