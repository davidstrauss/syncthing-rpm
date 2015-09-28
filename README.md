
# Syncthing RPM #

The steps were tested on Fedora 21 with Syncthing:
*   [v0.10.29][1]
*   [v0.11.25][2]

## Automated script ##

*   Build RPM, install it, enable and start `syncthing` service
    for specific user (`uvsmtid`, for example):

    ```
    sudo ./bootstrap_syncthing.sh uvsmtid
    ```

## Detailed manual steps ##

*   Create a working directory for Git repo
    (used for all subsequent commands):

    ```
    mkdir syncthing-rpm.git
    cd syncthing-rpm.git
    ```

*   Install necessary build tools:

    ```
    sudo yum install -y tito git golang git-annex
    ```

*   Clone this RPM build repo:

    ```
    git clone git@github.com:uvsmtid/syncthing-rpm.git .
    ```

*   Download Syncthing sources referenced through `git-annex`:

    ```
    git annex get
    ```

*   Build Syncthing RPM package:

    ```
    tito build --rpm --offline
    ```

*   Install `syncthing` RPM package
    (path reported in the previous build command):

    ```
    sudo rpm -Uvh PATH-TO-RPM
    ```

*   Enable, start and check status of `syncthing` service for specific user
    (for example, `uvsmtid`):

    ```
    sudo systemctl enable syncthing@uvsmtid
    sudo systemctl start syncthing@uvsmtid
    sudo systemctl status syncthing@uvsmtid
    ```

*   Check candidate port used by the service to provide web GUI:

    ```
    ss -tlpn | grep 127.0.0.1 | grep syncthing
    ```

    For example, the output might be like this:

    ```
    LISTEN     0      128               127.0.0.1:36428                    *:*      users:(("syncthing",pid=969,fd=8))
    ```

*   Access web GUI:

    ```
    firefox 127.0.0.1:36428
    ```

# [footer] #

[1]: https://github.com/syncthing/syncthing/releases/tag/v0.10.29
[2]: https://github.com/syncthing/syncthing/releases/tag/v0.11.25

