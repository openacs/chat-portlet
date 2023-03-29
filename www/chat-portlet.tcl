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
set chat_url "[ad_conn package_url]/chat/"

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set room_create_p [permission::permission_p -object_id $user_id -privilege chat_room_create]
set num_rooms 0

if { $community_id == 0 } {
    #
    # Outside of .LRN, we list all chat rooms.
    #
    set packages_clause ""
} else {
    #
    # Inside .LRN, we display only chat rooms belonging to the
    # packages supplied in the configuration.
    #
    set packages_clause "and obj.context_id IN ([ns_dbquotelist $config(package_id)])"
}
db_multirow -extend { can_see_p room_enter_url } rooms list_rooms [subst -nocommands {
    select rm.room_id,
           rm.pretty_name as pretty_name,
           rm.description as description,
           rm.active_p,
           rm.archive_p,
           acs_permission.permission_p(room_id, :user_id, 'chat_room_admin') as admin_p,
           acs_permission.permission_p(room_id, :user_id, 'chat_read') as user_p,
           obj.context_id
    from chat_rooms rm,
         acs_objects obj
    where rm.room_id = obj.object_id
          $packages_clause
          and rm.active_p = 't'
    order by rm.pretty_name
}] {
    set can_see_p 0
    if { $user_p || $admin_p } {
        set can_see_p 1
        incr num_rooms
    }
    set base_url [site_node::get_url_from_object_id -object_id $context_id]
    set room_enter_url [export_vars -base "${base_url}chat" {room_id}]
}

template::list::create -name chat_rooms -multirow rooms \
    -no_data [_ chat.There_are_no_rooms_available] \
    -filters {can_see_p {default_value 1}} \
    -elements {
        pretty_name {
            label "[_ chat.Room_name]"
            link_url_col room_enter_url
            link_html {title "[_ chat.Enter_rooms_pretty_name]"}
        }
        description {
            label "[_ chat.Description]"
        }
    }

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
