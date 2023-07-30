library(tidyverse)
# library(plotly)
library(raster)

files <- list.files("clim_data/worldclimCMIP6", full.names = T)
bioclims <- c(paste0("bio", 1:19))[c(1, 12)]

# List to store results
overall_comparison <- list()

## Present
sce <- files[1]

# Read rasters
pre_r <- sce %>% 
  purrr::map(~list.files(.x, pattern = ".tif", full.names = T)) %>% 
  purrr::map(~stack(.x))

# Rename bioclim variables
pre_r <- pre_r %>%
  purrr::map(~setNames(.x, names(.x) %>% gsub(".*bio","bio",.)))

# Name the list by GCM name
pre_r <- pre_r %>%
  magrittr::set_names("Baseline")

# Average value in the baseline
# Subset one bioclim variable
for (bio in bioclims){
  glue::glue("      Bioclim {bio}") %>% print
  # Select one bioclim
  pre_bio_r <- pre_r %>%
    purrr::map(~ raster::subset(.x, subset = bio))
  
  ## for debbuging
  # sce_year_bio_r <- sce_year_bio_r %>%
  #     purrr::map(~ raster::crop(.x, raster::extent(-80, -70, -5, 5)))
  
  # Calculate values
  pre_mean <- pre_bio_r %>% 
    map_dfr(values) %>%
    summarise_all(list(mean), na.rm = T)
  pre_bio_result <- pre_mean %>% 
    t %>% as.data.frame %>% tibble::rownames_to_column() %>% 
    set_names(c("GCM", "mean")) %>% 
    mutate(scenario = "Baseline",
           period = "2000",
           bioclim = bio)
  
  # Store on the list
  overall_comparison[[length(overall_comparison) + 1]] <- pre_bio_result
  names(overall_comparison)[[length(overall_comparison)]] <- paste0("Baseline_", bio)
}


## FUTURE SCENARIOS
scenarios <- c("ssp126", "ssp245", "ssp370", "ssp585")[1]
periods <- c("2021.2040", "2041.2060", "2061.2080", "2081.2100")

## Loop on scenarios
for (sce in scenarios){
  glue::glue("Scenario {sce}") %>% print
  # Subset one scenario
  sce_files <- files %>% 
    str_subset(sce)
  
  # Subset one period
  for (per in periods){
    glue::glue("   Period {per}") %>% print
    sce_year_files <- sce_files %>% 
      str_subset(per)
    
    # Read rasters
    sce_year_r <- sce_year_files %>% 
      purrr::map(~list.files(.x, pattern = ".tif", full.names = T)) %>% 
      purrr::map(~stack(.x))
    
    # Rename bioclim variables
    sce_year_r <- sce_year_r %>%
      purrr::map(~setNames(.x, names(.x) %>% gsub(".*\\.bio","",.) %>% paste0("bio",.)))
    
    # Name the list by GCM name
    sce_year_r <- sce_year_r %>%
      magrittr::set_names(sce_year_files %>% 
                            gsub(".*_bioc_", "",.) %>% gsub("_ssp.*", "", .))
    
    # Subset one bioclim variable
    for (bio in bioclims){
      glue::glue("      Bioclim {bio}") %>% print
      # Select one bioclim
      sce_year_bio_r <- sce_year_r %>%
        purrr::map(~ raster::subset(.x, subset = bio))
      
      # Calculate ensemble
      ## for debbuging
      # sce_year_bio_r <- sce_year_bio_r %>%
      #     purrr::map(~ raster::crop(.x, raster::extent(-80, -70, -5, 5)))
      sce_year_bio_ens <- sce_year_bio_r %>% 
        purrr::reduce(`+`) %>%                                       # Sum all layers
        raster::calc(fun = function(x){x / length(sce_year_bio_r)})   # Divide by the total number
      ## Combine ensemble and GCMs
      sce_year_bio_all <- sce_year_bio_r
      sce_year_bio_all[[length(sce_year_bio_all) + 1]] <- sce_year_bio_ens
      names(sce_year_bio_all)[length(sce_year_bio_all)] <- "Ensemble"
      
      # Calculate values
      sce_year_bio_mean <- sce_year_bio_all %>% 
        map_dfr(values) %>%
        summarise_all(list(mean), na.rm = T)
      sce_year_bio_result <- sce_year_bio_mean %>% 
        t %>% as.data.frame %>% tibble::rownames_to_column() %>% 
        set_names(c("GCM", "mean")) %>% 
        mutate(scenario = sce,
               period = per,
               bioclim = bio)
      
      # Store on the list
      overall_comparison[[length(overall_comparison) + 1]] <- sce_year_bio_result
      names(overall_comparison)[[length(overall_comparison)]] <- paste0(sce, "_", per, "_", bio)
    }
  }
}

# Save backup at this point
# saveRDS(overall_comparison, "overall_comparison/list_overall_comparison_CMIP6.rds")


# Condense the list into a table
overall_comparison2 <- overall_comparison %>% 
  map_dfr(bind_rows)

borrar <- overall_comparison2 %>% 
  filter(scenario %in% c("Baseline", "ssp126")) %>% 
  mutate(year = case_when(period == "2000" ~ 2000,
                          period == "2021.2040" ~ 2030,
                          period == "2041.2060" ~ 2050,
                          period == "2061.2080" ~ 2070,
                          period == "2081.2100" ~ 2090)) %>% 
  pivot_wider(names_from = bioclim, values_from = mean)
borrar %>% 
  filter(GCM != "Baseline" & year == 2030) %>% 
  mutate(scenario = "Baseline", period = 2000, year = 2000, 
         bio1 = ,
         bio12 = )

borrar <- borrar %>% filter(GCM != "Baseline" & year == 2030) %>% select(GCM) %>% 
  bind_cols(borrar %>% slice(1) %>% 
              select(-GCM) %>% 
              slice(rep(1:n(), each = 10))) %>% 
  bind_rows(borrar %>% slice(-1))

  
plot_ly(borrar, x = ~year, y = ~bio1, z = ~bio12,
          color = I("black")) %>%
  add_lines(borrar %>% filter(GCM != "Ensemble")) %>% 
  add_lines(borrar %>% filter(GCM == "Ensemble"),
            color = I("red")) 





## Plot 1 variable
sce_year_bio_result %>% 
  # mutate(GCM = factor(GCM, levels = c("Ensemble", setd)))
  mutate(GCM = fct_relevel(GCM, "Ensemble")) %>% 
  ggplot() +
  geom_point(aes(x = GCM, y = mean))


