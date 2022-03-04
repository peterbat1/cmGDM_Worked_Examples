# EcoCommons Community Modelling Project
#
# Extract data from example data provided by the R-package gdm, and reformat it
# for use in the cmGDM workflow
#
# Peter D. Wilson
# Adjunct Fellow
# Dept. of Biological Sciences
# Faculty of Science and Engineering
# Macquarie University, Sydney, Australia
#
# 2022-01-31: Version 1 developed to extract data from an older version of the gdm package.
#
# 2022-02-18: Version 2, being a much revised script to do the same as version 1
# but using the latest version of the gdm package which uses a different method
# for storing example data within the package.
#
##############################################################################
# NOTE: To run this script you should change the path for saving output files.
##############################################################################

library(gdm)
library(vegan)

# What are the data tables called in the new gdm package?
print(readRDS("/home/peterw/R/x86_64-pc-linux-gnu-library/4.1/gdm/data/Rdata.rds"))

# The next line generates a 'promise' which is essentially a data meta statement
# which will be used to load the data objects when each appears to the RHS of an
# assignment
data(gdmDissim)

dissimMat <- gdmDissim
rawEnvTab <- southwest

# Make an environmental data table
envTab <- rawEnvTab[2:(ncol(rawEnvTab) - 2)]
duplInd <- which(duplicated(envTab[, "site"]))
envTab <- envTab[-duplInd, ]
envTab$site <- paste0("site_", envTab$site)
write.csv(envTab, "/home/peterw/Nyctimene/EcoCommons/R-scripts/protoype_dev/Examples/gdm_pkg_example_data/gdm_pkg_env_table.csv", row.names = FALSE)

# Make a climate-only version of environmental data
envTab_climate <- envTab[, grep("site|^bio", colnames(envTab))]
write.csv(envTab_climate, "/home/peterw/Nyctimene/EcoCommons/R-scripts/protoype_dev/Examples/gdm_pkg_example_data/gdm_pkg_env_table_climate.csv", row.names = FALSE)

# Make a site table
siteTable <- rawEnvTab[, c(2, ncol(rawEnvTab) - 1, ncol(rawEnvTab))]
siteTable <- siteTable[-duplInd, ]
siteTable$site <- paste0("site_", siteTable$site)
write.csv(siteTable, "/home/peterw/Nyctimene/EcoCommons/R-scripts/protoype_dev/Examples/gdm_pkg_example_data/gdm_pkg_site_table.csv", row.names = FALSE)

# Make a pres-abs table and compute Bray_Curtis dissim matrix
sppTab <- rawEnvTab[, c(1, 2)]
sppTab$site <- paste0("site_", sppTab$site)
paTab <- as.data.frame.matrix(table(sppTab$site, sppTab$species))
paTab[paTab > 1] <- 1
#rownames(paTab) <- paste0("site_", rownames(paTab))
write.csv(data.frame(site = rownames(paTab), paTab), "/home/peterw/Nyctimene/EcoCommons/R-scripts/protoype_dev/Examples/gdm_pkg_example_data/gdm_pkg_PA_table.csv", row.names = FALSE)

dissimMat <- as.matrix(vegdist(paTab, "bray", binary = TRUE))
write.csv(dissimMat, "/home/peterw/Nyctimene/EcoCommons/R-scripts/protoype_dev/Examples/gdm_pkg_example_data/gdm_pkg_dissim_mat.csv")


