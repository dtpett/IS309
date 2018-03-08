create or replace package ioby3a_pkg 
IS
procedure CREATE_ACCOUNT_PP (
  p_account_id      OUT INTEGER,
  p_email           IN VARCHAR,   -- must not be NULL
  p_password        IN VARCHAR,   -- must not be NULL
  p_location_name   IN VARCHAR,   -- must not be NULL
  p_account_type    IN VARCHAR,   -- should have value of 'Group or organization' or 'Individual'
  p_first_name      IN VARCHAR,
  p_last_name       IN VARCHAR
);
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
);
end ioby3a_pkg;
