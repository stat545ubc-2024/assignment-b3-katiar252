## STAT 545 UBC (Winter 2024, Term 1)
## Assignment B3: Gapminder App
Author: Katia Rosenflanz 

Date: November 18, 2024

### **Overview**
This repository contains a Shiny App (Gapminder_App) for the STAT 545 course at UBC. 
The app is deployed online at shinyapps.io and can be accessed using the following link: 
https://stat545-katiar.shinyapps.io/Gapminder_App/ 

### Functionality
The app has several features which users can interact with:
1. Users select a continent of interest and subsequently specific countries within that continent (up to 10)
2. Life expectancy at birth over time is plotted for each selected country
3. The user can download their generated plot as a .png file
4. A separate tab (Gapminder Data Table) show an interactive data table for the filtered dataset (only contains selected countries)

### File Contents 
This repository contains:
-   **README.md** 
-   **app.R** This is the folder containing the app.R file necessary for the Gapminder App.


### How to Access
The easiest way to interact with the app is on the shinyapps.io server. 
In order to investigate the code, first clone the repository to your device and open the file after cloning it to your device. Make sure to install any necessary packages. The required packages are: 
-   gapminder
-   shiny
-   tidyverse
