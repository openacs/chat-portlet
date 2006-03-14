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
set user_id [ad_conn user_id]
set sep_package_ids [join $list_of_package_ids ", "]

if {[llength $list_of_package_ids] == 1} { 
	set single_p "t"
} else {
	set single_p "f"
}

set context [list]
set shaded_p $config(shaded_p)
set chat_url "[ad_conn package_url]/chat/"
set community_id [dotlrn_community::get_community_id]
set room_create_p [ad_permission_p $user_id chat_room_create]
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]
if {[exists_and_not_null community_id]} {
    #We are in portal for one class or community
    set inside_comm_p 1
    db_multirow rooms rooms_list {}
} else {
    #We are in user portal
    set inside_comm_p 0
    db_multirow -extend { keyclub } rooms rooms_list_all {} {
		set keyclub [dotlrn_community::get_community_description -community_id [dotlrn_community::get_community_id_from_url -url $base_url]]
		if {$keyclub eq ""} {
			set keyclub $description
		}
    }
}
ad_return_template

