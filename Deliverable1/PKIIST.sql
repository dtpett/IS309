CREATE TABLE ACCOUNT (
userid                INTEGER NOT NULL,
firstname             VARCHAR2(30),
lastname              VARCHAR2(30),
username              VARCHAR2(30),
email                 VARCHAR2(30),
howabout              VARCHAR2(30),
url                   SMALLINT
);
ALTER TABLE account ADD CONSTRAINT account_pk PRIMARY KEY ( userid );

CREATE TABLE checkout (
    ordernumber         INTEGER NOT NULL,
    custommarybilling   VARCHAR2(30),
    nameoption          VARCHAR2(30),
    anonymous           VARCHAR2(30),
    leaderemail         VARCHAR2(30),
    "Date"              DATE
);

ALTER TABLE checkout ADD CONSTRAINT checkout_pk PRIMARY KEY ( ordernumber );



CREATE TABLE focusarea (
    focuseareaid   INTEGER NOT NULL,
    focusarea      VARCHAR2(200)
);

ALTER TABLE focusarea ADD CONSTRAINT focusarea_pk PRIMARY KEY ( focuseareaid );


CREATE TABLE projecttype (
    projecttypeid   INTEGER NOT NULL,
    projecttype     VARCHAR2(50)
);

ALTER TABLE projecttype ADD CONSTRAINT projecttype_pk PRIMARY KEY ( projecttypeid );



CREATE TABLE postalarea (
    postalareaid      INTEGER NOT NULL,
    postalcode        INTEGER,
    city              VARCHAR2(30)
);

ALTER TABLE postalarea ADD CONSTRAINT postalarea_pk PRIMARY KEY ( postalareaid );


CREATE TABLE adress (
    adressid                  INTEGER NOT NULL,
    streetadress              VARCHAR2(50),
    description               VARCHAR2(150),
    state                     VARCHAR2(50),
    postalarea_postalareaid   INTEGER NOT NULL
);

ALTER TABLE adress ADD CONSTRAINT adress_pk PRIMARY KEY ( adressid );

ALTER TABLE adress
    ADD CONSTRAINT adress_postalarea_fk FOREIGN KEY ( postalarea_postalareaid )
        REFERENCES postalarea ( postalareaid );
        
        


CREATE TABLE lineitem (
    lineitemid          INTEGER NOT NULL,
    projectfee          INTEGER,
    processingfee       INTEGER,
    budget              INTEGER
);

ALTER TABLE lineitem ADD CONSTRAINT lineitem_pk PRIMARY KEY ( lineitemid );


CREATE TABLE url (
    urlid            INTEGER NOT NULL,
    link             VARCHAR2(50),
    account_userid   INTEGER NOT NULL
);

ALTER TABLE url ADD CONSTRAINT url_pk PRIMARY KEY ( urlid );

ALTER TABLE url
    ADD CONSTRAINT url_account_fk FOREIGN KEY ( account_userid )
        REFERENCES account ( userid );
        
        
    CREATE TABLE project (
    projectid             INTEGER NOT NULL,
    title                 VARCHAR2(30),
    description           VARCHAR2(30),
    leader                VARCHAR2(30),
    subtitle              VARCHAR2(30),
    status                VARCHAR2(30),
    adress_adressid       INTEGER NOT NULL,
    steps                 VARCHAR2(50),
    motivation            VARCHAR2(100),
    account_userid        INTEGER,
    lineitem_lineitemid   INTEGER NOT NULL
);


ALTER TABLE project ADD CONSTRAINT project_pk PRIMARY KEY ( projectid );

ALTER TABLE project
    ADD CONSTRAINT project_account_fk FOREIGN KEY ( account_userid )
        REFERENCES account ( userid );

ALTER TABLE project
    ADD CONSTRAINT project_adress_fk FOREIGN KEY ( adress_adressid )
        REFERENCES adress ( adressid );

ALTER TABLE project
    ADD CONSTRAINT project_lineitem_fk FOREIGN KEY ( lineitem_lineitemid )
        REFERENCES lineitem ( lineitemid );    
        

CREATE TABLE projectline (
    projectlineid               INTEGER NOT NULL,
    project_projectid           INTEGER NOT NULL,
    projecttype_projecttypeid   INTEGER NOT NULL
);

ALTER TABLE projectline ADD CONSTRAINT projectline_pk PRIMARY KEY ( projectlineid );

ALTER TABLE projectline
    ADD CONSTRAINT projectline_project_fk FOREIGN KEY ( project_projectid )
        REFERENCES project ( projectid );

ALTER TABLE projectline
    ADD CONSTRAINT projectline_projecttype_fk FOREIGN KEY ( projecttype_projecttypeid )
        REFERENCES projecttype ( projecttypeid );
        
        
CREATE TABLE focusline (
focuslineid              INTEGER NOT NULL,
project_projectid        INTEGER NOT NULL,
focusarea_focuseareaid   INTEGER NOT NULL
);

