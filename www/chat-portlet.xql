<?xml version="1.0"?>
<queryset>

  <fullquery name="rooms_list">
    <querytext>
    select rm.room_id,
           rm.pretty_name as pretty_name,
           rm.description as description,
           rm.moderated_p,
           rm.active_p,
           rm.archive_p,
           obj.context_id
    from chat_rooms rm,
         acs_objects obj
    where rm.room_id = obj.object_id
          and obj.context_id IN ($sep_package_ids)
          and rm.active_p = 't'
    order by rm.pretty_name
    </querytext>
  </fullquery>

  <fullquery name="rooms_list_all">
    <querytext>
    select rm.room_id,
           rm.pretty_name as pretty_name,
           rm.description as description,
           rm.moderated_p,
           rm.active_p,
           rm.archive_p,
           obj.context_id
    from chat_rooms rm,
         acs_objects obj
    where rm.room_id = obj.object_id and rm.active_p = 't'
    order by rm.pretty_name
    </querytext>
  </fullquery>

</queryset>
