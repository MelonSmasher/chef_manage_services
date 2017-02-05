name 'manage_services'
maintainer 'Alex Markessinis'
maintainer_email 'markea125@gmail.com'
license 'MIT'
description 'Manage system services through attributes while providing all service resource options provided by Chef.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.2.0'
%w( aix amazon centos fedora freebsd debian oracle mac_os_x redhat suse opensuse opensuseleap ubuntu windows zlinux ).each do |os|
  supports os
end
issues_url 'https://github.com/MelonSmasher/chef_manage_services/issues' if respond_to?(:issues_url)
source_url 'https://github.com/MelonSmasher/chef_manage_services' if respond_to?(:source_url)
