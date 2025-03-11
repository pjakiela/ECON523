
// SAMPLE CODE FOR AN EVENT STUDY GRAPH

gen label = _n in 1/40
replace label = label - 21
gen beta = .
gen lower = .
gen upper = .

reg complete minus_20 minus_19 minus_18 minus_17 minus_16 minus_15 ///
	minus_14 minus_13 minus_12 minus_11 minus_10 ///
	minus_9 minus_8 minus_7 minus_6 minus_5 minus_4 minus_3 minus_2  ///
	plus_0 plus_1 plus_2 plus_3 plus_4 plus_5 plus_6 plus_7 plus_8 plus_9 ///
	plus_10 plus_11 plus_12 plus_13 plus_14 plus_15 plus_16 plus_17 plus_18 plus_19 ///
	plus_20 plus_21 plus_22 plus_23 plus_24 plus_25 i.id i.year, cluster(country)
	
mat V = r(table)
forvalues i = 1/19 {
	replace beta = V[1,`i'] in `i'
	replace lower = V[5,`i'] in `i'
	replace upper = V[6,`i'] in `i'
}

replace beta = 0 in 20 // the year prior to FPE implementation; everything is relative to this year

forvalues i = 21/40 {
	local j = `i'-1
	replace beta = V[1,`j'] in `i'
	replace lower = V[5,`j'] in `i'
	replace upper = V[6,`j'] in `i'
}

tw ///
	(rspike upper lower label, color(cranberry) lwidth(thin)) ///
	(scatter beta label, msymbol(o) mcolor(cranberry)), ///
	legend(off) xlabel(-20(5)20) ///
	xtitle(" " "Relative Time:  Years Before/After Implementation of Free Primary") ///
	ylabel(-20(10)40) ytitle("Impact on Primary School Completion" " " ) ///
	yline(0, lwidth(thin) lcolor(gs8)) ///
	title("All Countries")
	
graph export my-event-study-graph-name.pdf, replace

