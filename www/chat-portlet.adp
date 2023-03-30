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

<if @shaded_p;literal@ false>
  <if @community_id@ not nil and @room_create_p;literal@ true>
    <a href="@chat_url@room-edit">#chat.Create_a_new_room#</a>
  </if>

  <if @rooms:rowcount@ gt 0>
    <multiple name="rooms">
      <if @community_id@ nil>
        <h3 class="portlet">@rooms.parent_name@</h3>
      </if>
      <ul>
        <group column="parent_name">
          <li>
            <div>
              <a href="@rooms.room_enter_url@">@rooms.pretty_name@</a>
              (@rooms.active_users@ #dotlrn.Users#)
              <if @rooms.admin_p;literal@ true>
                <a class="admin" href="@rooms.base_url@room?room_id=@rooms.room_id@">
                  <img border="0" src="/resources/dotlrn/admin.gif">
                </a>
              </if>
            </div>
            <div class="info">@rooms.description@</div>
          </li>
        </group>
      </ul>
    </multiple>
  </if>
  <else>
    <div class="info">#chat.There_are_no_rooms_available#</div>
  </else>
</if>
<else>
  #new-portal.when_portlet_shaded#
</else>
