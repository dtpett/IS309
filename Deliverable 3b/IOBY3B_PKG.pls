create or replace package body ioby3B_pkg 
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
IS
p_count number (10);
ex_error exception;
err_msg_txt varchar(100) :=null;

BEGIN

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
p_volunteer_need    IN  VARCHAR,  
p_project_status    IN  VARCHAR,  
p_account_id        IN  INTEGER   
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
    
    end CREATE_PROJECT_PP;
    
procedure   CREATE_GIVING_LEVEL_PP (
p_projectID             IN INTEGER,
p_givingLevelAmt        IN NUMBER,         
p_givingDescription     IN VARCHAR     
)
IS
p_check number (10);
ex_error exception;
err_msg_txt varchar(100) :=null;
ID_check number;
lv_giving_level_amount  I_GIVING_LEVEL.GIVING_LEVEL_AMOUNT%type;

BEGIN
   SELECT count (*)
        INTO ID_check
        FROM I_PROJECT
            WHERE PROJECT_ID = p_projectID;
            
    

if ID_check = 0
    then
   err_msg_txt := 'The project ID does not exists yet, please use an existing project ID ';
   raise ex_error;
elsif p_check < 0
then
err_msg_txt := 'The Donation can not be a zero ';
raise ex_error;

elsif p_givingDescription is null then
err_msg_txt := 'the description must not be null.';
raise ex_error;
end if;
select giving_level_amount into lv_giving_level_amount from I_giving_level where giving_level_amount = p_givingLevelAmt;

if p_givingLevelAmt = lv_giving_level_amount 
    THEN UPDATE I_GIVING_LEVEL
        SET  GIVING_LEVEL_DESCRIPTION = p_givingDescription 
            where GIVING_LEVEL_AMOUNT = p_givingLevelAmt;
            COMMIT;
elsif p_givingLevelAmt != lv_giving_level_amount then
INSERT INTO I_GIVING_LEVEL ( PROJECT_ID, GIVING_LEVEL_AMOUNT, GIVING_LEVEL_DESCRIPTION ) VALUES (
    p_projectID,
    p_givingLevelAmt,
    p_givingDescription
);
commit;
end if;






    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

    end CREATE_GIVING_LEVEL_PP;
    
procedure ADD_BUDGET_ITEM_PP (
p_projectID             IN INTEGER,
p_description           IN VARCHAR,   
p_budgetAmt             IN NUMBER
)
IS
ex_error exception;
err_msg_txt varchar(100) :=null;
    ID_check NUMBER;
  i_count number;


BEGIN
    SELECT count(*)
        INTO ID_check
        FROM I_BUDGET
    WHERE PROJECT_ID = p_projectID;

   SELECT count(*)
     INTO i_count
     FROM I_BUDGET
    WHERE BUDGET_LINE_ITEM_DESCRIPTION = p_description;

    IF ID_check = 0
        THEN
       err_msg_txt := 'The project ID does not exists yet, please use an existing project ID ';
         raise ex_error;
elsif p_description is null then
err_msg_txt := 'the description must not be null.';
raise ex_error;
      ELSIF i_count = 1 
        THEN
      err_msg_txt := 'The description already exists';
      raise ex_error;
      
   END IF;

  Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;
    end ADD_BUDGET_ITEM_PP;
    
