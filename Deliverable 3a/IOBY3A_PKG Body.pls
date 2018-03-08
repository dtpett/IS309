create or replace package body ioby3a_pkg 
IS

procedure CREATE_ACCOUNT_PP (
  p_account_id      OUT INTEGER,
  p_email           IN VARCHAR,   -- must not be NULL
  p_password        IN VARCHAR,   -- must not be NULL
  p_location_name   IN VARCHAR,   -- must not be NULL
  p_account_type    IN VARCHAR,   -- should have value of 'Group or organization' or 'Individual'
  p_first_name      IN VARCHAR,
  p_last_name       IN VARCHAR
)
is
p_count number (10);
ex_error exception;
err_msg_txt varchar(100) :=null;

begin
select count (*)
into p_count 
from I_ACCOUNT
where p_email = account_email;

if p_count > 0 
then 
err_msg_txt := 'The email already exists, try another one ';
raise ex_error;
elsif p_email is null then
err_msg_txt := 'the email  must not be null.';
raise ex_error;
elsif  p_password is null then
err_msg_txt := 'The password must not be null.';
raise ex_error;
elsif p_account_type is null then 
err_msg_txt := 'The account type cannot be null.';
raise ex_error;
elsif p_account_type not in ('Individual', 'Organization or Group') then 
err_msg_txt := ' The account type must be one of these "group or organization"  or "individual." ';
raise ex_error;
end if;


INSERT INTO I_ACCOUNT ( ACCOUNT_ID,ACCOUNT_EMAIL,ACCOUNT_PASSWORD,ACCOUNT_LOCATION_NAME,ACCOUNT_TYPE,ACCOUNT_FIRST_NAME,ACCOUNT_LAST_NAME ) VALUES (
    Account_sequences.nextval, 
    p_email,
    p_password,
    p_location_name,
    p_account_type,
    p_first_name,
    p_last_name

    );

COMMIT;


    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

end CREATE_ACCOUNT_PP;

procedure CREATE_PROJECT_PP (
p_project_id        OUT INTEGER,
p_title             IN  VARCHAR,
p_goal              IN  NUMBER,        -- The goal should be >= zero
p_deadline          IN  DATE,
p_creation_date     IN  DATE,
p_description       IN  CLOB,
p_subtitle          IN  VARCHAR,
p_street_1          IN  VARCHAR,
p_street_2          IN  VARCHAR,
p_city              IN  VARCHAR,
P_state             IN  VARCHAR,
p_postal_code       IN  CHAR,
p_postal_extension  IN  CHAR,
p_steps_to_take     IN  CLOB,
p_motivation        IN  CLOB,
p_volunteer_need    IN  VARCHAR,  -- should be 'yes' or 'no'
p_project_status    IN  VARCHAR,  -- should be in {'Closed', 'Completed', 'Open', 'Submitted', 'Underway'}
p_account_id        IN  INTEGER   -- should match account in the account table
)

IS
ex_error exception;
err_msg_txt varchar(100) :=null;
account_count number;
lv_deadline             i_project.project_deadline%type;
lv_creation_date        i_project.project_creation_date%type;

BEGIN
SELECT count(*) account_id into account_count
FROM I_ACCOUNT
WHERE p_account_id = account_id;

if account_count < 1 then
err_msg_txt := 'Couldnt find any account id to connect this project to, the project has not been created.';
elsif p_goal < 0 then 
err_msg_txt := 'the goal must be have greater value than 0.';
elsif p_volunteer_need not in (' Yes', 'No') then 
err_msg_txt := 'the answer must be either yes or no.';
elsif p_project_status not in ('Closed', 'Completed', 'Open', 'Submitted', 'Underway') then
err_msg_txt := 'The project status should be one of the following Closed, Completed, Open, Submitted,  Underway';

elsif p_creation_date is null then
SELECT SYSDATE
INTO lv_creation_date
FROM dual;

elsif p_creation_date is not null then
lv_creation_date := p_creation_date;

elsif p_deadline <= lv_creation_date then 
err_msg_txt := ' The deadling date for your project should be later than the creation date ';
end if;



INSERT INTO I_PROJECT (project_id,project_title,project_goal,project_deadline,project_creation_date,project_description,project_subtitle,project_street_1,project_street_2,project_city,project_state,
project_postal_code,project_postal_extension,project_steps_to_take,project_motivation,project_volunteer_need,project_status,account_id ) VALUES (

    Autoincrement_sequence.nextval,
    p_title,
    p_goal,
    p_deadline,
    p_creation_date,
    p_description,
    p_subtitle,
    p_street_1,
    p_street_2,
    p_city,
    P_state,
    p_postal_code,
    p_postal_extension,
    p_steps_to_take,
    p_motivation,
    p_volunteer_need,
    p_project_status,
    p_account_id
    );
    
    


COMMIT;

    
    
    
    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;
    
    
END CREATE_PROJECT_PP;
end ioby3a_pkg;