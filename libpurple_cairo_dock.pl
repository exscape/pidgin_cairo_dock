use Purple;
require Net::DBus;

###
### Thomas Backman, 2014-12-15
### serenity@exscape.org
### http://github.com/exscape/pidgin_cairo_dock (for the latest version, README etc.)
### This program is licensed under the MIT license (see LICENSE file).
###

%PLUGIN_INFO = (
	perl_api_version => 2,
	name => "Pidgin cairo-dock unread count",
	version => "1.0",
	summary => "Shows the number of unread messages on the Pidgin icon in cairo-dock.",
	description => "Shows the number of unread messages on the Pidgin icon in cairo-dock.",
	author => "Thomas Backman <serenity\@exscape.org>",
	url => "http://github.com/exscape/pidgin_cairo_dock",
	load => "plugin_load",
	unload => "plugin_unload"
);

my $bus;

sub plugin_init {
	return %PLUGIN_INFO;
}

sub plugin_load {
	my $plugin = shift;

	$bus = Net::DBus->session;
	die ("pidgin_cairo_dock: Unable to connect to DBus session bus!\n") unless $bus;

	my $conv_handle = Purple::Conversations::get_handle();

	Purple::Signal::connect($conv_handle, "received-im-msg", $plugin, \&update_unread_count, '');
	Purple::Signal::connect($conv_handle, "received-chat-msg", $plugin, \&update_unread_count, '');
	Purple::Signal::connect($conv_handle, "conversation-updated", $plugin, \&update_unread_count, '');
	Purple::Signal::connect($conv_handle, "conversation-created", $plugin, \&update_unread_count, '');
	Purple::Signal::connect($conv_handle, "deleting-conversation", $plugin, \&update_unread_count, '');

	update_unread_count();
}

sub total_unread_count {
	my $total_unread = 0;
	my @convs = Purple::get_conversations();

	for my $conv (@convs) {
		my $data = $conv->get_data('unseen-count');
		next unless defined($data);
		my $this_unread = $data->{_purple};
		$total_unread += $this_unread;
	}

	return $total_unread;
}

sub update_unread_count {
	my $unread = total_unread_count();

	my $dock_serv = $bus->get_service("org.cairodock.CairoDock");
	unless ($dock_serv) {
		Purple::Debug::error("pidgin_cairo_dock", "Unable to connect to cairo-dock DBus service; is DBus support enabled in cairo-dock?\n");
		return;
	}

	my $dock = $dock_serv->get_object("/org/cairodock/CairoDock");
	unless ($dock) {
		Purple::Debug::error("pidgin_cairo_dock", "Unable to get cairo-dock DBus object; is DBus support enabled in cairo-dock?\n");
		return;
	}

	if ($unread > 0) {
		$dock->SetQuickInfo($unread, "class=Pidgin & type=Launcher");
	}
	else {
		$dock->SetQuickInfo("", "class=Pidgin & type=Launcher");
	}
}

sub plugin_unload {
	my $plugin = shift;
}
