*from covariance to correlation

	*toy data
	import delimited using "data/showmethemoney.csv", clear
	
	*canned command
	correlate income1 housesize, covariance
	
	*downside of covariance
	correlate income1 housesize, covariance
	correlate income2 housesize, covariance
	
	*correlation coefficient
	summarize
	display 20290.2 / (248.5637 * 88.1013)
	display 202.902 / (2.485637 * 88.1013)
	
	*canned command
	correlate income1 housesize 


	
	
*correlation analysis

	*homophily data
	use "data/homophily", clear

	*transform string variables to numeric ones
	destring *, replace ignore(",")
	
	*correlation coefficients
	correlate v10-v19
	
	*significance test of correlation analysis
	pwcorr v10-v19, sig
	pwcorr v10-v19, star(0.05)
	
	*scatterplot with a fitting line
	graph twoway (scatter v10 v15) (lfit v10 v15)
	pwcorr v10 v15, sig star(0.05)
	
	*once again after eliminating an outlier
	replace v15=. if v15>2000
	graph twoway (scatter v10 v15) (lfit v10 v15)
	pwcorr v10 v15, sig star(0.05)
	
	

	
	
	
	
	
	
	
	
*bivariate OLS

	*northern european lung cancer data
	use "data/lungcancer", clear
	
	*correlation
	pwcorr smoke cancer, sig star(0.01)
	graph twoway (scatter smoke cancer, jitter(5)) ///
				 (lfit smoke cancer, jitter(5))
	graph export "fig6.png", width(1000)
				 
	*regression
	regress cancer smoke
	
	*anova F
	di 7.32^2








*ols practice 1

	*fine dust dataset (2019)
	use "data/dfile_2706", clear
	ren *, lower
	
	*in favor of pro-environmental actions, short-term
	tab1 q6-q17
	revrs q6-q17
	gen action1=revq6+revq7+revq8+revq9+revq10+revq11+revq12+revq13+revq14+revq15+revq16+revq17
	hist action1, width(1)
	
	*in favor of pro-environmental actions, long-term
	tab1 q30-q35
	revrs q30-q35
	egen action2=rowtotal(revq30-revq35)
	hist action2, width(1)
	
	*correlation
	pwcorr action2 action1, sig star(0.01)
	graph twoway (scatter action2 action1, jitter(5)) ///
				 (lfit action2 action1, jitter(5))
				 				 
	*ols
	regress action2 action1
				 
				 
				 
				 
				 
*ols practice 2

	*homophily data
	use "data/homophily", clear
	destring *, replace ignore(",")
	
	*scatterplot with a fitting line
	graph twoway (scatter v19 v14) (lfit v19 v14)
	pwcorr v19 v14, sig star(0.05)
	
	*once again after eliminating an outlier
	tab v19
	replace v19=. if v19>2000
	graph twoway (scatter v19 v14) (lfit v19 v14)
	pwcorr v19 v14, sig star(0.05)
	
	*ols
	regress v19 v14
