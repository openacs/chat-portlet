<?xml version="1.0"?>
     
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="rooms_list">
  <querytext>
    select distinct rm.room_id as room_id, 
           rm.pretty_name as pretty_name, 
           rm.description as description, 
           rm.moderated_p, 
           rm.active_p, 
           rm.archive_p,
           rm.context_id,
           rm.open as open,
           rm.private as private,
           rm.comm_name as community,
           acs_permission__permission_p(room_id, :user_id, 'chat_room_admin') as admin_p,
           acs_permission__permission_p(room_id, :user_id, 'chat_read') as user_p,           
           (select site_node__url(site_nodes.node_id)
                   from site_nodes
                   where site_nodes.object_id = obj.context_id) as base_url,
           (select ru.alias
                   from chat_registered_users ru
                   where rm.room_id = ru.room_id                   
                   and ru.user_id = :user_id) as alias    
    from chat_rooms rm, 
         acs_objects obj
    where rm.room_id = obj.object_id
          and obj.context_id IN ($sep_package_ids)          
    order by rm.pretty_name
  </querytext>
</fullquery>

<fullquery name="rooms_list_all">
  <querytext>
    select rm.room_id as room_id,
    	   rm.context_id,
           rm.pretty_name as pretty_name,
           rm.description as description,
           rm.moderated_p,
           rm.active_p,
           rm.archive_p,
           rm.private as private,
           rm.open as open,
           acs_permission__permission_p(room_id, :user_id, 'chat_room_admin') as admin_p,
           acs_permission__permission_p(room_id, :user_id, 'chat_read') as user_p,    
           (select site_node__url(site_nodes.node_id)
                   from site_nodes
                   where site_nodes.object_id = obj.context_id) as base_url,
           (select ru.alias
                   from chat_registered_users ru
                   where rm.room_id = ru.room_id                   
                   and ru.user_id = :user_id) as alias
    from chat_rooms rm, 
         acs_objects obj
    where rm.room_id = obj.object_id    
    order by rm.context_id
  </querytext>
 </fullquery> 
 
  <fullquery name="rooms_list_all_comm">
  	<querytext>
    	select distinct rm.context_id             
    	from chat_rooms rm, 
         acs_objects obj
    	where rm.room_id = obj.object_id    	
    	order by rm.context_id
  	</querytext>
   </fullquery>  
   
   <fullquery name="rooms_list2">     
  <querytext>
    select distinct rm.room_id as room_id, 
           rm.pretty_name, 
           rm.description, 
           rm.moderated_p, 
           rm.active_p, 
           rm.archive_p,
           rm.private as private,
           rm.open as open,
           rm.comm_name as community,
           acs_permission__permission_p(room_id, :user_id, 'chat_room_admin') as admin_p,
           acs_permission__permission_p(room_id, :user_id, 'chat_read') as user_p,           
           (select site_node__url(site_nodes.node_id)
                   from site_nodes
                   where site_nodes.object_id = obj.context_id) as base_url
    from chat_rooms rm, 
         acs_objects obj,dotlrn_communities_all as dot
    where rm.room_id = obj.object_id     
    order by rm.pretty_name
  </querytext>
</fullquery>

</queryset>

