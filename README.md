
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GCM_compareR_AWS_CMIP6_2023

<!-- badges: start -->
<!-- badges: end -->

The goal of GCM_compareR_AWS_CMIP6_2023 is to upate the GCMCompareR app
to inlcude functions and modules

## Documentation of functions and modules

### Functions

**circleFun.R:** Generate the circle in the variation among future tab
in order to estimate a 95% confidence interval of the ensemble model

### Modules

**GCMsSummaryTableModule.R:** this generates the tables in the tab
Summary table of GCMs within the scenario tab

**CMIPSelectionModule.R:** This generates the UI for selecting GCMs and
scenarios

**CountryMapModule.R:** This generates the UI for selecting a country
for the GCM Comparison

**BiomeMapModule.R:** This generates the UI for selecting a biome for
the GCM Comparison

**EcorregionMapModule.R:** This generates the UI for selecting an
ecorriegion for the GCM Comparison

**DrawMapModule.R:** This generates the UI for selecting an area by
drawing a square for the GCM Comparison

**MapModule.R:** A metamodule containing CountryMapModule,
BiomeMapModule, EcorregionMapModule and DrawMapModule
