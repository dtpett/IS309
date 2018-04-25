# Deliverable 4: Text
## Task files
For task 1 we have an Excel spreadsheet.
We also have two SQL files: tablespaces.sql and privileges.sql. tablespaces.sql refers to tasks 2-4 and privileges.sql refers to tasks 5-6.

## Justification for business decisions and rules
### Task 1
For determining the different values in the spreadsheet we have outlined a few reflections as to how we calculated them.
(Check the Excel spreadsheet for exact calculations - there could be errors here since it is plain text instead of formulas.)

#### Calculating amount of current information (rows)
##### I_ACCOUNT
"There are 28,768 unique donors, and 1,521 are or have been project leaders. Of these, 1,045 have been both donors and leaders." We concluded that there is 29,244 rows in I_ACCOUNT, because 1,045 people that have been both donors and leaders is takken from the sum of 26,768 unique donors + 1,521 project leaders. We subtract 1,045 to get the total number of accounts, which is 29,244

Growth per half year: There is an average of 3,000 new accounts per year. Growth per half year is therefore half the amount (1,500)

##### I_BILLING
After consulting with Peter, we decided that the amount of rows in I_BILLING is equal to the amount of rows in I_DONATION divided by two. This is because we presume there is a 2:1 relationship for the amount of donations per billing. This results in 52,505 rows in I_BILLING.

Growth per half year: I_BILLING grows half the amount of amount of donations. This is because of the 2:1 relationships between the amount of donations and billing. 

##### I_BUDGET
I_BUDGET corresponds to amount of projects (I_PROJECT). Each project has one budget. This amounts to 1,479 rows which is equal to I_PROJECT.

I_BUDGET could probably have an increase (albeit, a very small one). Therefore, a 5 PCTFREE is used.

Growth per half year: I_BUDGET has the same growth as I_PROJECT (225). 

On the NEXT EXTENT we use the minimum. 

##### I_DONATION
I_DONATION takes the amount of projects (I_PROJECT) multiplied by 71. 71 is the average amount of donations per project.

Growth per half year: Donations has an interesting formula for growth per half year. (Active Donations * Average growth per year) / 2.

An expansion of 5 bytes should be enough based on the datatypes in the table. Most are either a "fixed" size by being either yes or no, and some are not nullable. There are only two attributes that can be expanded, so 5 bytes should be enough.

##### I_DONATION_DETAIL
I_DONATION_DETAIL takes the amount of donations multiplied by 1.5, which comes from the 1:1.5 ratio described 
in the task.

Growth per half year: I_DONATION_DETAIL grows 1.5 times more than I_DONATION. I_DONATION * 1.5 = Growth per half year. 9479 * 1.5 = 14,217.75

This one has numeric values and they are not nullable. Therefore, they do not expand.

##### I_FOCUS_AREA
Again, the same ratio is used here as in I_DONATION_DETAIL. The number of focus areas is equal to the number of projects multiplied by an average of 1.5 focus areas for project.

I_FOCUS_AREA = I_PROJECT * 1.5 = 1,479 * 1.5 = 2,219.

Growth per half year: As in I_DONATION_DETAIL, there is a growth ratio, where the growth of I_DONATION is multiplied by 1.5. 225 * 1.5

An expansion of 5 bytes is also used here, simply because the table contains one attribute that could grow up to 50 characters, so expansion is possible, but less likely.

##### I_GIVING_LEVEL
Each project has an average of 3 giving levels, which means that we also take the amount of projects (1,479) multiplied by 3 giving levels.
I_GIVING_LEVEL = I_PROJECT * 3 = 1,479 * 3 = 4,437

Growth per half year: Same as in I_FOCUS_AREA and I_DONATION_DETAIL. 225 * 3 = 675 (where 3 is the average number of giving levels).

##### I_PROJ_FOCUSAREA and I_PROJ_PROJTYPE
These tables are composite keys, so they are a combination of the amount of rows in I_PROJECT + I_FOCUSAREA (I_PROJ_FOCUSAREA) and I_PROJECT + I_PROJECT_TYPE (I_PROJ_PROJTYPE). 
I_PROJ_FOCUSAREA = I_PROJECT + I_FOCUSAREA = 1,479 + 2,219 = 3,698
I_PROJ_PROJTYPE = + I_PROJECT + I_PROJECT_TYPE = 1,479 + 1,923 = 3,402

Growth per half year: We are unsure as to how to calculate this value. Feedback greatly appreciated.

##### I_PROJECT
We find the number of rows in I_PROJECT based on the information given in Assignment 4. There are, however, 267 active projects, but these projects are included in the total amount of projects given (1,479).

Growth per half year: There is an average of 450 new projects per year, so growht per half year is half the amount (225). 

##### I_PROJECT_TYPE
There is an average of 1.3 project types per project. Therefore I_PROJECT_TYPE = I_PROJECT * 1.3.
1,479 * 1.3 = 1,923

Growth per half year: like in I_FOCUS_AREA, I_GIVING_LEVEL and I_DONATION_DETAIL, we take the growth of I_PROJECT multiplied by 1.3. 225 * 1.3 = 292.5 (where 1.3 is equal to the average number of project types).

### Task 1G - extent management
We will use autoallocate and freelist auto for extent management and space management. These do the job for us automatically, and it is not necessary to take into account the possible limitations uniform extent management could give us. 

https://searchoracle.techtarget.com/answer/Understanding-autoallocate-and-segment-space-management 

## Task 4 - Indexes
The status of indexes changes from valid to unusable when moving tables into new tablespaces. A portion of the rows that had entries in the index have been moved as part of the partition split operation. The local index has also become unsuable, but only for the indexes of which the partitions where affected by the operation.

Indexes could need to be rebuilt periodically in scenarios such as:
- If the database is subjected to an extensive update
- If the database gets corrupted
- If data is moved to other tablespaces

## Task 5e
First of all we did not understand the difference between b and C, but after a while we came to the conclusion that you wanted to us to grant the role to execute some of the procedures and not the whole package. 

Another challenge was that we didnt manage to find out how to make a loop for the question C and D. so instead we wrote the grants manually as you can see. 
Another challenge we had with all of the questions was that we started with making a user instead of just creating roles and granting them what we wanted
with that being said, our time was not wasted because the next question is about creating users.


## Clarifications and comments:

Enjoy!
