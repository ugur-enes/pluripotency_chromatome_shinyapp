library(shiny)
library(shinydashboard)


shinyUI <- dashboardPage(skin="black",
  dashboardHeader(titleWidth = 300, title = "Chromatome atlas"),
  
## Sidebar content  
  dashboardSidebar(width = 300,
                   sidebarMenu(
                     menuItem("Home", tabName = "home", icon = icon("home")),
                     menuItem("Chromatin map of ground state mESCs", tabName = "chromap", icon = icon("map")),
                     menuItem("Chromatome atlas of pluripotency", tabName = "atlaspluri", icon = icon("book")),
                     menuItem("Download", tabName = "download", icon = icon("arrow-down"))
                   )),
  
## Body content  
dashboardBody(
  tags$head( 
    tags$style(HTML(".body {background-color: white; 
                    } 
                      .main-sidebar { font-size: 15px; }
                      .box.box-solid.box-primary>.box-header {
                         color:#000000;
                         background:#66c2a5
                    }

                      .box.box-solid.box-primary{
                        border-bottom-color:#66c2a5;
                        border-left-color:#66c2a5;
                        border-right-color:#66c2a5;
                        border-top-color:#66c2a5;
                      }
                      .box.box-solid.box-success>.box-header {
                         color:#000000;
                         background:#fc8d62
                    }

                      .box.box-solid.box-success{
                        border-bottom-color:#fc8d62;
                        border-left-color:#fc8d62;
                        border-right-color:#fc8d62;
                        border-top-color:#fc8d62;
                      }
                      .box.box-solid.box-danger>.box-header {
                         color:#000000;
                         background:#ffd92f
                    }

                      .box.box-solid.box-danger{
                        border-bottom-color:#ffd92f;
                        border-left-color:#ffd92f;
                        border-right-color:#ffd92f;
                        border-top-color:#ffd92f;
                      }
                      .box.box-solid.box-warning>.box-header {
                         color:#000000;
                         background:#b3b3b3
                    }

                      .box.box-solid.box-warning{
                        border-bottom-color:#b3b3b3;
                        border-left-color:#b3b3b3;
                        border-right-color:#b3b3b3;
                        border-top-color:#b3b3b3;
                      }
                    .box.box-solid.box-info>.box-header {
                         color:#000000;
                         background:#cbd5e8
                    }

                      .box.box-solid.box-info{
                        border-bottom-color:#cbd5e8;
                        border-left-color:#cbd5e8;
                        border-right-color:#cbd5e8;
                        border-top-color:#cbd5e8;
                    }
                      "))
  ),
    tabItems(
      tabItem(tabName = "home",
              fluidRow(
               mainPanel(
                 withTags({div(class = "row", img(src="LMU_Logo.png", style = "width: 100%; max-width: 200px; margin-bottom: 10px; margin-left:30px", class = "col"),
                                              img(src="index.png", style = "width: 100%; max-width: 105px; margin-bottom: 10px; margin-left:5px", class = "col"),
                                              img(src="index2.jpg", style = "width: 100%; max-width: 103px; margin-bottom: 10px; margin-left:5px", class = "col"))}),
                 
                 tags$div(style ="margin-left:15px",
                          h1(strong("Comprehensive chromatin proteomics resolves functional phases of pluripotency")),
                          h3(em("Enes Ugur, Alexandra de la Porte, Weihua Qin, Sebastian Bultmann, Alina Ivanova, Micha Drukker, Matthias Mann*, Michael Wierer*, Heinrich Leonhardt*")),
                          h4("The establishment of cellular identity is driven by transcriptional and epigenetic regulation exerted by the components of the chromatin proteome, 
                  i.e., the chromatome. However, chromatome composition and its dynamics in functional phases of pluripotency have not been comprehensively analyzed 
                  thus limiting our understanding of these processes. To address this problem, we developed an accurate mass spectrometry (MS)-based proteomic method 
                  called Chromatin Aggregation Capture (ChAC) followed by Data-Independent Acquisition (DIA) to comprehensively analyze chromatome reorganizations 
                  during the transition from ground to formative and primed pluripotency states. This allowed us to generate a comprehensive atlas of proteomes, chromatomes, 
                  and chromatin affinities for the three pluripotency phases, revealing the specific binding and rearrangement of regulatory complexes. Our data support 
                  the model of coexisting phase-specific transcription factors that ultimately define cellular identity when a certain critical threshold is exceeded. 
                  Thus, taken together the technical advances, the comprehensive chromatome atlas, and the extensive analysis reported here provide a foundation 
                  for more in-depth understanding of mechanisms that govern phased progression of pluripotency."), style = "width: 100%; max-width: 700px; margin-bottom: 10px; margin-left:15px; text-align:justify"),

                 tags$div(class ="row", img(src="Graphical abstract_compact_revisions_final_web3.png", style = "width: 100%; max-width: 700px; margin-bottom: 10px; margin-left:30px")),
              shinydashboard::infoBox(
                title = "INFO",
                width = 6,
                icon = icon("info"), color ="black",
                value = "You can use the following pages to interactively explore the chromatomes of pluripotent stem cells. "
                )))
              ),
      tabItem(tabName ="chromap",
              fluidRow(
                shinydashboard::box(
                  width = 6,
                  title = "Info",
                  status = "primary", solidHeader = TRUE,
                  collapsible = TRUE,
                  ("To define high confidence chromatomes of ground state PSCs and thereby assess the specificity of chromatin enrichment 
                  by ChAC-DIA, we analyzed all fractions obtained during the chromatin purification in triplicates 
                  (i.e. cytoplasm, (full) proteome, nucleus, chromatin obtained by ChAC-DIA after 1-3 washes). 
                  Filtering the identified 8,500 proteins for significantly different enrichments across the fractions 
                  (ANOVA FDR < 0.05, fold change difference ≥ 1.5), resulted in 5,500 proteins. 
                  Unsupervised hierarchical cluster analysis of these proteins revealed nine distinct clusters (cluster annotation based on most enriched GO term). 
                  The following list comprises only the significantly changing proteins."),
                  tags$div(img(src="Fig2_cell fractionation.png", style = "width: 100%; max-width: 300px"))
                ),
                shinydashboard::box(
                  width = 5,
                  title = "Input",
                  status = "primary", solidHeader = TRUE,
                  selectizeInput('Proteins', 'Select protein(s)', choices = NULL, multiple = TRUE),
                  submitButton("Update View")
                )),
              fluidRow(
                shinydashboard::box(
                  width = 11,
                  title = "Profile Plot",
                  status = "danger", solidHeader = TRUE,
                  plotly::plotlyOutput("volume")
                )),
              fluidRow(
                shinydashboard::box(
                  width = 11,
                  title = "Table of Z-scores (row normalized)",
                  status = "warning", solidHeader = TRUE,
                  collapsible = TRUE,
                  collapsed = TRUE,
                  DT::dataTableOutput("view")
                ))
              ),
      tabItem(tabName ="atlaspluri",
              fluidRow(
                shinydashboard::box(
                  width = 6,
                  title = "Info",
                  status = "primary", solidHeader = TRUE,
                  collapsible = TRUE,
                  ("This dataset was generated by measuring the proteomes (P) and chromatomes (C) of ground, formative and primed state pluripotent stem cells in triplicates.
                    Datasets were quantified by DIA-NN v1.8 without a dedicated DDA-library. 
                   Proteins were filtered for at least two identifications for at least one pluripotency state. In addition, a Coefficient of Variation cut-off of >0.30 across all chromatome samples was applied.
                   Missing values were then imputed (width of 0.3 and a downshift of 1.8 standard deviations). The resulting list of 6,495 proteins was further normalized by the row means of Log2 intensities. 
                   ANOVA-testing was performed within the proteomes or chromatomes and with a 5% and 1% FDR (see table for information on significance).
                   Isoforms are indicated as such (isof.) and numbered (isof. 1-x) in case more than one isoform exists.")
                ),
                shinydashboard::box(
                  width = 5,
                  title = "Input",
                  status = "primary", solidHeader = TRUE,
                  selectizeInput('Proteins2', 'Select protein(s)', choices = NULL, multiple = TRUE),
                  submitButton("Update View")
                )),
              fluidRow(
                shinydashboard::box(
                  width = 11,
                  title = "Proteome",
                  status = "success", solidHeader = TRUE,
                  plotly::plotlyOutput("volume2", height = 600)
                )),
              fluidRow(
                shinydashboard::box(
                  width = 11,
                  title = "Chromatome",
                  status = "danger", solidHeader = TRUE,
                  plotly::plotlyOutput("volume3", height = 600)
                )),
              fluidRow(
                shinydashboard::box(
                  width = 11,
                  title = "Table of Fold changes (row normalized and Log2)",
                  status = "warning", solidHeader = TRUE,
                  collapsible = TRUE,
                  collapsed = TRUE,
                  DT::dataTableOutput("view2")
                ))
              ),
      tabItem(tabName = "download",
              fluidRow(
                shinydashboard::box(
                  width = 11,
                  title = "Download files",
                  status = "primary", solidHeader = TRUE,
                  downloadButton(outputId = "data_download_1", label = "Chromatome map of ground state mESCs", 
                                 style = "color: white; background-color: #e78ac3; border-color: black; font-size: 125%; padding: 12px;margin-bottom: 10px" ),
                  br(),
                  downloadButton(outputId = "data_download_2", label = "Chromatome atlas of pluripotency", 
                                 style = "color: white; background-color: #e78ac3; border-color: black; font-size: 125%; padding: 12px" )
                ))
      )
  )))
