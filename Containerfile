FROM quay.io/fedora-ostree-desktops/silverblue:37

# Install and configure snapper
RUN rpm-ostree install --apply-live snapper
COPY snapper /etc/snapper/configs/home
RUN echo "SNAPPER_CONFIGS=\"home\"" > /etc/conf.d/snapper

# Layer some packages
COPY layers .

RUN rpm-ostree override remove firefox firefox-langpacks && \
    cat layers | xargs rpm-ostree install

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
