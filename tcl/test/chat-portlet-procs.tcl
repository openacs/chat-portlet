ad_library {
    Automated tests for the chat-portlet package.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 2020-08-19
    @cvs-id $Id$
}

aa_register_case -procs {
        chat_admin_portlet::link
        chat_portlet::link
        chat_admin_portlet::get_pretty_name
        chat_portlet::get_pretty_name
    } -cats {
        api
        production_safe
    } chat_portlet_links_names {
        Test diverse link and name procs.
} {
    aa_equals "Chat admin portlet link"         "[chat_admin_portlet::link]" ""
    aa_equals "Chat portlet link"               "[chat_portlet::link]" ""
    aa_equals "Chat portlet pretty name"        "[chat_portlet::get_pretty_name]" "#chat-portlet.pretty_name#"
    aa_equals "Chat portlet admin pretty name"  "[chat_admin_portlet::get_pretty_name]" "#chat-portlet.admin_pretty_name#"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
