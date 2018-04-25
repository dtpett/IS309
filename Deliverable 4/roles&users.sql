-- This role has Read only access to all tables.
create role ReadOnly;
BEGIN
   for i in (select * from user_tables)
   loop
   execute immediate 'grant select on ' || i.table_name||' to ReadOnly';
   end loop;
END; 

grant Create session to ReadOnly;

-- this role gets access to execute all procedures and functions in the package.
create role EveryProcedure;

grant execute  on  IOBY3B_pkg to EveryProcedure;

grant create session to EveryProcedure;

-- This role gets access to execute the following procedures written down below.
create role LimitedProcedures;

grant execute on ROLE_PKG to LimitedProcedures; 

grant create session to LimitedProcedures;

-- This role gets access to execute the following procedures written down below.
create role Donor;

grant execute on DONOR_PKG to Donor;

grant create session to Donor;

-- Task 4b  we decided to create a profile first then create the users so we could use the profile while creating the users.
create profile student_profile
limit
sessions_per_user 5
cpu_per_session 10000
idle_time 30
connect_time 720
cpu_per_call 1000
;


-- Task 4 A  creating two users, and using the profile (student profile). 
-- The default tablespace for them er USERS tablespace.
-- User 1 is getting quota of 0M on USERS.
-- User 2 is getting quota of 50M on USERS.
-- User 1 got ReadOnly role that we created in task 5.
-- User 2 got EveryProcedure role that we created in task 5.


create user Alumni_11
identified by shiwan
default tablespace USERS
quota 0M ON Users 
temporary tablespace temp,
profile student_profile;

grant ReadOnly  to Alumni_11;

grant create session to Alumni_22; 


create user Alumni_22
identified by Eirik
default tablespace USERS
quota 50M ON Users
temporary tablespace temp
profile student_profile;

Grant EveryProcedure to Alumni_22;

grant create session to Alumni_22 with admint option;