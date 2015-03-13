/*
QC Checks
Reads in the daily extract Excel file and performs a number of checks for data management to review
Note: imports csv rather than Excel as stata8 doesn't support excel import
Initial version created 6/3/2015 brian.a.lee@gmail.com

Input:
Daily extract file called "Database_Extraction.csv" in the c:\data folder

Output:
"pour-examen.csv" file in the c:\data folder containing items for review by data management team

Rules checked:
#01-if epicasedef is non, probable or suspect (0,2,3) then there should be no confirmed labs
#02-if epicasedef is non, probable or suspect (0,2,3) then finallabclass should not be 1
#03-if epicasedef is confirmed (1), then there should be at least one confirmed lab specimin 
#04-if epicasedef is probable (2), then the patient should not be alive (finalstatus=2)
#05-if epicasedef is probable (2), then death location should not be blank or hospital (2)
#06-if finalstatus is alive (2), then deathdate should always be blank
#07-if finalstatus is alive (2), then placedeath should always be blank
#08-datehospitalcurrentadmit should never be beyond datedeath
#09-dateonset should never be beyond datedeath
#10-dateonset should never be beyond dateisolationcurrent
#11-dateonset should never be beyond datereport
#12-dateonset should never be beyond datesamplecollectedX
#13-dateonset should never be beyond datesampletestedX
#14-datesamplecollectedX should never be beyond datesampletestedX
#15-check for duplicates on surname, othernames, age, gender, districtres
#16-check for duplicates by id
#17-check for name mismatches between case and labs, bad for historical, good for daily
#18-check for missing scres for confirmed cases
*/

clear

set memory 40M

cd c:\data

*this gets created manually, also gets read in for rule 16 below
insheet using Database_Extraction.csv

*we don't care about excluded and maisson de transmission
drop if epicasedef==4 | epicasedef==5

/*
ok, so the dates in the CSV file use the format m/d/yyyy 0:00. They always have 0:00 appended. 
The time doesn't matter so I trim it off. dofc doesn't work in Stata8, so the only way I could think around this is to substring off the 0:00 and send it through date.
There is probably a better way of doing this.
*/

*format dates that are strings from csv as dates for comparison
generate datereport_calc = date(substr(datereport,1,length(datereport)-4),"mdy")
*generate datereport_calc = date(datereport, "dmy")
format datereport_calc %d
drop datereport
rename datereport_calc datereport

generate datedeath_calc = date(substr(datedeath,1,length(datedeath)-4),"mdy")
*generate datedeath_calc = date(datedeath, "dmy")
format datedeath_calc %d
drop datedeath
rename datedeath_calc datedeath

generate dateonset_calc = date(substr(dateonset,1,length(dateonset)-4),"mdy")
*generate dateonset_calc = date(dateonset, "dmy")
format dateonset_calc %d
drop dateonset
rename dateonset_calc dateonset

generate datehospitalcurrentadmit_calc = date(substr(datehospitalcurrentadmit,1,length(datehospitalcurrentadmit)-4),"mdy")
*generate datehospitalcurrentadmit_calc = date(datehospitalcurrentadmit, "dmy")
format datehospitalcurrentadmit_calc %d
drop datehospitalcurrentadmit
rename datehospitalcurrentadmit_calc datehospitalcurrentadmit

generate dateisolationcurrent_calc = date(substr(dateisolationcurrent,1,length(dateisolationcurrent)-4),"mdy")
*generate dateisolationcurrent_calc = date(dateisolationcurrent, "dmy")
format dateisolationcurrent_calc %d
drop dateisolationcurrent
rename dateisolationcurrent_calc dateisolationcurrent

generate datesamplecollected1_calc = date(substr(datesamplecollected1,1,length(datesamplecollected1)-4),"mdy")
*generate datesamplecollected1_calc = date(datesamplecollected1, "dmy")
format datesamplecollected1_calc %d
drop datesamplecollected1
rename datesamplecollected1_calc datesamplecollected1

generate datesampletested1_calc = date(substr(datesampletested1,1,length(datesampletested1)-4),"mdy")
*generate datesampletested1_calc = date(datesampletested1, "dmy")
format datesampletested1_calc %d
drop datesampletested1
rename datesampletested1_calc datesampletested1

generate datesamplecollected2_calc = date(substr(datesamplecollected2,1,length(datesamplecollected2)-4),"mdy")
*generate datesamplecollected2_calc = date(datesamplecollected2, "dmy")
format datesamplecollected2_calc %d
drop datesamplecollected2
rename datesamplecollected2_calc datesamplecollected2

generate datesampletested2_calc = date(substr(datesampletested2,1,length(datesampletested2)-4),"mdy")
*generate datesampletested2_calc = date(datesampletested2, "dmy")
format datesampletested2_calc %d
drop datesampletested2
rename datesampletested2_calc datesampletested2

