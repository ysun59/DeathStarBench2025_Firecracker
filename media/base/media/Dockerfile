FROM yg397/media-microservices AS intermediate

USER root

# udev is needed for booting a "real" VM, setting up the ttyS0 console properly
# kmod is needed for modprobing modules
# systemd is needed for running as PID 1 as /sbin/init
# Also, other utilities are installed
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        udev systemd-sysv openssh-server dnsutils iproute2 curl socat iperf3 iputils-ping fio \
        kmod tmux rng-tools hwloc-nox vim trace-cmd linuxptp strace msr-tools cpuid less dnsmasq htop && \
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

COPY unique-id.service /etc/systemd/system/unique-id.service
COPY movie-id.service /etc/systemd/system/movie-id.service
COPY text.service /etc/systemd/system/text.service
COPY rating.service /etc/systemd/system/rating.service
COPY user.service /etc/systemd/system/user.service
COPY compose-review.service /etc/systemd/system/compose-review.service
COPY review-storage.service /etc/systemd/system/review-storage.service
COPY user-review.service /etc/systemd/system/user-review.service
COPY movie-review.service /etc/systemd/system/movie-review.service
COPY cast-info.service /etc/systemd/system/cast-info.service
COPY plot.service /etc/systemd/system/plot.service
COPY movie-info.service /etc/systemd/system/movie-info.service

RUN systemctl enable dnsmasq && \
    rm -f /etc/systemd/system/multi-user.target.wants/systemd-resolved.service && \
    rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service && \
    rm -f /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service && \
    cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount && \
    systemctl enable tmp.mount && \
    rm -vf /etc/systemd/system/timers.target.wants/*

RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3gfpNn+kXCAbalFIBoXe08uJhdtpCmHPvK6wrN1Fmp firecracker-root' > /root/.ssh/authorized_keys && \
    chmod 700 /root /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown root:root /root /root/.ssh /root/.ssh/authorized_keys


FROM intermediate AS unique-id
RUN systemctl enable unique-id.service

FROM intermediate AS movie-id
RUN systemctl enable movie-id.service

FROM intermediate AS text
RUN systemctl enable text.service

FROM intermediate AS rating
RUN systemctl enable rating.service

FROM intermediate AS user
RUN systemctl enable user.service

FROM intermediate AS compose-review
RUN systemctl enable compose-review.service

FROM intermediate AS review-storage
RUN systemctl enable review-storage.service

FROM intermediate AS user-review
RUN systemctl enable user-review.service

FROM intermediate AS movie-review
RUN systemctl enable movie-review.service

FROM intermediate AS cast-info
RUN systemctl enable cast-info.service

FROM intermediate AS plot
RUN systemctl enable plot.service

FROM intermediate AS movie-info
RUN systemctl enable movie-info.service
