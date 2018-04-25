ALTER INDEX PROJECT_TYPE_PK REBUILD
TABLESPACE INDX;

ALTER INDEX PROJECT_PK REBUILD
TABLESPACE INDX;

ALTER INDEX GIVING_LEVEL_PK REBUILD
TABLESPACE INDX;


ALTER INDEX FOCUS_AREA_PK REBUILD
TABLESPACE INDX;

ALTER INDEX DONATION_DETAIL_PK REBUILD
TABLESPACE INDX;

ALTER INDEX DONATION_PK REBUILD
TABLESPACE INDX;

ALTER INDEX BUDGET_PK REBUILD
TABLESPACE INDX;

ALTER INDEX BILLING_PK REBUILD
TABLESPACE INDX;

ALTER INDEX ACCOUNT_PK REBUILD
TABLESPACE INDX;


create user shiwanh
identified by shiwan
default tablespace USERS
temporary tablespace temp
quota 10m on uiaalumni01
quota 10m on INDX
profile student_profile
password expire
account lock;




create profile student_profile
limit
sessions_per_user 5
cpu_per_session 10000
idle_time 30
connect_time 720
cpu_per_call 1000
;
-- This role has Read only access to all tables.
create role ReadOnly;
BEGIN
   for i in (select * from user_tables)
   loop
   execute immediate 'grant select on ' || i.table_name||' to ReadOnly';
   end loop;
END; 

-- this role gets access to execute all procedures and functions in the package.
create role EveryProcedure;

grant execute  on  IOBY3B_pkg to EveryProcedure;



-- This role gets access to execute the following procedures written down below.
create role LimitedProcedures;

grant execute on CREATE_ACCOUNT_SP to LimitedProcedures;
grant execute on CREATE_PROJECT_SP to LimitedProcedures;
grant execute on CREATE_GIVING_LEVEL_SP to LimitedProcedures;
grant execute on ADD_BUDGET_ITEM_SP to LimitedProcedures;
grant execute on ADD_FOCUSAREA_SP to LimitedProcedures;


-- This role gets access to execute the following procedures written down below.
create role Donor;

grant execute on create_account_sp to Donor;
grant execute on add_donation_pp to Donor;

-- question 5 (e): First of all we did not understand the difference between b and C, but after a while we came to the conclusion
-- that you wanted to us to grant the role to execute some of the procedures and not the whole package. 

-- another challenge was that we didnt manage to find out how to make a loop for the question C and D. so instead we wrote the grants manually as you can see. 
-- another challenge we had with all of the questions was that we started with making a user instead of just creating roles and granting them what we wanted
-- with that being said, our time was not wasted because the next question is about creating users.