procedure ADD_WEBSITE_PP (
p_accountEmail          IN VARCHAR,
p_websiteOrder          IN INTEGER,  
p_websiteTitle          IN VARCHAR,
p_websiteURL            IN VARCHAR
)
IS
BEGIN
    DECLARE
        invalid_input           EXCEPTION;
        no_account_exists       EXCEPTION;
        null_input_exists       EXCEPTION;
 
        not_null_msg            VARCHAR2(100) := NULL;
        accountId               INT;
    BEGIN
        IF p_accountEmail IS NULL THEN
            SELECT not_null_msg || chr(10) || '  Email ' INTO not_null_msg FROM dual;
        END IF;
        IF p_websiteURL IS NULL THEN
            SELECT not_null_msg || chr(10) ||  '  URL ' INTO not_null_msg FROM dual;
        END IF;
        IF p_websiteTitle IS NULL THEN
            SELECT not_null_msg || chr(10) || '  Description ' INTO not_null_msg FROM dual;
        END IF;
        IF NOT not_null_msg IS NULL THEN
            RAISE null_input_exists;
        END IF;
       
        SELECT Account_ID INTO accountId FROM I_ACCOUNT WHERE UPPER(ACCOUNT_EMAIL) = UPPER(p_accountEmail);
        IF accountId IS NULL THEN
            RAISE no_account_exists;
        END IF;
       
        INSERT INTO I_WEBSITE
            (ACCOUNT_ID, WEBSITE_ORDER, WEBSITE_TITLE, WEBSITE_URL)
            VALUES (accountId, p_websiteOrder, p_websiteTitle, p_websiteURL);
       
        DBMS_OUTPUT.PUT_LINE('A website has been added for account id: ' || accountId);
           
        COMMIT;
       
    EXCEPTION
        WHEN null_input_exists THEN
            DBMS_OUTPUT.PUT_LINE('Missing Input Data.');
            DBMS_OUTPUT.PUT_LINE('Please make sure to provide input for the following fields: ' || not_null_msg);
            ROLLBACK;        
        WHEN no_account_exists THEN
            DBMS_OUTPUT.PUT_LINE('Account does not exist.');
            DBMS_OUTPUT.PUT_LINE('No account has been found for the email address provided. Please use a different email.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An Error occurred');
            DBMS_OUTPUT.PUT_LINE('The error number: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('The error message: ' || SQLERRM);
            ROLLBACK;    
    END;
END ADD_WEBSITE_PP;
    
procedure ADD_FOCUSAREA_PP (
p_project_ID            IN INTEGER,
p_focusArea             IN VARCHAR
)
is
ex_error    EXCEPTION;
err_msg_txt VARCHAR(100) := NULL;
count_ID number;
count_Area number;
begin

if p_project_ID  is null then
err_msg_txt := 'the project id is null and it cannot be null';
Raise ex_error;

select count (PROJECT_ID) into count_ID
from I_PROJECT
where PROJECT_ID = p_project_ID ;
elsif count_ID < 1 then
err_msg_txt := ' the project id does not exists';
Raise ex_error;

end if;


if p_focusArea is null then
err_msg_txt := 'the focusArea is null and it cannot be null';
Raise ex_error;

select count (FOCUS_AREA_NAME) into count_Area
from I_PROJ_FOCUSAREA
where FOCUS_AREA_NAME = p_focusArea;
elsif count_Area < 1-10 then
err_msg_txt := ' the FocusArea does not exists';
Raise ex_error;

end if;

Commit;

Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

    end ADD_FOCUSAREA_PP;
    
procedure ADD_PROJTYPE_PP (
p_project_ID            IN INTEGER,
p_projType              IN VARCHAR
)
is

ex_error    EXCEPTION;
err_msg_txt VARCHAR(100) := NULL;
count_ID number;
count_Type number;



begin

if p_project_id is null then
err_msg_txt := 'the project id is null and it cannot be null';
Raise ex_error;

select count (project_id) into count_id 
from I_project 
where project_id = p_project_id;
elsif count_id < 1 then 
err_msg_txt := ' the project id does not exists';
Raise ex_error;

end if;


if p_projType is null then 
err_msg_txt := 'the project type is null and it cannot be null';
Raise ex_error;

select count (project_type_name) into count_type
from I_PROJECT_TYPE
where project_type_name = p_projType;
elsif count_type < 1 then
err_msg_txt := ' the project type does not exists';
Raise ex_error;

end if;

Commit;

Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

    end ADD_PROJTYPE_PP;
    
procedure CREATE_ACCOUNT_PP (
  p_account_id      OUT INTEGER,
  p_email           IN VARCHAR,   
  p_password        IN VARCHAR,   
  p_location_name   IN VARCHAR,   
  p_account_type    IN VARCHAR,   -- should have value of 'Group or organization' or 'Individual'
  p_first_name      IN VARCHAR,   -- must not be NULL
  p_last_name       IN VARCHAR,   -- must not be NULL
  p_street          IN VARCHAR,   -- must not be NULL
  p_additional      IN VARCHAR,
  p_city            IN VARCHAR,   -- must not be NULL
  p_stateprovince   IN VARCHAR,   
  p_postalCode      IN CHAR,      -- nust not be NULL
  p_heardAbout      IN VARCHAR,   -- nust not be NULL
  p_heardAboutdetail IN VARCHAR
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

UPDATE I_ACCOUNT 
set ACCOUNT_STREET = p_street,
    ACCOUNT_ADDITIONAL = p_additional,
    ACCOUNT_CITY = p_city,
    ACCOUNT_STATE_PROVINCE = p_stateprovince,
    ACCOUNT_POSTAL_CODE = p_postalCode,
    ACCOUNT_HEARD_ABOUT = p_heardAbout,
    ACCOUNT_HEARD_ABOUT_DETAIL = p_heardAboutdetail
    where account_email = p_email; 
    elsif p_count = 0 then 
    
    INSERT INTO I_ACCOUNT ( ACCOUNT_ID,ACCOUNT_EMAIL,ACCOUNT_PASSWORD,ACCOUNT_LOCATION_NAME,ACCOUNT_TYPE,ACCOUNT_FIRST_NAME,ACCOUNT_LAST_NAME, ACCOUNT_STREET, ACCOUNT_ADDITIONAL, ACCOUNT_CITY, ACCOUNT_STATE_PROVINCE, ACCOUNT_POSTAL_CODE, ACCOUNT_HEARD_ABOUT, ACCOUNT_HEARD_ABOUT_DETAIL ) VALUES (
    Account_sequences.nextval, 
    p_email,
    p_password,
    p_location_name,
    p_account_type,
    p_first_name,
    p_last_name, 
    p_street,
    p_additional,
    p_city,
    p_stateprovince,
    p_postalCode,
    p_heardAbout,
    p_heardAboutdetail
    );
   


    elsif p_account_type not in ('Individual', 'Organization or Group') then 
    err_msg_txt := ' "The account type must be one of these "group or organization"  or "individual." '; 
    elsif p_first_name is null then
    err_msg_txt := ' the First name must not be null.';
    elsif p_last_name is null then 
    err_msg_txt := ' the First name must not be null.';
    elsif p_street is null then 
    err_msg_txt := ' the First name must not be null.';
    elsif p_city is null then 
    err_msg_txt := ' the First name must not be null.';
    elsif p_postalCode is null then 
    err_msg_txt := ' the First name must not be null.';
    elsif p_heardAbout is null then 
    err_msg_txt := ' the First name must not be null.';
    elsif p_heardAbout not in ('another organization', 'newsletter', 'by attending an ioby event', 'from a friend', 'ioby email', 'other', 'social media', 'someone I know has used ioby', 'web search' ) then
    err_msg_txt := ' "The heardAbout must be one of the following "another organization" or "newsletter" or " by attending an ioby event, etc" ';
    end if;    

    
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
    
procedure ADD_DONATION_PP (
  p_projectID       IN out INTEGER,
  p_accountEmail    IN VARCHAR,
  p_amount          IN NUMBER     -- must not be NULL; must be > 0
)

is
any_rows_found number;
ex_error exception;
err_msg_txt varchar(300) :=null;

begin

select count (*)
into any_rows_found
from I_DONATION_CART
where p_accountEmail = account_email 
and   p_projectID = Project_Id;
    
if any_rows_found = 1 then
err_msg_txt := 'there already exists a donation for the given project, please increase the amount of donation of previous donation.';
raise ex_error;
elsif p_amount < 0 then 
err_msg_txt := ' the amount must be greater or equals zero ';
raise ex_error;

end if;






INSERT INTO I_DONATION_CART (Project_Id, account_email, amount ) values (
p_projectID,
p_accountEmail,
p_amount

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

end ADD_DONATION_PP;
    
procedure UPDATE_DONATION_PP (
  p_projectID       IN INTEGER,
  p_accountEmail    IN VARCHAR,
  p_amount          IN NUMBER     -- must not be NULL; must be > 0
)
is
any_rows_found number;
p_count number (10);
ex_error exception;
err_msg_txt varchar(300) :=null;

begin
   select count (*)
into any_rows_found
from I_DONATION_CART
where p_accountEmail = account_email and
    p_projectID = Project_Id;
    
    if p_amount is null then
    err_msg_txt := 'The amount must not be null.';
    raise ex_error;
    elsif p_amount  <= 0  then 
    err_msg_txt := 'The amount of the donation must be greater than 0';
    raise ex_error;
    elsif any_rows_found = 1 then
    update I_DONATION_CART 
    SET amount = p_amount
    where p_accountEmail = account_email and
          p_projectID = project_id;
    elsif any_rows_found = 0 then 
    err_msg_txt := 'We cannot find the given donation you are looking for, click here to add a donation to the desired project' ;
    raise ex_error;

    
    
    end if;
    
    
    
    commit;
    
    
    
    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;
    
    end UPDATE_DONATION_PP;
    
procedure VIEW_CART_PP (
  p_accountEmail    IN VARCHAR
)
IS 
p_amounts i_donation_cart.amount%type :=null;
p_project_title i_project.project_title%type :=null;
Total_amount number;
amounts number;
ex_error exception;
err_msg_txt varchar(300) :=null;




cursor cart_amount_cur
is
    select project_title, amount
    from i_donation_cart
    inner join I_Project
    on i_donation_cart.project_id = I_Project.Project_Id;

BEGIN

open cart_amount_cur;

    loop 
        fetch cart_amount_cur into p_project_title, p_amounts;
        exit when cart_amount_cur%notfound;
        dbms_output.put_line('Project: ' || p_project_title);
        dbms_output.put_line('Donation: ' || p_amounts);
  
end loop;
close cart_amount_cur;


select sum (amount) into Total_amount
from i_donation_cart;
Dbms_Output.Put_Line('Total amount of the donations ' || Total_Amount);



COMMIT;


    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

    end VIEW_CART_PP;
    
procedure CHECKOUT_PP (
  p_accountEmail    IN VARCHAR,      -- Must not be NULL
  p_date            IN DATE,         -- If NULL, use CURRENT_DATE
  p_anonymous       IN VARCHAR,      -- default value is 'yes'.  
  p_displayName     IN VARCHAR,    
  p_giveEmail       IN VARCHAR,      -- default value is 'no'
  p_billingFirstName IN VARCHAR,
  p_billingLastName IN VARCHAR,      -- must not be NULL
  p_billingAddress  IN VARCHAR,      -- must not be NULL
  p_billingState    IN VARCHAR,      -- must not be NULL
  p_zipcode         IN VARCHAR,      -- must not be NULL
  p_country         IN VARCHAR,      -- must not be NULL
  p_creditCard      IN VARCHAR,      -- must not be NULL
  p_expMonth        IN NUMBER,       -- must not be NULL
  p_expYear         IN NUMBER,       -- must be > 2015
  p_secCode         IN NUMBER,       -- must not be NULL
  p_orderNumber    OUT NUMBER
)
is

Total_amount number;
p_creation_date Date;
ex_error exception;
err_msg_txt varchar(300) :=null;
v_account_id i_donation.account_id%type :=null;
v_project_id i_donation_detail.project_id%type :=null;
v_donation_order_number i_donation.donation_order_number%type :=null;
v_amount i_donation_cart.amount%type :=null;
v_order_number number;

begin

v_order_number := DONATION_SEQUENCES.nextval;



SELECT ACCOUNT_ID INTO v_ACCOUNT_ID
FROM i_donation_cart
WHERE ACCOUNT_EMAIL = p_accountEmail;

select project_id into v_project_id
from i_donation_cart
where account_email = p_accountEmail;


select amount into v_amount
from i_donation_cart
where account_email = p_accountEmail;







select sum (amount) into Total_amount
from i_donation_cart;



if p_accountEmail is null then
    err_msg_txt := 'the account email cannot be null';
    raise ex_error;
    elsif p_date is null then
    SELECT SYSDATE
    INTO p_creation_date
    FROM dual;
    elsif p_anonymous not in ('yes', 'no') then 
    err_msg_txt := 'You have to choose between yes or no when it comes to staying anonymous or not ';
    raise ex_error;
    elsif p_giveEmail not in ('yes', 'no') then
    err_msg_txt := 'You have to choose between yes or no on wether you want to give your email or not ';
    elsif p_billingLastName is null then
    err_msg_txt := 'the billing last name cannot be null';
    raise ex_error;
    elsif p_billingAddress is null then
    err_msg_txt := 'The billing adress cannot be null';
    raise ex_error;
    elsif p_billingState is null then
    err_msg_txt := ' The billing state cannot be null';
    raise ex_error;
    elsif p_zipcode is null then 
    err_msg_txt := 'The zipcode cannot be null';
    raise ex_error;
    elsif p_country is null then 
    err_msg_txt := 'The country cannot be null';
    raise ex_error;
    elsif p_creditCard is null then 
    err_msg_txt := 'The credit card information cannot be null';
    raise ex_error;
    elsif p_expMonth is null then 
    err_msg_txt := 'The experation month  cannot be null';
    raise ex_error;
    elsif p_expYear  < 2015 then
    err_msg_txt := 'The experation year  cannot longer than 2015';
    raise ex_error;
    elsif p_secCode is null then 
    err_msg_txt := 'The security code cannot be null';
    raise ex_error;

    end if;
    
    
    
    INSERT INTO I_Donation (Donation_order_number, donation_date, donation_anonymous, donation_display_name, donation_give_email, donation_total, account_id) values (
    
    v_order_number,
    p_date,
    p_anonymous,
    p_displayName,
    p_giveEmail,
    Total_amount,
    v_account_id
    );
    

   
     INSERT INTO i_donation_detail (donation_detail_amount, donation_order_number, project_id, donation_detail_id) values ( 
    
    v_amount,
    v_order_number,
    v_project_id,
    DETAIL_SEQUENCE.nextval
    );
    
    
    INSERT INTO I_BILLING (billing_first_name, billing_country, billing_last_name, billing_address_1, billing_state, billing_zipcode, billing_card_number, billing_card_exp_month, billing_card_exp_year, billing_card_security_code, donation_order_number) values (
    
    
    p_billingFirstName,
    p_country,
    p_billingLastName,
    p_billingAddress,
    p_billingState,
    p_zipcode,
    p_creditCard,
    p_expMonth,
    p_expYear,
    p_secCode,
    v_order_number
    ); 

delete  from I_donation_cart;


    
 
    
    
COMMIT;


    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

    end CHECKOUT_PP;
    
function CALC_PERCENT_OF_GOAL_PF (
  p_projectID       IN Integer
) RETURN NUMBER
 is
ex_error exception;
err_msg_txt varchar(100) :=null;
P_PROJECT_GOAL I_PROJECT.PROJECT_GOAL%TYPE;
p_TOTAL_DONATIONS I_DONATION_DETAIL.DONATION_DETAIL_AMOUNT%TYPE;
p_percent NUMBER;
  BEGIN


    select PROJECT_GOAL into P_PROJECT_GOAL from I_PROJECT where PROJECT_ID = p_projectID;
    SELECT (SUM(DONATION_DETAIL_AMOUNT)) INTO p_TOTAL_DONATIONS FROM I_DONATION_DETAIL WHERE PROJECT_ID = p_projectID;

      p_percent := (p_TOTAL_DONATIONS  / p_PROJECT_GOAL) * 100;
      p_percent := TRUNC (p_percent, 0);

dbms_output.put_line(' The procent reach is: ' || p_percent || '% of the goal');
      


if p_percent > P_PROJECT_GOAL
then err_msg_txt := 'the goal is not yet reach ';
raise ex_error;
elsif p_percent is null
then err_msg_txt := 'there is no donation in it';
raise ex_error;

end if;


    COMMIT;
    RETURN p_percent;
    
    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    WHEN NO_DATA_FOUND 
then dbms_output.put_line(' no project found');
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;

end CALC_PERCENT_OF_GOAL_PF;

procedure STATUS_UNDERWAY_PP
is
p_PROJECT_STATUS varchar (200);
ex_error exception;
err_msg_txt varchar(100) :=null;
  p_projectID I_PROJECT.PROJECT_ID%type;
  p_project_goal I_PROJECT.PROJECT_GOAL%type;
  p_donation_total_amount I_DONATION_DETAIL.DONATION_DETAIL_AMOUNT%type;
cursor cur_ProjectID is SELECT PROJECT_ID FROM I_PROJECT WHERE PROJECT_STATUS = 'Open';

BEGIN
    p_project_status := ('Underway');
   open cur_ProjectID;

  LOOP
      FETCH cur_ProjectID INTO p_projectID;
       EXIT WHEN cur_ProjectID%NOTFOUND;
       
     
      
      
SELECT PROJECT_GOAL INTO p_project_goal FROM I_PROJECT WHERE PROJECT_ID = p_projectID;
SELECT SUM(DONATION_DETAIL_AMOUNT) INTO p_donation_total_amount FROM I_DONATION_DETAIL WHERE PROJECT_ID = p_projectID;

END LOOP;

IF p_donation_total_amount >= p_project_goal then
UPDATE I_PROJECT
SET PROJECT_STATUS = p_project_status
WHERE PROJECT_ID = p_projectID;

DBMS_OUTPUT.PUT_LINE('Project id' || p_projectID || ' is now Underway');

end if ;
 CLOSE cur_ProjectID;
    
COMMIT;
  







    Exception
    when ex_error then
    dbms_output.put_line(err_msg_txt);
    rollback;
    when others then
    dbms_output.put_line(' the error code is: ' || sqlcode);
    dbms_output.put_line(' the error msg is: ' || sqlerrm);
    rollback;
end STATUS_UNDERWAY_PP;
end ioby3b_pkg;