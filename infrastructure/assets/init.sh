#!/bin/bash
timedatectl set-timezone Europe/Berlin
yum -y update
yum -y install centos-release-gluster41 centos-release-openshift-origin311 epel-release
yum -y install firewalld NetworkManager rng-tools bind-utils traceroute
yum -y install origin-clients nano docker
yum -y install glusterfs glusterfs-client-xlators glusterfs-libs glusterfs-fuse
systemctl enable NetworkManager docker firewalld rngd
setsebool -P virt_sandbox_use_fusefs on
setsebool -P virt_use_fusefs on
reboot