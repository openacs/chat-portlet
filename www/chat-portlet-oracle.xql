<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="rooms_list">
  <querytext>
    select rm.room_id,
           obj.context_id,
           rm.pretty_name as pretty_name,
           (select instance_name from apm_packages
             where package_id = pn.object_id) as parent_name,
           rm.description as description,
           rm.active_p,
           rm.archive_p,
           acs_permission.permission_p(room_id, :user_id, 'chat_room_admin') as admin_p
      from chat_rooms rm,
           acs_objects obj,
           site_nodes cn,
           site_nodes pn
     where rm.room_id = obj.object_id
       and cn.object_id = obj.context_id
       and cn.parent_id = pn.node_id
       and obj.context_id IN ([ns_dbquotelist $config(package_id)])
       and rm.active_p = 't'
       and acs_permission.permission_p(room_id, :user_id, 'chat_ban') = 'f'
       and acs_permission.permission_p(room_id, :user_id, 'chat_read') = 't'
    order by parent_name, lower(pretty_name)
  </querytext>
</fullquery>

</queryset>

