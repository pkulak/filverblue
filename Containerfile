FROM quay.io/fedora-ostree-desktops/silverblue:37

# Layer some packages
COPY layers .

RUN rpm-ostree override remove firefox firefox-langpacks && \
    cat layers | xargs rpm-ostree install -y

# Start up some services
RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable rpm-ostree-countme.timer

# Cleanup and finalize
RUN rm layers && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
