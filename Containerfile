FROM quay.io/fedora-ostree-desktops/silverblue:38

# Delete some silly repos

RUN rm /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rm /etc/yum.repos.d/google-chrome.repo && \
    rm /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo && \
    rm /etc/yum.repos.d/rpmfusion-nonfree-steam.repo

# Copy some configs from ublue

COPY --from=ghcr.io/ublue-os/config:latest /files/ublue-os-udev-rules /
COPY --from=ghcr.io/ublue-os/config:latest /files/ublue-os-update-services /

# Setup RPM fusion

RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-38.noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-38.noarch.rpm && \
    ostree container commit

# Layer some packages

COPY layers .

RUN cat layers | xargs rpm-ostree install -y && \
    ostree container commit && \
    rm layers

# Remove RPM fusion

RUN rpm-ostree uninstall rpmfusion-free-release rpmfusion-nonfree-release && \
    ostree contrainer commit

# Use a nice runner script for Sway

COPY start-sway /usr/bin/
RUN sed -i 's/Exec.*/Exec=start-sway/' /usr/share/wayland-sessions/sway.desktop

# Start up some services

RUN systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable rpm-ostree-countme.timer && \
    systemctl enable flatpak-system-update.timer

