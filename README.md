# filverblue

My Silverblue boot container. FFMPEG is installed so that Firefox can access all the codecs it needs, Sway is installed, Snapper is set up to run on /home, and some other niceties.

Rebase to this, then check out my [distrobox container](https://github.com/pkulak/boxkit).

## Usage

Warning: This is an experimental feature and should not be used in production (yet), however it's pretty close) Depending on the version of rpm-ostree on your system you might need to pass an additional `--experimental` flag

To rebase an existing Silverblue/Kinoite machine to the latest release: 

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/pkulak/filverblue:latest
