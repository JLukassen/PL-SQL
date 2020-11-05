1:
DECLARE
  lv_ord_date DATE;
  lv_shipper  VARCHAR2(20);
  lv_ship_num VARCHAR2(5);
  lv_idstage  NUMBER(1,0):=5;
  lv_idbasket NUMBER(5,0);
BEGIN
  SELECT BB.DTSTAGE,
    BB.SHIPPER,
    BB.SHIPPINGNUM,
    BB.IDSTAGE,
    BB.IDBASKET
  INTO lv_ord_date,
    lv_shipper,
    lv_ship_num,
    lv_idstage,
    lv_idbasket
  FROM BB_BASKETSTATUS BB
  WHERE IDBASKET = lv_idbasket
  AND idstage    = 5;
  DBMS_OUTPUT.PUT_LINE('order date: ' ||lv_ord_date);
  DBMS_OUTPUT.PUT_LINE('shipper: ' ||lv_shipper);
  DBMS_OUTPUT.PUT_LINE('ship num: ' ||lv_ship_num);
  DBMS_OUTPUT.PUT_LINE('shipped: ' ||lv_idbasket);
  DBMS_OUTPUT.PUT_LINE('basket num ' ||lv_idbasket);
END;


2:
DECLARE
  lv_ord_date BB_BASKETSTATUS.DTSTAGE%TYPE;
  lv_shipper BB_BASKETSTATUS.SHIPPER%TYPE;
  lv_ship_num BB_BASKETSTATUS.SHIPPINGNUM%TYPE;
  lv_idstage BB_BASKETSTATUS.IDSTAGE%TYPE :=5;
  lv_idbasket BB_BASKETSTATUS.IDBASKET%TYPE;
BEGIN
  SELECT BB.DTSTAGE,
    BB.SHIPPER,
    BB.SHIPPINGNUM,
    BB.IDSTAGE,
    BB.IDBASKET
  INTO lv_ord_date,
    lv_shipper,
    lv_ship_num,
    lv_idstage,
    lv_idbasket
  FROM BB_BASKETSTATUS BB
  WHERE IDBASKET = lv_idbasket
  AND idstage    = 5;
  DBMS_OUTPUT.PUT_LINE('order date: ' ||lv_ord_date);
  DBMS_OUTPUT.PUT_LINE('shipper: ' ||lv_shipper);
  DBMS_OUTPUT.PUT_LINE('ship num: ' ||lv_ship_num);
  DBMS_OUTPUT.PUT_LINE('shipped: ' ||lv_idbasket);
  DBMS_OUTPUT.PUT_LINE('basket num ' ||lv_idbasket);
END;


3:

DECLARE
  proj_name DD_PROJECT.projname%type;
  proj_id DD_PROJECT.idproj%type;
  pledge_count DD_PLEDGE.pledgeamt%type;
  pledge_average DD_PLEDGE.pledgeamt%type;
  pledge_sum DD_PLEDGE.pledgeamt%type;
BEGIN
  SELECT DD_PROJECT.idproj,
    projname,
    COUNT(pledgeamt),
    SUM(pledgeamt),
    AVG(pledgeamt)
  INTO proj_id,
    proj_name,
    pledge_count,
    pledge_sum,
    pledge_average
  FROM dd_pledge,
    dd_project
  WHERE DD_PLEDGE.idproj = DD_PROJECT.idproj
  AND DD_PROJECT.idproj  = proj_id
  GROUP BY DD_PROJECT.idproj,
    projname;
  DBMS_OUTPUT.PUT_LINE('Project ID: ' || proj_id ||' Project Name: ' || proj_name ||' Total Pledges Made: ' || pledge_count ||' Total Dollars Pledged: ' || pledge_sum||' Average Dollars Pledged: ' || pledge_average );
END;


4:

CREATE SEQUENCE dd_project_seq MINVALUE 1 START WITH 530 INCREMENT BY 1 NOCACHE;
  DECLARE
  TYPE type_project
IS
  RECORD
  (
    project_name dd_project.projname%type        := 'HK Animal Shelter Extension',
    project_start dd_project.projstartdate%type  := '01-JAN-13',
    project_end dd_project.projenddate%type      := '31-MAY-13',
    project_funding dd_project.projfundgoal%type := '65000');
  new_project type_project;
