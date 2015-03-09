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

data _null_;
tempdate=left(put(date(),weekdate32.));
temptime=left(put(time(),hhmm5.));
call symput("currtime",temptime);
call symput("currdate",tempdate);
put "***RUN DATE= " tempdate /"***RUN TIME = " temptime "Eastern Time";

run;

title1       "Updated Embassy request - Mar 2 2015 data requests";
title2		 "List generated based on Mar 2 EpiInfo database extraction";

footnote1    "Program:  &program";
*footnote2    Input:   ";
footnote3    "Output:   &analypath\SASoutput\&program_root..rtf";
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

value $labres
2='negative'
1='1+ positive'
;

value $date
'week1'='Jan 11-17'
'week2'='Jan 18-24'
'week3'='Jan 25-31'
'week4'='Feb 1-7'
'week5'='Feb 8-14'
'week6'='Feb 15-21'
'week7'='Feb 22-28';

;

value $confpro
1='confirmed/probable'
2='suspect/non-case';

value $atleast
1='1+ lab record'
2='no lab record';

value $commdth
1='Community death+'
2='Community death-';

value CTEf
1='CTE+'
0='CTE-';

value $dfeb
1='Feb 17-23, 2015'
0='Before Feb 17, 2015';

value $datedec
1='Dec 1, 2014 to present'
0='Before Dec 1, 2014';

value $datejan
1='Jan 26, 2014 to present'
0='Before Jan 26, 2014';

value $weeks
9='Feb 23- Mar 1'
8='Feb 16-22'
7='Feb 9-15'
6='Feb 2-8'
5='Jan 26- Feb 1'
4='Jan 19-25'
3='Jan 12-18'
;

run;

***prior to analysis;
***step 1: save Excel file as csv file;
***step 2: convert dates that will be used to short date format;
***step 3: import csv file into SAS using SAS import function;
***step 4: change file name in program below;




data new;
 set saslib.mar01;

 %let rdate=Feb17;
 %let tdate="Feb 17";


length DateSince&rdate. $1 date&rdate.labflag $1. date&rdate.labconfflag $1 date&rdate.confprob $1 
		date&rdate.commdthlabflag $1;
 length labresults $1 labresultsflag $1 recodedlabresults $1 communitydeath $1 confprobcase $1 commdth_confprob $1
 ;
 if sampleinterpret1 ne ' ' | sampleinterpret2 ne ' ' | sampleinterpret3 ne ' ' | sampleinterpret4 ne ' ' 
	| sampleinterpret5 ne ' ' | sampleinterpret6 ne ' ' | sampleinterpret7 ne ' ' then labresultsflag='1';
  else labresultsflag='2';

 if sampleinterpret1 in (1,2) | sampleinterpret2 in (1,2) | sampleinterpret3 in (1,2) | sampleinterpret4 in (1,2) 
	| sampleinterpret5 in (1,2) | sampleinterpret6 in (1,2) | sampleinterpret7 in (1,2) then labresults='1';
 else labresults=2;

if labresults=1 and epicasedef=0 then recodedlabresults=2;
 else if labresults=1 and epicasedef=2 then recodedlabresults=2;

if placedeath =1 then communitydeath='1';
 else if placedeath =2 then communitydeath='2';

if epicasedef in (1,2) then confprobcase='1';
 else confprobcase='2';

if confprobcase=1 & communitydeath=1 then commdth_confprob=1;

*creates flag that restricts observations to period of interest;
if datereport ge '17feb2015'd and datereport le '01mar2015'd then DateSince&rdate.='1';
 else DateSince&rdate.='0';

*creating a flag that limits observations to only those with lab results within time period of interest;
if DateSince&rdate='1' and labresultsflag='1' then date&rdate.labflag='1';
 else date&rdate.labflag='0';

*creating a flag that limits observations to confirmed cases in time period of interest;
 if DateSince&rdate.='1' and labresultsflag='1' and labresults='1' then date&rdate.labconfflag='1';
 else date&rdate.labconfflag='0';