generate datesamplecollected3_calc = date(substr(datesamplecollected3,1,length(datesamplecollected3)-4),"mdy")
*generate datesamplecollected3_calc = date(datesamplecollected3, "dmy")
format datesamplecollected3_calc %d
drop datesamplecollected3
rename datesamplecollected3_calc datesamplecollected3

generate datesampletested3_calc = date(substr(datesampletested3,1,length(datesampletested3)-4),"mdy")
*generate datesampletested3_calc = date(datesampletested3, "dmy")
format datesampletested3_calc %d
drop datesampletested3
rename datesampletested3_calc datesampletested3

generate datesamplecollected4_calc = date(substr(datesamplecollected4,1,length(datesamplecollected4)-4),"mdy")
*generate datesamplecollected4_calc = date(datesamplecollected4, "dmy")
format datesamplecollected4_calc %d
drop datesamplecollected4
rename datesamplecollected4_calc datesamplecollected4

generate datesampletested4_calc = date(substr(datesampletested4,1,length(datesampletested4)-4),"mdy")
*generate datesampletested4_calc = date(datesampletested4, "dmy")
format datesampletested4_calc %d
drop datesampletested4
rename datesampletested4_calc datesampletested4

generate datesamplecollected5_calc = date(substr(datesamplecollected5,1,length(datesamplecollected5)-4),"mdy")
*generate datesamplecollected5_calc = date(datesamplecollected5, "dmy")
format datesamplecollected5_calc %d
drop datesamplecollected5
rename datesamplecollected5_calc datesamplecollected5

generate datesampletested5_calc = date(substr(datesampletested5,1,length(datesampletested5)-4),"mdy")
*generate datesampletested5_calc = date(datesampletested5, "dmy")
format datesampletested5_calc %d
drop datesampletested5
rename datesampletested5_calc datesampletested5

generate datesamplecollected6_calc = date(substr(datesamplecollected6,1,length(datesamplecollected6)-4),"mdy")
*generate datesamplecollected6_calc = date(datesamplecollected6, "dmy")
format datesamplecollected6_calc %d
drop datesamplecollected6
rename datesamplecollected6_calc datesamplecollected6

generate datesampletested6_calc = date(substr(datesampletested6,1,length(datesampletested6)-4),"mdy")
*generate datesampletested6_calc = date(datesampletested6, "dmy")
format datesampletested6_calc %d
drop datesampletested6
rename datesampletested6_calc datesampletested6

generate datesamplecollected7_calc = date(substr(datesamplecollected7,1,length(datesamplecollected7)-4),"mdy")
*generate datesamplecollected7_calc = date(datesamplecollected7, "dmy")
format datesamplecollected7_calc %d
drop datesamplecollected7
rename datesamplecollected7_calc datesamplecollected7

generate datesampletested7_calc = date(substr(datesampletested7,1,length(datesampletested7)-4),"mdy")
*generate datesampletested7_calc = date(datesampletested7, "dmy")
format datesampletested7_calc %d
drop datesampletested7
rename datesampletested7_calc datesampletested7

*names are entered in different cases, make a lower version to compare for duplicates
generate surname_low = lower(surname)
generate othernames_low = lower(othernames)

*save off a prepped data set for use by each rule
save daily.dta, replace


*rule #01 - Should be confirmed case if a lab sample has result of 1
keep if epicasedef==0|epicasedef==2|epicasedef==3
keep if sampleinterpret1==1|sampleinterpret2==1|sampleinterpret3==1|sampleinterpret4==1|sampleinterpret5==1|sampleinterpret6==1|sampleinterpret7==1
generate regle="#01: Au moins d'un specimin Lab positif, mais epicasedef in 0,2,3"
save temp-qc.dta, replace

