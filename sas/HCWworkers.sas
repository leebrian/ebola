/*
to be run on Mar09 using the Mar08 extract
previously run on Mar05 using the Mar04 extract
*/

dm 'cle log; cle out';

ods html close; 
ods html; 

title;
footnote;

run;

proc datasets lib=work kill;
run;
quit;
run;

options pageno=1 nocenter ls=163 ps=53 obs=max nodate missing='-' mprint mlogic nofmterr orientation=landscape;

%let program= %sysget (sas_execfilename);
%let program_root=%scan(&program,1,.);

%let analypath= C:\sas;
%let pgmpath= C:\sas\programs;
filename saslog 'C:\sas\log';
libname saslib 'C:\sas\Datasets';

run;

data _null_;
tempdate=left(put(date(),weekdate32.));
temptime=left(put(time(),hhmm5.));
call symput("currtime",temptime);
call symput("currdate",tempdate);
put "***RUN DATE= " tempdate /"***RUN TIME = " temptime "Eastern Time";

run;

title1 		 "Health Care facilities list";
title2		 "List generated based on Mar 08, 2015 EpiInfo dataset";
title3		 "Includes comparisons with Mar 04, 2015 EpiInfo dataset";

footnote1    "Program:  &program";
*footnote2    Input:   ";
footnote3    "Output:   &analypath\ou	tput\&program_root..rtf";
footnote4   "Run date=&currdate. at RUN TIME=&currtime.";

run;

ods rtf file="C:\sas\output\&program_root..rtf" STYLE=journal nobodytitle;

ods listing close;

run;

proc format;
 value casef
 1='Confirme'
 2='Probable'
 3='Suspect'
;

value sexf
1='Homme'
2='Femme'
;

value $match
1='Yes'
2='No'
;
run;


data HCWworkers_current;
 set saslib.mar08;
if HCW='True' and EpiCaseDef in (1,2,3) then HCWflag='1';
 HCWpositiontrim=trim(HCWposition);
  *if HCW='1' and EpiCaseDef in (1,2,3) then HCWflag=1;  *coding of HCW has changed from 1 to True;
run;

data HCWworkers_previousday;
 set saslib.mar04;

run;

proc sort data=HCWworkers_current; 
 by GlobalRecordID;

run;

proc sort data=HCWworkers_previousday;
 by GlobalRecordID;

run;

data HCW_new;
 merge HCWworkers_current (in=a) HCWworkers_previousday (in=b);
 by GlobalRecordID;
 if a and not b then match = '1';
 if a and b then match='2';

run;

proc sort data=HCW_new;
 by  match descending datereport;

run;

ods rtf close;
ods listing;

run;

ods rtf file="C:\sas\output\HCWworkers_08mar.rtf" STYLE=journal nobodytitle;

ods listing close;

run;
proc report nowd data=HCW_new;
  where HCWflag='1';
  column match DateOnset DateReport ID EpiCaseDef OtherNames Surname Age Gender HCWposition HCWFacility PhoneNumber;
  define match/group "New since last report?" format=$match. order=internal;
  *define DateReport/group "Date Reported"  order=data;
  define ID/"ID";
  define EpiCaseDef/order=data "Case type" format=casef.;
  define OtherNames /"First name" ;
  define Surname /"Surname";
  define Age/ "Age";
  define Gender/"Sex" format=sexf.;
  define HCWpositiontrim/"Health Care Worker position";
  define HCWFacility/"Health Care Facility";
  define PhoneNumber/'Phone number';
/*
 title1 "List of health care workers";
 title2 "Restricted to those who are confirmed, probable, or suspect cases";
 title3 '&nobs';
 */
run;

ods rtf close;
ods listing;

dm log "file saslog(&program_root.) replace";

run;

