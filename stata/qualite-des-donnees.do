/*
QC Checks
Reads in the daily extract Excel file and performs a number of checks for data management to review
Note: imports csv rather than Excel as stata8 doesn't support excel import

Rules:
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
#notrun-datereport should never be beyond datesamplecollectedX
#notrun-datereport should never be beyond datesampletestedX
#14-datesamplecollectedX should never be beyond datesampletestedX
#15-check for duplicates on surname, othernames, age, gender, districtres
#16-check for duplicates by id
#17-check for name mismatches between case and labs, bad for historical, good for daily
#18-check for missing scres for confirmed cases


*/

clear

cd c:\data

*this gets created manually, also gets read in for rule 16 below
insheet using Database_Extraction_2015_03_06.csv

*we don't care about excluded and maisson de transmission
drop if epicasedef==4 | epicasedef==5

*format dates that are strings from csv as dates for comparison
generate datereport_calc = date(datereport, "mdy")
generate datedeath_calc = date(datedeath, "mdy")
generate dateonset_calc = date(dateonset, "mdy")
generate datehospitalcurrentadmit_calc = date(datehospitalcurrentadmit, "mdy")
generate dateisolationcurrent_calc = date(dateisolationcurrent, "mdy")
generate datesamplecollected1_calc = date(datesamplecollected1, "mdy")
generate datesampletested1_calc = date(datesampletested1, "mdy")
generate datesamplecollected2_calc = date(datesamplecollected2, "mdy")
generate datesampletested2_calc = date(datesampletested2, "mdy")
generate datesamplecollected3_calc = date(datesamplecollected3, "mdy")
generate datesampletested3_calc = date(datesampletested3, "mdy")
generate datesamplecollected4_calc = date(datesamplecollected4, "mdy")
generate datesampletested4_calc = date(datesampletested4, "mdy")
generate datesamplecollected5_calc = date(datesamplecollected5, "mdy")
generate datesampletested5_calc = date(datesampletested5, "mdy")
generate datesamplecollected6_calc = date(datesamplecollected6, "mdy")
generate datesampletested6_calc = date(datesampletested6, "mdy")
generate datesamplecollected7_calc = date(datesamplecollected7, "mdy")
generate datesampletested7_calc = date(datesampletested7, "mdy")

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
keep if datehospitalcurrentadmit_calc > datedeath_calc
generate regle="#08: Date d'admis a l'hopital est plus que date de deces"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #09 - DateOnset should not be beyond DateDeath
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datedeath_calc
generate regle="#09: Date de debut des signes est plus que date de deces"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #10-datesonet should never be beyond dateisolationcurrent
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > dateisolationcurrent_calc
generate regle="#10: Date de debut des signes est plus que date l'isolement"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #11-datesonet should never be beyond datereport
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datereport_calc
generate regle="#11: Date de debut des signes est plus que date de la report"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #12-datesonet should never be beyond sample collected dates
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datesamplecollected1_calc|dateonset_calc > datesamplecollected2_calc|dateonset_calc > datesamplecollected3_calc|dateonset_calc > datesamplecollected4_calc|dateonset_calc > datesamplecollected5_calc|dateonset_calc > datesamplecollected6_calc|dateonset_calc > datesamplecollected7_calc
generate regle="#12: Date de debut des signes est plus que date de la lab specimin collectées"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #13-datesonet should never be beyond sample tested dates
use daily.dta, clear
keep if !missing(dateonset)
keep if dateonset_calc > datesampletested1_calc|dateonset_calc > datesampletested2_calc|dateonset_calc > datesampletested3_calc|dateonset_calc > datesampletested4_calc|dateonset_calc > datesampletested5_calc|dateonset_calc > datesampletested6_calc|dateonset_calc > datesampletested7_calc
generate regle="#13: Date de debut des signes est plus que date de la lab specimin testé"
append using temp-qc.dta
save temp-qc.dta, replace

/*rule #-datereport should never be beyond sample collected dates, don't run this until confirm with OMS
use daily.dta, clear
keep if !missing(datereport)
keep if datereport_calc > datesamplecollected1_calc|datereport_calc > datesamplecollected2_calc|datereport_calc > datesamplecollected3_calc|datereport_calc > datesamplecollected4_calc|datereport_calc > datesamplecollected5_calc|datereport_calc > datesamplecollected6_calc|datereport_calc > datesamplecollected7_calc
generate regle="#14: Date de la report est plus que date de la lab specimin collectées"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #-datereport should never be beyond sample tested dates, don't run this until confirm with OMS
use daily.dta, clear
keep if !missing(datereport)
keep if datereport_calc > datesampletested1_calc|datereport_calc > datesampletested2_calc|datereport_calc > datesampletested3_calc|datereport_calc > datesampletested4_calc|datereport_calc > datesampletested5_calc|datereport_calc > datesampletested6_calc|datereport_calc > datesampletested7_calc
generate regle="#15: Date de la report est plus que date de la lab specimin testé"
append using temp-qc.dta
save temp-qc.dta, replace
*/ 

*rule #14-datesamplecollected should never be beyond datesampletested
use daily.dta, clear
keep if !missing(datesamplecollected1)
keep if datesamplecollected1_calc > datesampletested1_calc
generate regle="#14: Date de specimin collectée est plus que date de la lab specimin testé"
append using temp-qc.dta
save temp-qc.dta, replace

*rule #15- check for duplicates by surname, othernames, age, gender, district
use daily.dta, clear
duplicates tag surname_low othernames_low age gender districtres, generate(tag)
keep if tag>0
generate regle="#15: Les duplicates exist dans le db pour surname, othernames, age, gender, districtres."
append using temp-qc.dta
save temp-qc.dta, replace

*rule #16- check for duplicates by ID
*this is a little different because for this one, I do care about excludes and chains of transmissions
insheet using Database_Extraction_2015_03_06-smalled.csv, clear
duplicates tag id, generate(tag)
keep if tag>0
generate regle="#16: Les duplicates exist dans le db pour ID."
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

*rule #18- check for scres missing if cas confirme
use daily.dta, clear
keep if epicasedef==1
keep if missing(scres)
generate regle="#18: Cas confirme, mais rien de SCRes."
append using temp-qc.dta
save temp-qc.dta, replace







*only keep useful fields for qc
keep id epicasedef surname othernames age gender districtres placedeath finallabclass sampleinterpret1 sampleinterpret2 sampleinterpret3 sampleinterpret4 sampleinterpret5 sampleinterpret6 sampleinterpret7 regle

*put rule first
order regle id epicasedef surname othernames age gender districtres placedeath finallabclass sampleinterpret1 sampleinterpret2 sampleinterpret3 sampleinterpret4 sampleinterpret5 sampleinterpret6 sampleinterpret7
sort regle

outsheet using pour-examen.csv , comma replace

