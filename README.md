# filverblue

My Silverblue boot container. It's pretty tailored to my specific tastes, but obviously feel free to give it a try.

Rebase to this, then check out my [distrobox container](https://github.com/pkulak/boxkit).

## Changes to Base Silverblue

### Sway

It's the best window manager, so I layer it, plus most of the bits and obobs that you need to make it delightful.

### Firefox

Removing the Silverblue Firefox and installing the Flatpak is great, but you know what's _even_ better? Installing FFMPEG so that the Silverblue compile has all the codecs it needs.

### Sublime Merge

I'm addicted and I've had some issues with the Flatpak, so throw it into the container. The RPM installs into /opt by default, so thank you to [cgwalters](https://github.com/coreos/rpm-ostree/issues/233#issuecomment-1301194050) or I would have never figured it out!

### Snapper

Running BTRFS and _not_ snapshotting your home directory seems like the silliest thing to me. Snapper is installed and snashots are set to start right after first boot.

## Usage

Warning: This is an experimental feature and should not be used in production (yet), (however it's pretty close). Depending on the version of rpm-ostree on your system you might need to pass an additional `--experimental` flag

To rebase an existing Silverblue/Kinoite machine to the latest release: 

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/pkulak/filverblue:latest
