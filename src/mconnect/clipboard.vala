class ClipboardHandler : Object, PacketHandlerInterface {
    public const string CLIPBOARD = "kdeconnect.clipboard";

    private ClipboardHandler () {}

    public static ClipboardHandler instance () {
        return new ClipboardHandler ();
    }

    public string get_pkt_type () {
        return CLIPBOARD;
    }

    private void message (Device dev, Packet pkt) {
        if (pkt.pkt_type != CLIPBOARD) {
            return;
        }

        var clipboard_content = pkt.body.get_string_member ("content");
        var display = Gdk.Display.get_default ();

        if (display != null) {
            var cb = Gtk.Clipboard.get_default (display);
            cb.set_text (clipboard_content, -1);
            Utils.show_own_notification ("Text copied to clipboard", dev.device_name);
        }
    }

    public void use_device (Device dev) {
        debug ("use device %s for sharing", dev.to_string ());
        dev.message.connect (this.message);
    }

    public void release_device (Device dev) {
        debug ("release device %s", dev.to_string ());
        dev.message.disconnect (this.message);
    }

}