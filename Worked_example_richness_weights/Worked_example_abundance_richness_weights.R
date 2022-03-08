
# cmGDM devlopment: Test a simple wirkflow for abundance (count) data and richness weights for sites

library(cmGDM)

testExp <- cmGDM::cm_create_new_experiment(userID = "myself123",
                                           userName = "Joe Blow",
                                           experimentName = "Richness weights", 
                                           description = "Test workflow with richness weights")

testExp <- cmGDM::cm_load_site_table(thisExperiment = testExp,
                                     siteFilename = "/home/peterw/Data_and_Projects/Contract projects/EcoCommons/R-scripts/cmGDM_Worked_Examples/Worked_example_richness_weights/siteData.csv",
                                     siteCol = 1,
                                     longitudeCol = 2,
                                     latitudeCol = 3,
                                     weightType = "richness")

testExp <- cmGDM::cm_load_community_data(thisExperiment = testExp,
                                         bioFilename = "/home/peterw/Data_and_Projects/Contract projects/EcoCommons/R-scripts/cmGDM_Worked_Examples/Worked_example_richness_weights/abundance_matrix.csv",
                                         siteCol = 1,
                                         dataType = "Abundance",
                                         dissimMeasure = "Bray-Curtis")

testExp <- cmGDM::cm_load_covar_data(thisExperiment = testExp,
                                     src_folder = "/home/peterw/Data_and_Projects/Contract projects/EcoCommons/R-scripts/cmGDM_Worked_Examples/env_data/eastOZ",
                                     covar_filenames = list.files("/home/peterw/Data_and_Projects/Contract projects/EcoCommons/R-scripts/cmGDM_Worked_Examples/env_data/eastOZ", "*.tif"))

testExp <- cmGDM::cm_run_gdm_experiment(thisExperiment = testExp,
                                        includeGeo = TRUE)

cmGDM::cm_gdm_summary(testExp)

cmGDM::cm_performance_plots(thisExperiment = testExp)