ALTER TABLE focusline ADD CONSTRAINT focusline_pk PRIMARY KEY ( focuslineid );

ALTER TABLE focusline
    ADD CONSTRAINT focusline_focusarea_fk FOREIGN KEY ( focusarea_focuseareaid )
        REFERENCES focusarea ( focuseareaid );

ALTER TABLE focusline
    ADD CONSTRAINT focusline_project_fk FOREIGN KEY ( project_projectid )
        REFERENCES project ( projectid );
        

CREATE TABLE crowdfunding (
    fundid              INTEGER NOT NULL,
    funds               INTEGER,
    goal                INTEGER,
    createdate          DATE,
    deadline            DATE,
    project_projectid   INTEGER NOT NULL
);

ALTER TABLE crowdfunding ADD CONSTRAINT crowdfunding_pk PRIMARY KEY ( fundid );

ALTER TABLE crowdfunding
    ADD CONSTRAINT crowdfunding_project_fk FOREIGN KEY ( project_projectid )
        REFERENCES project ( projectid );
        
        
        CREATE TABLE donation (
    donationid                     INTEGER NOT NULL,
    notification                   VARCHAR2(100),
    donation_cart_donationcartid   INTEGER NOT NULL,
    description                    VARCHAR2(150),
    projectid references project (projectid),
    constraint donation_pk primary key (donationid, projectid)
);

        
        
      CREATE TABLE donation_cart (
    donationcartid         INTEGER NOT NULL,
    amount                 INTEGER,
    checkout_ordernumber   INTEGER NOT NULL
);

ALTER TABLE donation_cart ADD CONSTRAINT donation_cart_pk PRIMARY KEY ( donationcartid );

ALTER TABLE donation_cart
    ADD CONSTRAINT donation_cart_checkout_fk FOREIGN KEY ( checkout_ordernumber )
        REFERENCES checkout ( ordernumber );  
        
        
INSERT INTO ACCOUNT
VALUES (1, 'Shiwan', 'Hassan', 'shiwaha', 'shiwah16@uia.no', 'other websites', 1);

INSERT INTO ACCOUNT
VALUES (2, 'Daniel', 'Pettersen', 'dtpet16', 'dtpet16@uia.no', 'from a friend', null);

INSERT INTO ACCOUNT
VALUES (3, 'Eirik', 'Saalesen', 'Eiriksta', 'Eiriksta@uia.no', 'from a friend', 2);



insert into focusarea
Values (1, 'Clean Air');

insert into focusarea
Values (2, 'Clean water');

insert into focusarea
Values (3, 'Clean Ground');



INSERT INTO projecttype
values (1, 'type1');

INSERT INTO projecttype
values (2, 'type2');

INSERT INTO projecttype
values (3, 'type3');




INSERT INTO lineitem
values (1, 2000, 3000, 50000);

INSERT INTO lineitem
values (2, 1000, 2000, 70000);

INSERT INTO lineitem
values (3, 2500, 3000, 100000);




INSERT INTO postalarea
values (1, 4630, 'Kristiansand');

INSERT INTO postalarea
values (2, 4640, 'Søgne');

INSERT INTO postalarea
values (3, 4650, 'Mandal');




INSERT INTO adress
VALUES (1, 'Kaserneveien 30', 'its in kristiansand', 'vest agder', 1);


INSERT INTO adress
VALUES (6, 'Krogan 37', 'its in søgne', 'vest agder', 2);



INSERT INTO project
VALUES (1, 'Kristiansand project', 'forbedre kristiansand', 'Shiwan', 'null', 'good to go', 1,'forbedre innen fredag', 'fordi vi liker kristiansand', 1, 1);




INSERT INTO focusline
VALUES(1, 1, 1);

INSERT INTO focusline
VALUES(2, 1, 2);



INSERT INTO projectline
VALUES(1, 1, 1);


INSERT INTO projectline
VALUES(2, 1, 2);




INSERT INTO url
VALUES(1, 'facebook.com', 1);

INSERT INTO url
VALUES(2, 'linkdin.com', 2);



INSERT INTO crowdfunding
VALUES(1, 20000, 15000, '20-01-2018', '20-02-2018', 1);

INSERT INTO crowdfunding
VALUES(2, 20000, 30000, '30-03-2018', '01-06-2018', 1);




INSERT INTO checkout
VALUES (1, 'fakuta', 'Shiwan', null, null, '20.01.2018');


INSERT INTO checkout
VALUES (2, 'fakuta 2', 'Shiwan', null, null, '20.01.2018');



INSERT INTO donation_cart
VALUES(1, 200, 1);



INSERT INTO donation_cart
VALUES(2, 300, 2);


INSERT INTO donation
VALUES (1, 'you will donate', 1, 'donating to project', 1);













