# Deliverable 4: Text
## Task files
For task 1 we have an Excel spreadsheet.
We also have two SQL files: tablespaces.sql and privileges.sql. tablespaces.sql refers to tasks 2-4 and privileges.sql refers to tasks 5-6.

## Justification for business decisions and rules
### Task 1
For determining the different values in the spreadsheet we have outlined a few reflections as to how we calculated them.
#### Calculating amount of current information (rows)
##### I_ACCOUNT
"There are 28,768 unique donors, and 1,521 are or have been project leaders. Of these, 1,045 have been both donors and leaders." We concluded that there is 29,244 rows in I_ACCOUNT, because 1,045 people that have been both donors and leaders is takken from the sum of 26,768 unique donors + 1,521 project leaders. We subtract 1,045 to get the total number of accounts, which is 29,244

##### I_BILLING
After consulting with Peter, we decided that the amount of rows in I_BILLING is equal to the amount of rows in I_DONATION divided by two. This is because we presume there is a 2:1 relationship for the amount of donations per billing. This results in 52,505 rows in I_BILLING.

##### I_BUDGET
I_BUDGET corresponds to amount of projects (I_PROJECT). Each project has one budget. This amounts to 1,479 rows which is equal to I_PROJECT.

##### I_DONATION
I_DONATION takes the amount of projects (I_PROJECT) multiplied by 71. 71 is the average amount of donations per project.

##### I_DONATION_DETAIL
I_DONATION_DETAIL takes the amount of donations multiplied by 1.5, which comes from the 1:1.5 ratio described 
in the task.

##### I_FOCUS_AREA
Here 

##### I_PROJ_FOCUSAREA and I_PROJ_PROJTYPE
These tables are composite keys, so they are a combination of the amount of rows in I_PROJECT + I_FOCUSAREA (I_PROJ_FOCUSAREA) and I_PROJECT + I_PROJECT_TYPE (I_PROJ_PROJTYPE). 
I_PROJ_FOCUSAREA = I_PROJECT + I_FOCUSAREA = 1,479 + 2,219 = 3,698
I_PROJ_PROJTYPE = + I_PROJECT + I_PROJECT_TYPE = 1,479 + 1,923 = 3,402
(Check the Excel spreadsheet for exact calculations - there could be errors here since it is plain text
instead of formulas.)
## Clarifications and comments:
In the future, the "add_website" procedure should be a mandatory in assignment 2, because we where caught off guard for assignment 3b. "add_website" took up a lot of time when doing deliverable 3b, so it would have been an advantage if the procedure was assigned before 3b. 

Enjoy!
