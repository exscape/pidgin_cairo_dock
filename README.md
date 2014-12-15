![screenshot](http://raw.github.com/exscape/pidgin_cairo_dock/master/pidgin_cairo_dock.png)

Requirements
------------

* Linux/\*BSD-compatible OS, presumably
* Pidgin, with Perl support enabled (check under Help -> Build Information)
* cairo-dock, with DBus support enabled (System -> DBus in the cairo-dock configuration Advanced mode)
* The Net::DBus Perl module (v1.0.0 or greater).

Installation
------------

1) Download the .pl file and put it in ~/.purple/plugins  
2) Restart Pidgin  
3) Go to Tools -> Plugins and enable the plugin

Assuming you have Net::DBus and cairo-dock is correctly configured, that should be it.  
cairo-dock has DBus support enabled by default.

If Pidgin refuses to enable the plugin, you are most likely missing the Net::DBus module.  
You can install it with CPAN (e.g. sudo cpan install Net::DBus), or using your distro's package manager (Arch: perl-net-dbus, Debian/Ubuntu: libnet-dbus-perl, Gentoo: dev-perl/Net-DBus, Fedora: perl-Net-DBus).
