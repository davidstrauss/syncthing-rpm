Syncthing RPM
=============

RPM packaging for Syncthing. Please use Copr to install directly.

Building and installing an RPM
---------------

    sudo yum install -y tito git
    git clone git@github.com:davidstrauss/syncthing-rpm.git
    cd syncthing-rpm
    tito build --rpm --offline
    sudo rpm -Uvh PATH-TO-RPM

Installation from Copr
----------------------

    sudo yum install -y dnf dnf-plugins-core
    sudo dnf copr enable davidstrauss/syncthing
    sudo dnf install -y syncthing
    sudo systemctl start syncthing@$USER.service
    sudo systemctl enable syncthing@$USER.service
