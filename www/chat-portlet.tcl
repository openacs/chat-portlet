#
#  Copyright (C) 2004 University of Valencia
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    The display logic for the chat portlet

    @author agustin (Agustin.Lopez@uv.es)
    @creation-date 2004-10-10
    @cvs-id $Id: chat-portlet.tcl,v 0.1 2004/10/10

} -properties {
    context:onevalue
    user_id:onevalue
    room_create_p:onevalue
    rooms:multirow
}

array set config $cf
set shaded_p $config(shaded_p)
if {$shaded_p} {
    #
    # Nothing else to fetch here if the portlet is shaded. Just return
    # the template.
    #
    ad_return_template
    return
}

set chat_url "[ad_conn package_url]/chat/"
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set room_create_p [permission::permission_p -object_id $user_id -privilege chat_room_create]

db_multirow -extend {
    base_url
    room_enter_url
    active_users
    last_activity
} rooms rooms_list {} {
    set base_url [site_node::get_url_from_object_id -object_id $context_id]
    set room_enter_url [export_vars -base "${base_url}chat" {room_id}]
    set room [::chat::Chat create new -chat_id $room_id]
    set active_users [$room nr_active_users]
    set last_activity [$room last_activity]
    $room destroy
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
