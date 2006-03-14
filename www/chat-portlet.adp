<%
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
%>

<property name="context">@context;noquote@</property>
<property name="title">#chat.Chat_main_page#</property>

<if @room_create_p@ ne 0 and @inside_comm_p@ eq 1>
[<a href="@chat_url@room-new">#chat.Create_a_new_room#</a>]
</if>

<if @rooms:rowcount@ eq 0>
<p><i>#chat.There_are_no_rooms_available#</i>
</if>
<else>
  <table border=0>
    <% set num_rooms 0 %>
    <multiple name=rooms>
    <%
    set can_see 0
    if {($rooms(active_p) eq "t" && $rooms(user_p) eq "t") || ($rooms(admin_p) eq "t")} {
      set can_see 1
      set num_rooms [expr $num_rooms + 1]
    }   
    %>
    <if @can_see@ eq 1>
      <tr>
        <td valign=top>@rooms.pretty_name@</td>
        <td valign=top>
            [&nbsp;<a href="@rooms.base_url@room-enter?room_id=@rooms.room_id@&client=html">HTML</a>&nbsp;|&nbsp;<a href="@rooms.base_url@room-enter?room_id=@rooms.room_id@&client=java">java</a>&nbsp;]
        </td>
        <td valign=top>
        <if @rooms.admin_p@ eq "t">
          [<a href="@rooms.base_url@room?room_id=@rooms.room_id@">#chat.room_admin#</a>] 
        </if>
        <if @rooms.active_p@ ne "t">
          (NO #chat.Active#)
        </if>
        <% 
        if {$inside_comm_p eq "1"} {
          set desc [string range $rooms(description) 0 50] 
        } else {
          set desc $rooms(keyclub)
        }
        %>
        <td valign=top>
            <I>@desc@</I>
        </td>
      </tr>            
    </if>
    </multiple>
    <if @num_rooms@ eq 0>
    <p><i>#chat.There_are_no_rooms_available#</i>
    </if>    
  </table>
</else>
