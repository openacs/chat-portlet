<%
    #
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
<p><table><tr><td><a class="button" href="@chat_url@room-new">#chat.Create_a_new_room#</a></t><td><a class="button" href="@chat_url@room-search?package_id=@package_id@">#chat.Search_a_room#</a></td></tr></table><p>
</if>
<else>
<if @room_create_p@ ne 0>
<p><table><tr><td><a class="button" href="/chat/room-new">#chat.Create_a_new_room#</a></t><td><a class="button" href="/chat/room-search?package_id=@package_id@">#chat.Search_a_room#</a></td></tr></table><p>
</if>
<else>
<p><a class="button" href="/chat/room-search?package_id=@package_id@">#chat.Search_a_room#</a><p>	
</else>
</else>


<if @rooms1:rowcount@ eq 0 or @num_rooms@ eq 0>
<p><i>#chat.There_are_no_rooms_available#</i></p>
</if>
<else>
  <table border=0>
  	
    <if @list@ eq 1> 
    		<listtemplate name="rooms1"></listtemplate>  
    </if>
    <else>     
  	<listtemplate name="rooms3"></listtemplate>  
     </else>
  </table>
</else>
