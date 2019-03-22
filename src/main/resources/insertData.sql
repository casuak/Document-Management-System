insert into sys_user (id, username, password) values ('u1', 'admin', 'admin');

insert into sys_role (id, name, code) values ('r1', '管理员', 'admin');

insert into sys_map_user_role (id, user_id, role_id) values ('ur1', 'u1', 'r1');

insert into sys_function (id, name, code, type, `index`, url, icon, parent_id, enable) values ('f1', '系统功能', 'sys:default', 0, 0, '', 'fa fa-cubes', null, true);
insert into sys_function (id, name, code, type, `index`, url, icon, parent_id, enable) values ('f1-1', '用户管理', 'sys:user', 1, 0, 'functions/sys/userManager', 'fa fa-user-plus', 'f1', true);
insert into sys_function (id, name, code, type, `index`, url, icon, parent_id, enable) values ('f1-2', '角色管理', 'sys:role', 1, 1, 'functions/sys/roleManager', 'fa fa-users', 'f1', true);
insert into sys_function (id, name, code, type, `index`, url, icon, parent_id, enable) values ('f1-3', '功能管理', 'sys:function', 1, 2, 'functions/sys/functionManager', 'fa fa-cogs', 'f1', true);
insert into sys_function (id, name, code, type, `index`, url, icon, parent_id, enable) values ('f1-4', '字典管理', 'sys:dict', 1, 3, 'functions/sys/dictManager', 'fa fa-book', 'f1', true);