*creating a flag that limits observations to confirmed cases in time period of interest;
 if DateSince&rdate.='1' and epicasedef in (1,2) then date&rdate.confprob='1';
 else date&rdate.confprob='0';

 *creating a flag that limits observations to community deaths in time period of interest;
 if DateSince&rdate='1' and communitydeath='1' then date&rdate.commdth='1';
 else date&rdate.commdth='0';

  *creating a flag that limits observations to community deaths with lab records in time period of interest;
 if date&rdate.labflag='1' and communitydeath='1'  then date&rdate.commdthlabflag='1';
 else date&rdate.commdthlabflag='0';

   *creating a flag that limits observations to community deaths who are confirmed cases in time period of interest;
 if date&rdate.labconfflag='1' and communitydeath='1'  then date&rdate.commdthconfcase='1';
 else date&rdate.commdthconfcase='0';

run;


proc freq data=new;
 tables DateSince&rdate.*datereport DateSince&rdate./list missing;  *checking to make sure that flag is correct;
 tables sampleinterpret1-sampleinterpret7;  *checking values in sampleinterpret fields;
 tables date&rdate.labflag*DateSince&rdate.*labresultsflag/list missing;
 tables date&rdate.labconfflag*DateSince&rdate.*labresultsflag*labresults/list missing;
 tables date&rdate.confprob*DateSince&rdate.*epicasedef/list missing; 
 tables date&rdate.commdth*DateSince&rdate.*communitydeath/list missing;
 tables labresults*sampleinterpret1*sampleinterpret2*sampleinterpret3*
		sampleinterpret4*sampleinterpret5*sampleinterpret6*sampleinterpret7/list missing;
 *format DateSince&rdate $d&rdate. casedate $weeks. ;
title3 'coding check';
 
run;

proc freq data=work.new;
 where DateSince&rdate.='1'; *restricts to those from &tdate. onward;
 tables datereport/list missing;
title3 "Overall and daily number of people each day entering the database since &tdate. ";

run;

proc freq data=work.new;
 where date&rdate.labflag='1'; *restricts to those from &tdate. onward who have at least 1 lab record;
 tables datereport/list missing;
title3 "Overall and daily number of people with lab results since &tdate. ";

run;

proc freq data=work.new;
where date&rdate.labconfflag='1'; *restricts to confirmed cases from &tdate. onward who have at least 1 lab record;
 tables datereport/list missing;
title3 "Overall and daily number of people with lab results who are confirmed cases since &tdate. ";

run;

proc freq data=work.new;
where date&rdate.confprob='1'; *restricts to those in database from &tdate. who are confirmed or probable cases;
 tables datereport/list missing;
title3 "Overall and daily number of people who are confirmed or probable cases since &tdate. ";

run;

proc freq data=work.new;
where date&rdate.confprob='1'; *restricts to those in database from &tdate. who are confirmed or probable cases;
 tables datereport*epicasedef/list missing;
title3 "Overall and daily number distribution of confirmed or probable cases since &tdate. ";

run;

proc freq data=work.new;
 where date&rdate.commdth='1'; *restricting to community deaths since &tdate.;
 tables datereport;
 title3 "Overall and daily number number of community deaths since &tdate. ";;

run;

proc freq data=work.new;
 where date&rdate.commdthlabflag='1'; *restricting to community deaths with lab records since &tdate.;
 tables datereport;
 title3 "Overall and daily number number of community deaths with lab record since &tdate. ";

run;


proc freq data=work.new;
 where date&rdate.commdthlabflag='1'; *restricting to community deaths with lab records since &tdate.;
 tables datereport;
 title3 "Overall and daily number number of community deaths with lab record since &tdate. ";

run;

proc freq data=work.new;
 where date&rdate.commdthconfcase='1'; *restricting to community deaths who are confirmed case since &tdate.;
 tables datereport;
 title3 "Overall and daily number number of community deaths who are confirmed case since &tdate. ";

run;


ods rtf close;
ods listing;

dm log "file saslog(&program_root.) replace";

run;

