FROM quay.io/fedora-ostree-desktops/silverblue:37

# Delete some silly repos

RUN rm /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rm /etc/yum.repos.d/google-chrome.repo && \
    rm /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo && \
    rm /etc/yum.repos.d/rpmfusion-nonfree-steam.repo

# Install stuff from RPM Fusion

COPY rpm-fusion .

RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-37.noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-37.noarch.rpm && \
    ostree container commit && \
    cat rpm-fusion | xargs rpm-ostree install -y && \
    rpm-ostree uninstall rpmfusion-free-release rpmfusion-nonfree-release && \
    ostree container commit && \
    rm rpm-fusion

# It's always bothered me that "vim" doesn't work...

RUN ln -s /usr/bin/vi /usr/bin/vim

# Layer some packages

COPY layers .

RUN rpm-ostree override remove firefox firefox-langpacks && \
    cat layers | xargs rpm-ostree install -y && \
    ostree container commit && \
    rm layers

# I'm not 100% sure this is still needed, but I don't think it can hurt.
# https://www.reddit.com/r/Fedora/comments/l944bb/is_it_possible_to_install_silverblue_on_an/gnmktzx/

RUN rpm-ostree kargs --append='rd.luks.options=discard' && \
    ostree container commit

# Start up some services

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable rpm-ostree-countme.timer

# Use a nice runner script for Sway

COPY start-sway /usr/bin/
RUN sed -i 's/Exec.*/Exec=start-sway/' /usr/share/wayland-sessions/sway.desktop

# Cleanup and finalize

RUN rm -rf /tmp/* /var/* && \
    ostree container commit
