# ToClean

`rvs$xaxis_lab` has the same values as `rvs$ycol_sc_lab`

in line 1155 where we can see

```r
                   ##############################  Unscaled  ##############################
                   rvs$clim_vars_uns <- rvs$clim_vars
                   rvs$clim_vars_uns[[length(rvs$clim_vars_uns) + 1]] <- rvs$clim_baseline
```

seems to be duplicated except for the baseline


This in line 940 could be uptated using terra::tapp
```r
                 glue::glue("#>>  Dividing temperature layers in CMIP5 by 10 to get units in ºC")
                 
```
