# ToClean

`rvs$xaxis_lab` has the same values as `rvs$ycol_sc_lab`

`rvs$clim_vars` or climate_scenarios in cmip6 is duplicated to generate

in line 1155 where we can see

```r
                   ##############################  Unscaled  ##############################
                   rvs$clim_vars_uns <- rvs$clim_vars
                   rvs$clim_vars_uns[[length(rvs$clim_vars_uns) + 1]] <- rvs$clim_baseline
```

seems to be duplicated except for the baseline
