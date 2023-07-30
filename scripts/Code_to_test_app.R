# Code use to test the app is loading rasters correctly
input <- list()
rvs <- list()

input$res_sel <- "10m"
rvs$def_available_gcms <- c("ACCESS.CM2", "ACCESS.ESM1.5", "AWI.CM.1.1.MR", "CanESM5.CanOE","CanESM5",
                            "CMCC.ESM2", "CNRM.CM6.1.HR", "CNRM.CM6.1", "CNRM.ESM2.1","EC.Earth3.Veg.LR",
                            "EC.Earth3.Veg", "FIO.ESM.2.0", "GISS.E2.1.G", "GISS.E2.1.H","HadGEM3.GC31.LL",
                            "INM.CM4.8", "INM.CM5.0", "IPSL.CM6A.LR", "MIROC.ES2L","MIROC6",
                            "MPI.ESM1.2.HR", "MPI.ESM1.2.LR", "MRI.ESM2.0", "UKESM1.0.LL")
input$scenario_type <- "ssp245"
input$year_type <- "2081.2100"