#!/bin/sh

# This script simply repeats manual steps described in `README.md` file
# except steps to clone Git repository where this file belongs to.

# Enable debug:
set -x
# Fail on uninitialized variables:
set -u
# Fail on non-zero exit code:
set -e

# Get user from command line args.
# This user is assumed to have read-write rights to the Git repo.
USERNAME="${1}"

# Get script location (root of the Git repo):
GIT_ROOT="$(dirname "${0}")"

# Continue running all commads from Git repo root:
cd "${GIT_ROOT}"

# This script is supposed to be run as `root`.
if [ "$(id -u)" != "0" ]
then
    echo "error: run script as root: sudo ${0} ${@}" 1>&2
    exit 1
fi

# The following commands pretty much repeat manual steps from `README.md`
# with few modifications:
# * Stop on any non-zero error code.
# * Use regular user where possible.
# * Use debug output where possible.
# * Add some output processing to fully automate steps.

sudo yum install -y tito git golang git-annex

sudo -u "${USERNAME}" git annex get

sudo -u "${USERNAME}" tito build --rpm --offline --debug

# Get package name format:
RPM_NAME_FORMAT="$(sudo -u "${USERNAME}" rpm --eval=%{_build_name_fmt})"

# Note: `tito` runs `rpmbuild` with `--define "_rpmdir /tmp/tito"`, therefore,
# all built packages are relative to `/tmp/tito` directory.

# Get package file path:
RPM_PATH="$(sudo -u "${USERNAME}" rpm --query --specfile 'syncthing.spec' --qf "/tmp/tito/${RPM_NAME_FORMAT}")"

sudo rpm -Uvh --force "${RPM_PATH}"

sudo systemctl enable syncthing@uvsmtid
sudo systemctl restart syncthing@uvsmtid
sudo systemctl status syncthing@uvsmtid

