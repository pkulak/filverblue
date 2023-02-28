# filverblue

My Silverblue boot container. It's pretty tailored to my specific tastes, but obviously feel free to give it a try.

Rebase to this, then check out my [distrobox container](https://github.com/pkulak/boxkit).

All thanks in the world to the [uBlue folks](https://github.com/ublue-os/) for inspiration and all the technique.

## Changes to Base Silverblue

### Sway

It's the best window manager, so I layer it, plus most of the bits and bobs that you need to make it delightful. Also, I stole the launcher script from the Fedora Sway spin.

### Firefox

The Fedora version is removed (use the Flatpak version instead).

### RPM Fusion

Sometimes you just gotta have a package or two from RPM Fusion. This container installs the RPM Fusion repos, installs any packages from `rpm-fusion`, then uninstalls the repos, keeping everything clean and tidy.

## Usage

Warning: This is an experimental feature and should not be used in production (yet), (however it's pretty close). Depending on the version of rpm-ostree on your system you might need to pass an additional `--experimental` flag

To rebase an existing Silverblue/Kinoite machine to the latest release: 

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/pkulak/filverblue:latest
