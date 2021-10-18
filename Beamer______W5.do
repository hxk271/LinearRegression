*one-sample t test

	use "data/social", clear
	summarize socialself
	
	*canned command
	ttest socialself==29.9
	
	
	
	
*t test for independent samples

	use "data/social_independent", clear
	bysort wave: summarize socialself
	
	*canned command
	ttest socialself, by(wave)
	
	
	


*t test for paired samples

	use "data/social_paired", clear
	summarize socialself1 socialself2
	
	*canned command
	ttest socialself1==socialself2
	
	
	
	
*additional issues of t-tests

	*without the assumption of equal variance
	use "data/social_independent", clear
	ttest socialself, by(wave) unequal

	*unpair the paired samples
	use "data/social_paired", clear
	ttest socialself1==socialself2, unpaired
	

	
	


*proportion comparison

	*Bacterial pneumonia episodes data from CRT (Hayes and Moulton 2009)
	webuse pneumoniacrt, clear
	summarize pneumonia
	
    *one-sample test of proportions
	prtest pneumonia==.2
	
	*independent sample test of proportions
	prtest pneumonia, by(vaccine)

	*normal approximation to the binomial
	ttest pneumonia==.2
	ttest pneumonia, by(vaccine)
	
	
	
	
*one-sample test of variance

	use "data/social", clear
	summarize socialself
	
	*canned command
	sdtest socialself==5.1

	
	
	
*independent sample test of variance

	use "data/social_independent", clear
	bysort wave: summarize socialself
	
	*canned command
	sdtest socialself, by(wave)
	
	
	


*two paired sample test of variance

	/* we do not discuss it */
	
	


	
	
*one-way analysis-of-variance 

	*1980 Census data by state
	webuse census3, clear
	keep brate region
	sort region

	*birth rate by regions
	oneway brate region, tabulate

	*replicate with anova command
	anova brate region
	
	*replicate with regression command
	reg brate i.region
	
	
	
	
		
*t test versus one-way ANOVA

	*sqrt(f)=t
	webuse auto, clear
	ttest price, by(foreign)
	return list
	display abs(r(t))
	oneway price foreign
	return list
	display sqrt(r(F))
	
	*probability of making at least an error in 10-time t tests
	display 1-binomial(10,0, 0.05)









