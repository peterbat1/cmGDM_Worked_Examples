# EcoCommons Community Modelling Project
#
# Worked example using data from the example data set supplied with teh gdm
# R-package. Data were extracted and reformatted to fit the assumptions about
# data sources and formats used to design the workflow embedded in the R-package
# cmGDM.
#
# The R-script written to extract and re-format the data is found in the same
# folder as this script. Look for the file gdm_pkg_example_data_extraction.R
#
######################### IMPORTANT CAVEAT ##################################
# This worked example is set up to run in a standard, desktop R environment.
# It illustrates the use of the workflow embodied in the R-package cmGDM. When
# implemented as a module within EcoCommons, it is expected that calls to
# functions within cmGDM at each step in the workflow will be made by the
# web-based graphical user interface, and that environmental covariate data
# layers will be as supplied by an EcoCommons interface to ALA or other
# standardised environmental data. That means, for example, that loading
# environmental covariate data in Step 4 below will be handled through an
# EcoCommons module. Obviously, in this desktop based worked example, we must
# manually provided important details like covariate file names to be loaded.
############################################################################
#
# Peter D. Wilson
# Adjunct Fellow
# Dept. of Biological Sciences
# Faculty of Science and Engineering
# Macquarie University, Sydney, Australia
#
# 2022-01-31; 2022-02-18 
#
############################################################################
# 
# Requirements to run this example:
# ---------------------------------
#
# You must have a R version 4.1 or higher installed, and also have installed the
# R-packages cmGDM and stringr into you local R environment.
#
# In addition to the software requirements, you also need to have downloaded
# to a local folder the example data files.
#
# YOU WILL NEED TO CHANGE PATHS TO FILES TO SUIT YOUR LOCAL SYSTEM
#
# Running this example:
# ---------------------

# It is best to use an IDE such R-Studio to load this script. You will have the
# option to easily edit the script (e.g. changing values passed to
# cm_create_experiment() to suit your situation), and to run selected steps or
# the entire script.
#
# You can also load this script into a simple TEXT editor, and copy and paste
# selected lines into the R console.
#
############################################################################

library(cmGDM)

# Step 1: Create experiment object
myExperiment <- cmGDM::cm_create_new_experiment(userID = "ID123",
                                                userName = "Peter D. Wilson",
                                                experimentName = "Example GDM fit gdm pkg data Climate Only",
                                                description = "Fit GDM using cmGDM applied to example data from the gdm package CLIMATE ONLY")

# Step 2: Load site details: You will need to change the path to the site data
# file to suit your situation
myExperiment <- cmGDM::cm_load_site_table(myExperiment,
                                          siteFilename = "/home/peterw/Data_and_Projects/EcoCommons/community-modelling-workflow/Workflow_examples/Worked_example_gdm_pkg_data/gdm_pkg_site_table.csv",
                                          siteCol = "site",
                                          longitudeCol = "Long",
                                          latitudeCol = "Lat")

# Step 3: Load biological data: A Presence-absence coded matrix. As before this file must be
# downloaded to a local location and this path must be passed in the parameter
# 'bioFilename'

myExperiment <- cmGDM::cm_load_community_data(thisExperiment = myExperiment,
                                              bioFilename = "/home/peterw/Data_and_Projects/EcoCommons/community-modelling-workflow/Workflow_examples/Worked_example_gdm_pkg_data/gdm_pkg_PA_table.csv",
                                              dataType = "Presence_absence",
                                              siteCol = "site",
                                              dissimMeasure = "Bray-Curtis")

# Step 4: Load environmental covariate data: As before you should download a
# local copy of this file and edit the value passed in "src_folder" to reference
# this location on your computer.
#
# NOTE: For this worked example, we will load the enviromental data as a set of
# GIS raster layers. This will allow use to produce a raster map showing similar
# predicted community composition using scores from a PCA of transformed
# environmental covariates.
myExperiment <- cmGDM::cm_load_covar_data(myExperiment,
                                          src_folder = "/home/peterw/Data_and_Projects/EcoCommons/community-modelling-workflow/Workflow_examples/env_data/westOZ",
                                          covar_filenames = c("westOZ_bio5.tif",
                                                              "westOZ_bio6.tif",
                                                              "westOZ_bio15.tif",
                                                              "westOZ_bio18.tif",
                                                              "westOZ_bio19.tif"))

# Step 5: Fit a GDM: This is the default fitting of a GDM. It performs a basic
# model fit, and does not generate variable importance information AND does not
# include geographical distance as a covariate. Generating variable importance
# information is a very computationally expensive process. If you wish to
# perform this step, you can re-run the experiment by setting the parameter
# calc_varImp = TRUE in the call to cm_run_experiment() as shown in the
# alternate form of Step 5 below. In this call, geographic distance is used as a
# covariate, which makes the output generated by this example the same as the
# example shown in the vignette for the gdm package.
myExperiment <- cm_run_gdm_experiment(myExperiment, includeGeo = TRUE)

# ALTERNATE Step 5: Run experiment with optional calculation of variable
# importance information. NOTE: Running this code will OVERWRITE the previous
# results stored in the object 'thisExperiment'. If you wish to keep these
# alternate runs completely separate, you should set up a new experiment.
myExperiment <- cm_run_gdm_experiment(myExperiment, includeGeo = TRUE, calc_varImp = TRUE)


############################################################################
# The following steps are optional. They provide a range of summary information
# and plots for a completed experiment.

# Show summary: This allows you to see a summary of useful performance data on
# the screen and optionally saved to a text file so you can use the information
# in other documents. The default is a screen-dump only. To save to a file, give
# a value to the parameter 'outFile'. e.g. cm_gdm_experiment(myExperiment,
# outFile = "/follow/this/path/to/Experiment_4_summary.txt")
cm_gdm_summary(myExperiment)

# Make some nice pictures...namely, a set of informative plots which are
# provided in the basic gdm R-package. Here, however, they are plotted using the
# graphical tools in the ggplot2 R-package. Note that this function places these
# image files in the default experiment folder where you can view them or added
# them to documents.
cm_performance_plots(myExperiment)

# The basic gdm package includes a function to produce a map (in image form)
# showing grid cells which are predicted to have similar composition on the
# basis of the combination of environmental covariates in each cell. Grid cells
# with similar predicted composition have similar colours. THe function in the
# cmGDM package reproduces this image output but provides it in two forms; (1) a
# PNG image which can be used in documents, reports, etc as a any other image.
# However, cmGDM also adds an ancillary "World coordinates" file which allows
# you to directly import the image as a GIS layer into R (packages raster and
# terra, for example) or GIS programs such as QGIS or ArcGIS. This allows you to
# produce multi-layered GIS outputs. (2) A geoTIFF file which is a stand-alone,
# industry standard GIS file format. Again, this can be used in R or GIS
# programs to produce multi-layered maps, and shared with others. NOTE: Files
# are saved to the default experiment folder.
cm_gdm_pcaPlot(myExperiment)

# The cmGDM package includes a report template which can be used to generate a
# PDF report of the experiment. Two templates are in fact available to cater for
# experiments which include variable importance information and those without.
# The function cm_gdm_report() automagically determines which template to use
# based on information present in the experiment object. For your convenience,
# this function will generate the performance plots if they are not found in the
# default experiment folder. NOTE: The PDF is saved to the default experiment
# folder.
cm_gdm_report(myExperiment)
