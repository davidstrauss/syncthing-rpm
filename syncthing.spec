%global debug_package %{nil}

Name:syncthing
Version:0.10.29
Release:1.0%{?dist}
Summary:Syncthing
License:MIT
URL:http://syncthing.net/
Source0:https://github.com/syncthing/syncthing/archive/v%{version}.tar.gz
Source1: syncthing@.service
BuildRequires: systemd
BuildRequires:  gcc
BuildRequires:  golang >= 1.3

Requires(post): systemd
Requires(preun): systemd
Requires(postun): systemd

%description
Syncthing replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized. Your data is your data alone and you deserve to choose where it is stored, if it is shared with some third party and how it's transmitted over the Internet.

Using syncthing, that control is returned to you.

%prep
%setup -q -n syncthing-%{version}

%build
mkdir -p ./_build/src/github.com/syncthing
ln -s $(pwd) ./_build/src/github.com/syncthing/syncthing
export GOPATH=$(pwd)/_build:%{gopath}
go run build.go

%install
mkdir -p %{buildroot}%{_unitdir}
install -p -m 0644 %{S:1} %{buildroot}%{_unitdir}

install -d %{buildroot}%{_bindir}
install -p -m 0755 ./bin/syncthing %{buildroot}%{_bindir}/syncthing

%post
%systemd_post %{name}@.service

%preun
%systemd_preun %{name}@.service

%postun
%systemd_postun_with_restart %{name}@.service 

%files
%defattr(-,root,root,-)
%doc README.txt LICENSE.txt CONTRIBUTORS.txt
%{_bindir}/syncthing
%{_unitdir}/%{name}@.service

%changelog
* Fri Nov 28 2014 David Strauss <thunderbirdtr@fedoraproject.org> 0.10.8-2.0
- Initial version
