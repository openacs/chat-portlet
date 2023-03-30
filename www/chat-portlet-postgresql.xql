<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>9.6</version></rdbms>

<fullquery name="rooms_list">
  <querytext>
    with user_chat_rooms as (
        select rm.room_id,
               rm.pretty_name as pretty_name,
               acs_object__name(apm_package__parent_id(obj.context_id)) as parent_name,
               rm.description as description,
               rm.active_p,
               rm.archive_p,
               acs_permission.permission_p(room_id, :user_id, 'chat_room_admin') as admin_p,
               acs_permission.permission_p(room_id, :user_id, 'chat_ban') as banned_p,
               obj.context_id
          from chat_rooms rm,
               acs_objects obj
         where rm.room_id = obj.object_id
           and obj.context_id IN ([ns_dbquotelist $config(package_id)])
           and rm.active_p = 't'
    )
    select *
      from user_chat_rooms u,
           (select distinct orig_object_id
              from acs_permission.permission_p_recursive_array(
                      array(select room_id from user_chat_rooms),
                      :user_id,
                      'chat_read'
                   )
           ) as chat_rooms_read
     where chat_rooms_read.orig_object_id = u.room_id
       and u.banned_p = 'f'
    order by parent_name, lower(pretty_name)
  </querytext>
</fullquery>

</queryset>
