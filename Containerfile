FROM quay.io/fedora-ostree-desktops/silverblue:37

COPY layers .

# Layer some packages
RUN rpm-ostree override remove firefox firefox-langpacks && \
    cat layers | xargs rpm-ostree install

# Get snapper running on /var/home
COPY snapper /etc/snapper/configs/home

RUN mkdir /etc/conf.d && \
    echo "SNAPPER_CONFIGS=\"home\"" > /etc/conf.d/snapper

# Start up some services
RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable rpm-ostree-countme.timer && \
    systemctl enable snapper-timeline.timer && \
    systemctl enable snapper-cleanup.timer

# Cleanup and finalize
RUN rm layers && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
