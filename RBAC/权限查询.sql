#查询用户test1可以查看的页面（Sys_menu）
(select MenuName from sys_menu
       where MenuID=(select PrivilegeAccessKey from cf_privilege 
                     where PrivilegeMaster="CF_User" 
					 and PrivilegeMasterKey=(select UserID from cf_user where LoginName="test1") 
					 and PrivilegeAccess="Sys_Menu"))UNION
(select MenuName from sys_menu 
       where MenuID=any( select PrivilegeAccessKey from cf_privilege
                      where PrivilegeMaster="CF_Role" 
                      and PrivilegeAccess="Sys_Menu" 
                      and PrivilegeMasterKey=(select RoleID from cf_userrole 
                                              where UserId=(select UserID from cf_user where LoginName="test1")) 
                                              and PrivilegeOperation="Permit"));
#对订单(order)页面中的操作权限(sys_button)
select BtnName from sys_button 
       where MenuNo=any(select MenuNo from 
                       (select * from cf_privilege 
                           where PrivilegeMasterKey=(select RoleID from cf_userrole 
                                                     where UserId=(select UserID from cf_user where LoginName="test1"))  
						   and PrivilegeMaster="CF_Role" 
                           and PrivilegeAccess="Sys_Menu"
                           and PrivilegeOperation="Permit") as S1,sys_menu 
                               where sys_menu.MenuID=S1.PrivilegeAccessKey
							    and MenuName="订单");
