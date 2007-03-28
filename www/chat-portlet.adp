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

<if @community_id@ gt 0 and @room_create_p@ ne 0>
[<a href="@chat_url@room-new" title="#chat.Create_a_new_room#">#chat.Create_a_new_room#</a>]
</if>

<if @rooms:rowcount@ eq 0 or @num_rooms@ eq 0>
<p><i>#chat.There_are_no_rooms_available#</i></p>
</if>
<else>
  <table border=0>
    <multiple name=rooms>
    <if @rooms.can_see_p@ eq 1>
      <tr>
        <td valign=top><a href="@rooms.room_url@">@rooms.pretty_name@</a></td>
        <td valign=top>
            [&nbsp;<a href="@rooms.html_room_url@">#chat-portlet.html_mode#</a>&nbsp;]
        </td>
        <td valign=top>
        <if @rooms.admin_p@ eq "t">
          [<a href="@rooms.admin_url@">#chat.room_admin#</a>]
        </if>
        <if @rooms.active_p@ ne "t">
          (NO #chat.Active#)
        </if>
        <td valign=top>
            <I>@rooms.description@</I>
        </td>
      </tr>
    </if>
    </multiple>
  </table>
</else>
