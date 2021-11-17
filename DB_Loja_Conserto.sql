CREATE DATABASE IF NOT EXISTS repairdb;
drop database repairdb;

use repairdb;

drop table tb_client;

create table tb_client(
	id_client 	int primary key auto_increment,
    name 		varchar(50) not null,
    phone 		varchar(15)
);

drop table tb_resource;

create table tb_resource(
	id_resource int primary key auto_increment,
    name 		varchar(50) not null,
    id_client 	int not null,
    foreign key (id_client) references tb_client (id_client)
    );

drop role r_viewer;
drop role r_tester;
drop role r_dev;
drop role r_admin;

create role 
	r_viewer, r_tester, r_dev, r_admin;
    

grant select on repairdb.* to r_viewer;
show grants for r_viewer;

grant insert, update on repairdb.* to r_tester;
grant r_viewer to r_tester;
show grants for r_tester;

grant all on repairdb.* to r_dev;
grant all on *.* to r_admin;
show grants for r_admin;

drop user aMaziero;

create user rAlija 			identified by 'passwd';
create user hRillen			identified by 'passwd';
create user tJefferson	 	identified by 'passwd';
create user iMello			identified by 'passwd';
create user bMarley			identified by 'passwd';
create user cRonaldo		identified by 'passwd';
create user zVaqueiro		identified by 'passwd';
create user aMaziero		identified by 'passwd';

grant r_admin 	to rAlija, hRillen;
grant r_dev 	to tJefferson, iMello;
grant r_tester 	to bMarley, cRonaldo;
grant r_viewer 	to zVaqueiro, aMaziero;


SET DEFAULT ROLE ALL TO 
	rAlija, hRillen, tJefferson,
    iMello, bMarley, cRonaldo,
    zVaqueiro, aMaziero;
	
    
use mysql;
show tables;

select * from user;
select * from role_edges;
select * from default_roles;

select from_user, count(*), group_concat(to_user)
	from role_edges
    group by from_user;
    
select default_role_user, group_concat(user)
	from default_roles
    group by default_role_user;
    
show grants for rAlija;
show grants for rAlija using r_admin;