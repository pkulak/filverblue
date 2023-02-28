FROM quay.io/fedora-ostree-desktops/silverblue:37

# Delete some silly repos

RUN rm /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rm /etc/yum.repos.d/google-chrome.repo && \
    rm /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo && \
    rm /etc/yum.repos.d/rpmfusion-nonfree-steam.repo

# It's always bothered me that "vim" doesn't work...

RUN ln -s /usr/bin/vi /usr/bin/vim

# Layer some packages

COPY layers .

RUN rpm-ostree override remove firefox firefox-langpacks && \
    cat layers | xargs rpm-ostree install -y && \
    ostree container commit && \
    rm layers

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
