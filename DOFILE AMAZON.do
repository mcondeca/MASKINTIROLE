*EXTENDED ESSAY*
*Standar Cleaning*

cd 
clear all
set more off
cap log close

*IMPORT THE DOCUMENT*

import excel "/Users/mariadanielacondecajas/Desktop/EXTENDED ESSAY/EXCEL/time series amazon prices .xlsx", sheet("Hoja1") firstrow



describe
rename *, lower
reshape long price, i(category) j(month) string
rename numberofratings nr
rename amazonschoice amac

* Label variables (shows up in graphs)
lab var month "Month"


* Parse dates
gen date = date(month, "DM20Y") 
format date %td 



* Set panel data
encode category, gen(category_code) 
xtset category_code date 



* Save data
gen amazonc = amac== "YES"
gen bests = bestseller== "YES"
egen st_p = std(price)
lab var amazonc "Binary Amazon Choice"
lab var bests "Binary Best Seller"

save amazonprices, replace



/* Data Check */
* --------------------------- *
* Visualizing the Data *
* --------------------------- *

* ------------------------- *
* Summary Statistics *
* ------------------------- *

tab category, sum(price)
tab amazonc, sum(price)
tab bests, sum(price)
tab date, sum(price)

* --------------------------- *
* Graphs  *
* --------------------------- *


set graphics off

levelsof nameshorter, local(name_vals) 
foreach v of local name_vals {
    preserve
        qui keep if nameshorter == "`v'"

        gr tw (tsline price, yaxis(1)) , title("Price: `v'")
        gr export name_`v'.pdf, replace

  
  
    restore

}




levelsof nameshorter, local(shorter_vals) 
foreach v of local shorter_vals {
    preserve
        qui keep if nameshorter == "`v'"

        gr tw (tsline price, yaxis(1)) , title("Price- `v'")
        gr export ts_`v'.pdf, replace

      restore
 
}


graph bar st_p, over(amazonc) title("Products that are Amazon Choice: Standar Desviation") ytitle("Mean of Standar Desviation")
graph export sd_amazonc.pdf, replace 

graph bar st_p, over(bests) title("Products that are Best Sellers: Standar Desviation") ytitle("Mean of Standar Desviation")
graph export sd_bests.pdf, replace 


graph bar st_p, over(stars) title("Products Rated among Stars: Standar Desviation") ytitle("Mean of Standar Desviation")
graph export sd_stars.pdf, replace 


scatter amazonc st_p, ylabel(0 1, valuelabel angle(h)) ytitle("Amazon Choice Standar Desviation")
graph export sca_bests.pdf, replace 


scatter bests st_p, ylabel(0 1, valuelabel angle(h)) ytitle("Best Selles Standar Desviation")
graph export sca_stars.pdf, replace 




graph hbar, over(categories, label(labsize(small)) relabel(`r(relabel)')) ytitle("Percent of Respondents", size(small)) title("In general, how satisfied are you with your job?"), span size(medium)) blabel(bar, format(%4.1f))

graph hbar, over(categories) title("Products in Each Category") blabel(bar, format(%4.1f))
graph export categories.pdf, replace 



egen seq1 = fill(1 2 3 4 5 6 7 8 9 10 1 2 3 4 5 6 7 8 9 10) 
gen seq2 = mod(_n-1,10) + 1 

label define type_lab  "Beauty & Personal Care" 2 "Baby Products" 3 "Clothing, Shoes & Jewelry" 4 "Electronics" 5 "CDs & Vinyl" 6 "Health & Household" 7 "Home & Kitchen" 8 "Tools & Home Improvement" 9 "Toys & Games" 10 "Books"

gen seq3 = seq1
label value seq3 type_lab

decode seq3, gen(seq4)


li seq* in 1/12, sep(10)
sum seq*
drop seq*

rename categories choice
sort choice
by choice: gen mode1 = _n
lab val mode1 type_lab





*GRAPHICS (EXTENDED ESSAY)


use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"

levelsof nameshorter, local(shorte_vals) 
foreach v of local shorte_vals {
    preserve
        qui keep if nameshorter == "`v'"

        gr tw (tsline price, yaxis(1)) , title("`v'")
		graph export "/Users/mariadanielacondecajas/Desktop/graphs amazon/graph `v'.pdf", as(pdf) name("Graph") replace
       
    restore
}

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Electronics")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)), title("Electronics")
graph save "Graph" "/Users/mariadanielacondecajas/Desktop/Graph1.gph", replace
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Baby Products")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)) (tsline price if (prod_name==7), yaxis(1)) (tsline price if (prod_name==8), yaxis(1)) (tsline price if (prod_name==9), yaxis(1)) (tsline price if (prod_name==10), yaxis(1)) (tsline price if (prod_name==11), yaxis(1)) (tsline price if (prod_name==12), yaxis(1)) (tsline price if (prod_name==13), yaxis(1)) (tsline price if (prod_name==14), yaxis(1))(tsline price if (prod_name==15), yaxis(1)), title("Baby Products")
graph save "Graph2" "/Users/mariadanielacondecajas/Desktop/Graph2.gph", replace
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Beauty & Personal Care")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)) (tsline price if (prod_name==7), yaxis(1)) (tsline price if (prod_name==8), yaxis(1)) (tsline price if (prod_name==9), yaxis(1)) (tsline price if (prod_name==10), yaxis(1)) (tsline price if (prod_name==11), yaxis(1)) (tsline price if (prod_name==12), yaxis(1)) (tsline price if (prod_name==13), yaxis(1)) (tsline price if (prod_name==14), yaxis(1))(tsline price if (prod_name==15), yaxis(1)) (tsline price if (prod_name==16), yaxis(1)) (tsline price if (prod_name==17), yaxis(1)) (tsline price if (prod_name==18), yaxis(1)) (tsline price if (prod_name==19), yaxis(1)) (tsline price if (prod_name==20), yaxis(1)) (tsline price if (prod_name==21), yaxis(1)) (tsline price if (prod_name==22), yaxis(1)) (tsline price if (prod_name==23), yaxis(1)) (tsline price if (prod_name==24), yaxis(1)) (tsline price if (prod_name==25), yaxis(1)) (tsline price if (prod_name==26), yaxis(1)) (tsline price if (prod_name==27), yaxis(1)) (tsline price if (prod_name==28), yaxis(1)) (tsline price if (prod_name==29), yaxis(1))(tsline price if (prod_name==30), yaxis(1)) (tsline price if (prod_name==31), yaxis(1)) (tsline price if (prod_name==32), yaxis(1)) (tsline price if (prod_name==33), yaxis(1)) (tsline price if (prod_name==34), yaxis(1)) (tsline price if (prod_name==35), yaxis(1)) (tsline price if (prod_name==36), yaxis(1)) (tsline price if (prod_name==37), yaxis(1)) (tsline price if (prod_name==38), yaxis(1)) (tsline price if (prod_name==39), yaxis(1)) , title(" Beauty & Personal Care")
graph save "Graph" "/Users/mariadanielacondecajas/Desktop/Graph3.gph"
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Books")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)), title("Books")
graph save "Graph" "/Users/mariadanielacondecajas/Desktop/Graph4.gph"
restore


use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="CDs & Vinyl")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)), title("CDs & Vinyl")
graph save "Graph" "/Users/mariadanielacondecajas/Desktop/Graph5.gph"
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices.dta"
preserve
keep if (categories=="Clothing  ")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)) (tsline price if (prod_name==7), yaxis(1)) (tsline price if (prod_name==8), yaxis(1)), title("Clothing  ")
graph save "Graph6" "/Users/mariadanielacondecajas/Desktop/Graph6.gph", replace
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Health & Household")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)), title("Health & Household")
graph save "Graph6" "/Users/mariadanielacondecajas/Desktop/Graph7.gph", replace
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Home & Kitchen")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)) (tsline price if (prod_name==7), yaxis(1)) (tsline price if (prod_name==8), yaxis(1)) (tsline price if (prod_name==9), yaxis(1)) (tsline price if (prod_name==10), yaxis(1)) (tsline price if (prod_name==11), yaxis(1)) (tsline price if (prod_name==12), yaxis(1)) (tsline price if (prod_name==13), yaxis(1)) (tsline price if (prod_name==14), yaxis(1)) (tsline price if (prod_name==15), yaxis(1)) (tsline price if (prod_name==16), yaxis(1)) (tsline price if (prod_name==17), yaxis(1)) (tsline price if (prod_name==18), yaxis(1)) (tsline price if (prod_name==19), yaxis(1))(tsline price if (prod_name==20), yaxis(1)), title("Home & Kitchen")
graph save "Graph8" "/Users/mariadanielacondecajas/Desktop/Graph8.gph", replace
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Toys & Games")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)), title("Toys & Games")
graph save "Graph9" "/Users/mariadanielacondecajas/Desktop/Graph9.gph", replace
restore

