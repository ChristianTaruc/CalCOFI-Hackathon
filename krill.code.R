#load libraries
install.packages("dplyr")
library(magrittr)
library(dplyr)
library(ggplot2)
library(shiny)
install.packages("leaflet")
library(leaflet)

#import my dataset
krill.data <- read.csv("krill_data1.csv")
#create a leaflet directory
dir.create("leaflet")
setwd("leaflet")
#create starter files
file.create("global.R")
file.create("server.R")
file.create("ui.R")
#starting with global.R
file.edit("global.R")
library(shiny)
library(leaflet)
krill.data <- read.csv("krill_data1.csv", header = TRUE, stringsAsFactors = FALSE)
#set up server.R
file.edit("server.R")
#set up ui.R
file.edit("ui.R")
#make sure leaflet is installed
if(!require("leaflet")){install.packages("leaflet", repos="http://cran.us.r-project.org")}
library(leaflet)