BEGIN
  INSERT
  INTO dd_project
    (
      idproj,
      projname,
      projstartdate,
      projenddate,
      projfundgoal
    )
    VALUES
    (
      dd_project_seq.NEXTVAL,
      new_project.project_name,
      new_project.project_start,
      new_project.project_end,
      new_project.project_funding
    );
  COMMIT;
END;


5:

DECLARE
  PLEDGES DD_PLEDGE%ROWTYPE;
  START_MONTH_DATE DD_PLEDGE.PLEDGEDATE%TYPE := '01-OCT-12';
  END_MONTH_DATE DD_PLEDGE.PLEDGEDATE%TYPE   := '31-OCT-12';
BEGIN
  FOR PLEDGES IN
  (SELECT IDPLEDGE,
    IDDONOR,
    PLEDGEAMT,
    CASE
      WHEN PAYMONTHS=0
      THEN 'Lump Sum.'
      ELSE 'Monthly -'
        || PAYMONTHS
    END AS MONTHLY_PAYMENT
  FROM DD_PLEDGE
  WHERE PLEDGEDATE >= START_MONTH_DATE
  AND PLEDGEDATE   <= END_MONTH_DATE
  ORDER BY PAYMONTHS
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || PLEDGES.IDPLEDGE || ', Donor ID: '|| PLEDGES.IDDONOR || ', Pledge Amount: ' ||TO_CHAR(PLEDGES.PLEDGEAMT,'$9999.99') || ', Monthly Payments: ' || PLEDGES. MONTHLY_PAYMENT);
  END LOOP;
END;

6:

DECLARE
  PLEDGES DD_PLEDGE%ROWTYPE;
  TOTAL_PLEDGE_TO_PAY DD_PLEDGE.PLEDGEAMT%TYPE;
  BALANCE DD_PLEDGE.PLEDGEAMT%TYPE;
  MONTHS_PAID NUMBER(5);
BEGIN
  SELECT * INTO PLEDGES FROM DD_PLEDGE WHERE IDPLEDGE =& PLEDGE_ID;
  MONTHS_PAID          := PLEDGES.PAYMONTHS;
  IF PLEDGES.PAYMONTHS  =0 THEN
    TOTAL_PLEDGE_TO_PAY:= PLEDGES.PLEDGEAMT;
  ELSE
    TOTAL_PLEDGE_TO_PAY := MONTHS_PAID * (PLEDGES.PLEDGEAMT/PLEDGES.PAYMONTHS);
  END IF;
  BALANCE := PLEDGES.PLEDGEAMT -TOTAL_PLEDGE_TO_PAY;
  DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || PLEDGES.IDPLEDGE || ', Donor ID: ' || PLEDGES.IDDONOR ||', Amount paid: ' || TOTAL_PLEDGE_TO_PAY || ' ' || ', Balance: ' || BALANCE);
END;


7:

DECLARE
  PROJECT_NAME DD_PROJECT.PROJNAME%TYPE;
  DATE_START DD_PROJECT.PROJSTARTDATE%TYPE;
  FUNDRAISING_GOAL DD_PROJECT.PROJFUNDGOAL%TYPE;
  PROJECT_ID DD_PROJECT.IDPROJ%TYPE:= '502';
  NEW_FUNDRAISING_GOAL DD_PROJECT.PROJFUNDGOAL%TYPE:= '250000';
BEGIN
  SELECT PROJNAME,
    PROJSTARTDATE,
    PROJFUNDGOAL
  INTO PROJECT_NAME,
    DATE_START,
    FUNDRAISING_GOAL
  FROM DD_PROJECT
  WHERE IDPROJ = PROJECT_ID;
  UPDATE DD_PROJECT SET PROJFUNDGOAL = NEW_FUNDRAISING_GOAL;
  DBMS_OUTPUT.PUT_LINE('Project Name: ' || PROJECT_NAME ||', Start Date: ' ||DATE_START || ', Previous Goal: ' || FUNDRAISING_GOAL || ', New Goal: ' ||NEW_FUNDRAISING_GOAL);
END;