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
    @version $Id: chat-portlet.tcl,v 0.1 2004/10/10

} -properties {
    context:onevalue
    user_id:onevalue
    room_create_p:onevalue
    rooms:multirow
}

array set config $cf
set list_of_package_ids $config(package_id)
set sep_package_ids [join $list_of_package_ids ", "]
set chat_url "[ad_conn package_url]/chat/"

set context [list]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set room_create_p [ad_permission_p $user_id chat_room_create]
set default_mode [ad_parameter DefaultClient chat "ajax"]
set num_rooms 0

if { $community_id eq 0 } {
	set query_name "rooms_list_all"
} else {
	set query_name "rooms_list"
}
db_multirow -extend { can_see_p room_url html_room_url admin_url} rooms $query_name {} {
	set can_see_p 0
	if {($active_p eq "t" && $user_p eq "t") || ($admin_p eq "t")} {
		set can_see_p 1
		set num_rooms [expr $num_rooms + 1]
	}   
    set room_url [export_vars -base ${base_url}/room-enter {{client $default_mode} room_id}]
    set html_room_url [export_vars -base ${base_url}/room-enter {{client html} room_id}]
    set admin_url [export_vars -base ${base_url}/room {room_id}]
}

ad_return_template
