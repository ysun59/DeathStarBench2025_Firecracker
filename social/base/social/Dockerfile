FROM deathstarbench/social-network-microservices:latest AS intermediate

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

COPY compose-post.service /etc/systemd/system/compose-post.service
COPY home-timeline.service /etc/systemd/system/home-timeline.service
COPY media.service /etc/systemd/system/media.service
COPY post-storage.service /etc/systemd/system/post-storage.service
COPY social-graph.service /etc/systemd/system/social-graph.service
COPY text.service /etc/systemd/system/text.service
COPY unique-id.service /etc/systemd/system/unique-id.service
COPY url-shorten.service /etc/systemd/system/url-shorten.service
COPY user-mention.service /etc/systemd/system/user-mention.service
COPY user-timeline.service /etc/systemd/system/user-timeline.service
COPY user.service /etc/systemd/system/user.service

RUN systemctl enable dnsmasq && \
    rm -f /etc/systemd/system/multi-user.target.wants/systemd-resolved.service && \
    rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service && \
    rm -f /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service && \
    cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount && \
    systemctl enable tmp.mount && \
    rm -vf /etc/systemd/system/timers.target.wants/*

# adopted from docker volume
COPY ./config /social-network-microservices/config

RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3gfpNn+kXCAbalFIBoXe08uJhdtpCmHPvK6wrN1Fmp firecracker-root' > /root/.ssh/authorized_keys && \
    chmod 700 /root /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root /root/.ssh /root/.ssh/authorized_keys


FROM intermediate AS compose-post
RUN systemctl enable compose-post.service

FROM intermediate AS home-timeline
RUN systemctl enable home-timeline.service

FROM intermediate AS media
RUN systemctl enable media.service

FROM intermediate AS post-storage
RUN systemctl enable post-storage.service

FROM intermediate AS social-graph
RUN systemctl enable social-graph.service

FROM intermediate AS text
RUN systemctl enable text.service

FROM intermediate AS unique-id
RUN systemctl enable unique-id.service

FROM intermediate AS url-shorten
RUN systemctl enable url-shorten.service

FROM intermediate AS user-mention
RUN systemctl enable user-mention.service

FROM intermediate AS user-timeline
RUN systemctl enable user-timeline.service

FROM intermediate AS user
RUN systemctl enable user.service
