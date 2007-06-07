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

    @author agustin (Agustin.Lopez@uv.es) and Pablo Muñoz (pablomp@tid.es)    

} -properties {
    context:onevalue
    user_id:onevalue
    room_create_p:onevalue
    rooms:multirow
    rooms3:multirow
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
set path [ad_return_url]
set package_id [ad_conn package_id]
set room_create_p [permission::permission_p -object_id $package_id -privilege chat_room_create]

set rss_exists [rss_support::subscription_exists \
                    -summary_context_id $package_id \
                    -impl_name chat_rss]
        
set rss_feed_url [chat_util_get_url $package_id]chat/rss/rss.xml





if { $community_id eq "" } {
	set query_name "rooms_list_all"	
	set list 0
} else {
	set list 1
	set query_name "rooms_list"
}


db_multirow -extend { } rooms2 "rooms_list_all_comm" {} {
}
db_multirow -extend { active_users last_activity can_see_p rss_exists rss_feed_url2 rss_service admin_professor} rooms1 $query_name {} {
	set room [::chat::Chat create new -volatile -chat_id $room_id]
  	set active_users [$room nr_active_users]
  	set last_activity [$room last_activity]
	set can_see_p 0
	set rss_exists [rss_support::subscription_exists -summary_context_id $room_id -impl_name chat_rss]
	
	set rss_feed_url2 [chat_util_get_url $package_id]/chat/rss/rss.tcl?room_id=$room_id	
	
	
  	db_1row room_info {
		select count(cru.rss_service) as counter
		from chat_registered_users cru
		where cru.user_id = :user_id
		and cru.room_id = :room_id
		and cru.rss_service = 'true'
	}
	if { $counter > 0} {		
		set rss_service 1
	} else {
		set rss_service 0
	}
	
	if {($active_p eq "t" && $user_p eq "t") || ($admin_p eq "t")} {
		set can_see_p 1
		set num_rooms [expr $num_rooms + 1]
	}
	
	#A professor who creates a rooom will be able to admin it.
db_1row room_info2 {
		select count(cr.creator) as counter2
		from chat_rooms cr
		where cr.room_id = :room_id
		and cr.creator = :user_id		
 }
 if { $counter2 > 0} { 	
 		set admin_professor "t"
 } else {
 	 set admin_professor "f"
 }
	   
}
set active_users 0
db_multirow -extend { active_users last_activity can_see_p  rss_exists rss_feed_url2 rss_service admin_professor} rooms3 "rooms_list2" {} {
  	set room [::chat::Chat create new -volatile -chat_id $room_id]
  	set active_users [$room nr_active_users]
  	set last_activity [$room last_activity]
  	set rss_exists [rss_support::subscription_exists -summary_context_id $room_id -impl_name chat_rss]
  	set rss_feed_url2 /rss/rss.tcl?room_id=$room_id
  	set rss_service 0
  	db_1row room_info {
		select count(cru.rss_service) as counter
		from chat_registered_users cru
		where cru.user_id = :user_id
		and cru.room_id = :room_id
		and cru.rss_service = 'true'
	}
  	
  	if { $counter > 0} {		
		set rss_service 1
	} else {
		set rss_service 0
	}
  	set can_see_p 0
	if {($active_p eq "t" && $user_p eq "t") || ($admin_p eq "t")} {
		set can_see_p 1
		set num_rooms [expr $num_rooms + 1]
	}	 
	#A professor who creates a rooom will be able to admin it.
	db_1row room_info2 {
		select count(cr.creator) as counter2
		from chat_rooms cr
		where cr.room_id = :room_id
		and cr.creator = :user_id		
 	}
 	if { $counter2 > 0} { 	
 		set admin_professor "t"
 	} else {
 	 set admin_professor "f"
 	} 

	    	
}

	db_foreach open "select end_date,room_id from chat_rooms" {	
		if { [clock format [clock seconds] -format "%Y/%m%d"] > $end_date } {			
			db_0or1row update_closed {	
   		     		update chat_rooms SET open = 'false'        	
        			WHERE room_id = :room_id;
        			select 1;
        		}
        	} else {
        		db_0or1row update_closed {	
   		     		update chat_rooms SET open = 'true'        	
        			WHERE room_id = :room_id;
        			select 1;
        		}
        	}
        	
        	
       	}
       	
       	

list::create \
    -name "rooms3" \
    -multirow "rooms3" \
    -key room_id \
    -pass_properties {room_create_p} \
    -row_pretty_plural [_ chat.room_options] \
    -elements {
    	open {
            label "#chat-portlet.open_room#"
            html { style "text-align:center;" width 15px}
            display_template {
            	
                <if @rooms3.open@ eq t>
                <div style="padding-top:5px;">
                <img src="/resources/chat/active.png" title="#chat-portlet.open_room#">
                </div>
                </if>
                <else>
                <div style="padding-top:5px;">                
                <img src="/resources/chat/inactive.png" title="#chat-portlet.close_room#">
                </div>
                </else>
            }
        }        
        private {
            label "#chat-portlet.private_room#"
            html { style "text-align:center;" width 15px}
            display_template {
            	
                <if @rooms3.private@ eq f>
                <div style="padding-top:5px;">
                <img src="/resources/chat/active.png" title="#chat-portlet.not_private_room#">
                </div>
                </if>
                <else>
                <div style="padding-top:5px;">                
                <img src="/resources/chat/inactive.png" title="#chat-portlet.private_room#">
                </div>
                </else>
            }
        }
       
        community {
            label "#chat-portlet.community_class#"
            html { style "text-align:center;" width 15px}
            display_template {
            	<if @rooms3.user_p@ eq t>
            	@rooms3.community@
            	</if>
            }
        }
        pretty_name {
            label "#chat.Room_name#"
            html { align "center"}
            display_template {                           
                <if @rooms3.active_p@ eq t>
                	<a href="@rooms3.base_url@chat?room_id=@rooms3.room_id@&client=ajax">@rooms3.pretty_name@</a>
                </if>       	
        	<if @rooms3.active_p@ ne t>
          	(NO #chat.Active#)
        	</if>
            	<div style="float:center">@rooms3.description@</div>
            }
        }            
        active_users {
            label "#chat.active_users#"
            html { style "text-align:center;" }
        }
        last_activity {
            label "#chat.last_activity#"
            html { style "text-align:center;" width 15px}
        }
        rss {
        	label "#chat-portlet.rss#"
            	html { align "center" }
            	display_template {
            		
                	<if @rooms3.rss_exists@ eq 1>
                	<if @rooms3.rss_service@ eq 1>
	  		<br/><a href="@rooms3.base_url@@rooms3.rss_feed_url2@">#rss-support.Syndication_Feed#&nbsp;<img src="/resources/xml.gif" alt="Subscribe via RSS" width="26" height="10" border=0 /></a><hr/><br/>
        		</if>
        		<else> #chat-portlet.no_rss#
        		</else>
        		</if>
        		<else> #chat-portlet.no_rss#
        		</else>
        	}
        }
        admin {
        	label "#chat.actions#"
            	html { align "center" }
            	display_template {            		
        		<if @rooms3.admin_p@ eq f>
        			<if @rooms3.admin_professor@ eq "t">
        						<a href="@rooms3.base_url@room?room_id=@rooms3.room_id@" class=button>\n#chat.room_admin#</a>
                		</br>
                		<a href="@rooms3.base_url@chat-transcripts?room_id=@rooms3.room_id@" class=button>\n#chat.Transcripts#</a>
        			</if>
        			<else>        	
        				<a href="@rooms3.base_url@options?action=$path&room_id=@rooms3.room_id@" class=button>\n#chat.room_change_options#</a>
        				</br>
        				<a href="@rooms3.base_url@chat-transcripts?room_id=@rooms3.room_id@" class=button>\n#chat.Transcripts#</a>
        			</else>
        		</if>
        		<if @rooms3.admin_p@ eq t>                
                		<a href="@rooms3.base_url@room?room_id=@rooms3.room_id@" class=button>\n#chat.room_admin#</a>
                		</br>
                		<a href="@rooms3.base_url@chat-transcripts?room_id=@rooms3.room_id@" class=button>\n#chat.Transcripts#</a>
                	</if> 
        	}
        }
       
    }


list::create \
    -name "rooms1" \
    -multirow "rooms1" \
    -key room_id \
    -pass_properties {room_create_p} \
    -row_pretty_plural [_ chat.room_options] \
    -elements {
    	open {
            label "#chat-portlet.open_room#"
            html { style "text-align:center;" width 15px}
            display_template {
            	
                <if @rooms1.open@ eq t>
                <div style="padding-top:5px;">
                <img src="/resources/chat/active.png" title="#chat-portlet.open_room#">
                </div>
                </if>
                <else>
                <div style="padding-top:5px;">                
                <img src="/resources/chat/inactive.png" title="#chat-portlet.close_room#">
                </div>
                </else>
            }
       }
       private {
            label "#chat-portlet.private_room#"
            html { style "text-align:center;" width 1px}
            display_template {
                <if @rooms1.private@ eq f>
                <div style="padding-top:5px;">
                <img src="/resources/chat/active.png" title="#chat-portlet.not_private_room#">
                </div>
                </if>
                <else>
                <div style="padding-top:5px;">                
                <img src="/resources/chat/inactive.png" title="#chat-portlet.private_room#">
                </div>
                </else>
            }
        }
               
        community {
            label "#chat-portlet.community#"
            html { align "center"}
            display_template {
            	@rooms1.community@
            }
        }
        pretty_name {
            label "#chat.Room_name#"
            html { align "center"}
            display_template {                               
                
                 <if @rooms1.active_p@ eq t>
                	<a href="@rooms1.base_url@chat?room_id=@rooms1.room_id@&client=ajax">@rooms1.pretty_name@</a>
                </if>      	
        	<if @rooms1.active_p@ ne t>
          	(NO #chat.Active#)
        	</if>      			
            	<div style="float:center">@rooms1.description@</div>                
            }
        }          
        active_users {
            label "#chat.active_users#"
            html { style "text-align:center;" }
        }
        last_activity {
            label "#chat.last_activity#"
            html { style "text-align:center;" }
        }
        rss {
        	label "#chat-portlet.rss#"
            	html { align "center" }
            	display_template {
            		
                        <if @rooms1.rss_exists@ eq 1>
                        <if @rooms1.rss_service@ eq 1>
	  		<br/><a href="@rooms1.rss_feed_url2@">#rss-support.Syndication_Feed#&nbsp;<img src="/resources/xml.gif" alt="Subscribe via RSS" width="26" height="10" border=0 /></a><hr/><br/>
	  		</if>
	  		<else> #chat-portlet.no_rss#
        		</else>
        		</if>
        		<else> #chat-portlet.no_rss#
        		</else>
                }
        }
        admin {
        	label "#chat.actions#"
            	html { align "center" }
            	display_template {            		
        		<if @rooms1.admin_p@ eq f>
        			<if @rooms1.admin_professor@ eq "t">
        						<a href="@rooms1.base_url@room?room_id=@rooms1.room_id@" class=button>\n#chat.room_admin#</a>
                		</br>
                		<a href="@rooms1.base_url@chat-transcripts?room_id=@rooms1.room_id@" class=button>\n#chat.Transcripts#</a>
        			</if>
        			<else>        	
        				<a href="@rooms1.base_url@options?action=$path&room_id=@rooms1.room_id@" class=button>\n#chat.room_change_options#</a>
        				</br>
        				<a href="@rooms1.base_url@chat-transcripts?room_id=@rooms1.room_id@" class=button>\n#chat.Transcripts#</a>
        			</else>
        		</if>
        		<if @rooms1.admin_p@ eq t>                
                		<a href="@rooms1.base_url@room?room_id=@rooms1.room_id@" class=button>\n#chat.room_admin#</a>
                		</br>
                		<a href="@rooms1.base_url@chat-transcripts?room_id=@rooms1.room_id@" class=button>\n#chat.Transcripts#</a>
                	</if> 
        	}
        }   
        
    }

ad_return_template
