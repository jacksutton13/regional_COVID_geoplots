# regional_COVID_geoplots
Summary: 
The intention of this code is to produce up-to-date geomaps of England and Wales that show the number of days since the most recent
case (England and Wales) and death (England only).

How to use this code (step by step instructions): 
1) download UK_regions.xlsx, UK_regions_wales_removed.xlsx, geomaps_cases.R, geomaps_death.R, importing_shapefiles.R and all the shapefiles in the folder "ShapeFiles".
2) open importing_shapefiles_LTLA.R in R. Follow the steps in the comments within this file.
3) open geomaps_cases.R in R. Follow the steps in the comments within this file. This will produce geomaps of cases in England and Wales.
4) open geomaps_death.R in R. Follow the steps in the comments within this file. This will produce geomaps of deaths in England (excluding wales).


Important Information: 
Death in Wales and England are incomparable as stated on the Public Health England website via their COVID-19 dashboard (https://coronavirus.data.gov.uk/).
This is the reason why Wales is removed from any death analysis (geomaps). Also be cautious observing data in the last 5 days from today as there
are some aligning issues.