use "/Users/mariadanielacondecajas/Desktop/amazonprices0.dta"
preserve
keep if (categories=="Tools & Home Improvement")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==3), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)), title("Tools & Home Improvement")
graph save "Graph10" "/Users/mariadanielacondecajas/Desktop/Graph10.gph", replace
restore



*GRAPHICS PRESENTED FINAL- ONLY WITH CUT OF 25% ON PRICES"

preserve
keep if (categories=="Beauty & Personal Care")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==4), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)) (tsline price if (prod_name==7), yaxis(1))  (tsline price if (prod_name==10), yaxis(1)) (tsline price if (prod_name==12), yaxis(1)) (tsline price if (prod_name==13), yaxis(1)) (tsline price if (prod_name==14), yaxis(1))(tsline price if (prod_name==15), yaxis(1)) (tsline price if (prod_name==19), yaxis(1)) (tsline price if (prod_name==23), yaxis(1))(tsline price if (prod_name==29), yaxis(1)) (tsline price if (prod_name==31), yaxis(1)) (tsline price if (prod_name==39), yaxis(1)) , title(" Beauty & Personal Care")
graph save "Graph" "/Users/mariadanielacondecajas/Desktop/Graph3.gph"
restore


preserve
keep if (categories=="Tools & Home Improvement")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==1), yaxis(1)) (tsline price if (prod_name==2), yaxis(1)) (tsline price if (prod_name==5), yaxis(1)), title("Tools & Home Improvement")
graph save "Graph10" "/Users/mariadanielacondecajas/Desktop/Graph10.gph", replace
restore


preserve
keep if (categories=="Baby Products")
encode(nameshorter), generate(prod_name)
xtset prod_name date
gr tw (tsline price if (prod_name==5), yaxis(1)) (tsline price if (prod_name==6), yaxis(1)) (tsline price if (prod_name==11)), title("Baby Products")
graph save "Graph2" "/Users/mariadanielacondecajas/Desktop/Graph2.gph", replace
restore