*rule #02 - Should be confirmed case if finallabclass is 1
use daily.dta, clear
keep if epicasedef==0|epicasedef==2|epicasedef==3
keep if finallabclass==1
generate regle="#02: FinalLabClass est 1, mais epicasedef in 0,2,3"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #03 - Should not be confirmed case if no confirmed labs
use daily.dta, clear
keep if epicasedef==1
keep if sampleinterpret1!=1&sampleinterpret2!=1&sampleinterpret3!=1&sampleinterpret4!=1&sampleinterpret5!=1&sampleinterpret6!=1&sampleinterpret7!=1
generate regle="#03: Cas confirme, mais rein de specimin positif"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #04 - Should not be probable with final status alive
use daily.dta, clear
keep if epicasedef==2
keep if finalstatus==0
generate regle="#04: Cas probable, mais personne est vivant"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #05 - Should not be probable with a death location not in the community
use daily.dta, clear
keep if epicasedef==2
keep if placedeath!=1
generate regle="#05: Cas probable, mais location de dece ce n'est pas community"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #06 - Should not be alive with a death date
use daily.dta, clear
keep if finalstatus==2
keep if !missing(datedeath)
generate regle="#06: Personne est vivant, mais date de deces n'est pas vide"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #07 - Should not be alive with a death place
use daily.dta, clear
keep if finalstatus==2
keep if !missing(placedeath)
generate regle="#07: Personne est vivant, mais place de deces n'est pas vide"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #08 - DateHospitalCurrentAdmit should not be beyond DateDeath
use daily.dta, clear
keep if !missing(datehospitalcurrentadmit)
keep if !missing(datedeath)
keep if datehospitalcurrentadmit > datedeath
generate regle="#08: Date d'admis a l'hopital est plus que date de deces"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #09 - DateOnset should not be beyond DateDeath
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset > datedeath
generate regle="#09: Date de debut des signes est plus que date de deces"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #10-datesonet should never be beyond dateisolationcurrent
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset > dateisolationcurrent
generate regle="#10: Date de debut des signes est plus que date l'isolement"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #11-datesonet should never be beyond datereport
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset > datereport
generate regle="#11: Date de debut des signes est plus que date de la report"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #12-datesonet should never be beyond sample collected dates
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset > datesamplecollected1|dateonset > datesamplecollected2|dateonset > datesamplecollected3|dateonset > datesamplecollected4|dateonset > datesamplecollected5|dateonset > datesamplecollected6|dateonset > datesamplecollected7
generate regle="#12: Date de debut des signes est plus que date de la lab specimin collectées"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #13-datesonet should never be beyond sample tested dates
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset > datesampletested1|dateonset > datesampletested2|dateonset > datesampletested3|dateonset > datesampletested4|dateonset > datesampletested5|dateonset > datesampletested6|dateonset > datesampletested7
generate regle="#13: Date de debut des signes est plus que date de la lab specimin testé"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #14-datesamplecollected should never be beyond datesampletested
use daily.dta, clear
keep if !missing(datesamplecollected1)
keep if datesamplecollected1 > datesampletested1
generate regle="#14: Date de specimin collectée est plus que date de la lab specimin testé"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #15- check for duplicates by surname, othernames, age, gender, district
use daily.dta, clear
duplicates tag surname_low othernames_low age gender districtres, generate(tag)
keep if tag>0
sort districtres surname othernames age gender
generate regle="#15: Les duplicates exist dans le db pour surname, othernames, age, gender, districtres."
append using temp-qc.dta
save temp-qc.dta, replace

*rule #16- check for duplicates by ID
*this is a little different because for this one, I do care about excludes and chains of transmissions
insheet using Database_Extraction.csv, clear
duplicates tag id, generate(tag)
keep if tag>0
sort id
generate regle="#16: Les duplicates exist dans le db pour ID."
generate datereport_calc = date(substr(datereport,1,length(datereport)-4),"mdy")
format datereport_calc %d
drop datereport
rename datereport_calc datereport
append using temp-qc.dta
save temp-qc.dta, replace

*rule #17- check for name/lab name mismatches
use daily.dta, clear
keep if !missing(surname)
keep if !missing(othernames)
keep if !missing(othernamelab1)
keep if !missing(surnamelab1)
keep if surname!=surnamelab1&surname!=othernamelab1
*|surname!=surnamelab2&surname!=othernamelab2|surname!=surnamelab3&surname!=othernamelab3|surname!=surnamelab4&surname!=othernamelab4|surname!=surnamelab5&surname!=othernamelab5|surname!=surnamelab6&surname!=othernamelab6|surname!=surnamelab7&surname!=othernamelab7
generate regle="#17: Le nom n'est pas le meme de les noms des labs."
append using temp-qc.dta
save temp-qc.dta, replace

*rule #18- check for SCres missing if cas confirme
use daily.dta, clear
keep if epicasedef==1
keep if missing(scres)
generate regle="#18: Cas confirme, mais rien de SCRes."
append using temp-qc.dta
save temp-qc.dta, replace





*only keep useful fields for qc
keep id datereport epicasedef surname othernames age gender districtres placedeath finallabclass sampleinterpret1 sampleinterpret2 sampleinterpret3 sampleinterpret4 sampleinterpret5 sampleinterpret6 sampleinterpret7 regle

*put rule first
order regle id datereport epicasedef surname othernames age gender districtres placedeath finallabclass sampleinterpret1 sampleinterpret2 sampleinterpret3 sampleinterpret4 sampleinterpret5 sampleinterpret6 sampleinterpret7
sort regle

outsheet using pour-examen.csv , comma replace

