CASE 1:
================================================================================

The Procedure Editor in Oracle SQL Developer is a PL/SQL IDE. You can compile, execute, and debug PL/SQL with the Procedure Editor. Another feature of Oracle SQL Developer is the ability to perorm Unit Testing. The Unit Testing allows you to confirm you PL/SQL programs are functioning properly. This can be done within the SQL Developer interface or through the command line. 

CASE 2:
================================================================================
1.

select MO.MOVIE_ID, MO.MOVIE_TITLE, MO.MOVIE_CAT_ID, MT.MOVIE_CATEGORY
from MM_MOVIE MO, MM_MOVIE_TYPE MT
WHERE MT.MOVIE_CAT_ID = MO.MOVIE_CAT_ID;

MM_MOVIE 
(
	MOVIE_ID
	MOVIE_TITLE
	MOVIE_CAT_ID
	MOVIE_VALUE
	MOVIE_QTY
)


2.

select ME.MEMBER_ID, ME.LAST, ME.SUSPENSION 
from MM_MEMBER ME;

No members are currently suspended. 

3.

select MO.MOVIE_ID, MO.MOVIE_TITLE, MR.CHECKOUT_DATE, ME.MEMBER_ID, ME.LAST
from MM_MEMBER ME, MM_MOVIE MO, MM_RENTAL MR
WHERE MO.MOVIE_ID = MR.MOVIE_ID
AND ME.MEMBER_ID = MR.MEMBER_ID;


CHECKOUT_DATE = 04-JUN-12


CASE 3:
================================================================================

