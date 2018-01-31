library(ggplot2)
library(plotly)
library(shiny)
library(DT)


navbarPage("AA Seq Data",
           tabPanel("Volcano Plots",
                    fluidRow(
                      column(2,
                             selectInput("compChoose", label = "Choose Sample Comparison",
                                         choices = c("WT0h_KO0h", "WT0h_KO3h", "KO0h_KO6h", "WT0h_WT3h",
                                                     "WT3h_KO6h", "WT3h_KO_3h", "WT3h_WT6h", "WT6h_KO6h",
                                                     "KO3h_WT6h", "KO0h_WT3h", "WT0h_WT6h", "KO0h_KO3h",
                                                     "KO3h_KO6h", "WT0h_KO6h", "KO0h_WT6h"), 
                                         selected = "WT0h_KO0h"),                
                             numericInput("sigFC", label = "Choose FC Sig Cutoff", value = 1.5),
                             numericInput("sigQ", label = "Choose q-Value Sig Cutoff", value = 0.05)
                      ),
                      column(10,
                             plotlyOutput('volcanoOut', height = 600) 
                      )
                    )
           ),
           tabPanel("Differential Tables",
                    titlePanel("Differential Expression"),
                    fluidRow(
                      column(4,
                             selectInput("tabCompChoose", label = "Choose Sample Comparison",
                                         choices = c("WT0h_KO0h", "WT0h_KO3h", "KO0h_KO6h", "WT0h_WT3h",
                                                     "WT3h_KO6h", "WT3h_KO_3h", "WT3h_WT6h", "WT6h_KO6h",
                                                     "KO3h_WT6h", "KO0h_WT3h", "WT0h_WT6h", "KO0h_KO3h",
                                                     "KO3h_KO6h", "WT0h_KO6h", "KO0h_WT6h"), 
                                         selected = "WT0h_KO0h")),
                      column(4,
                             numericInput("FCcut", "Fold Change Cutoff",
                                          value = 1.5,
                                          min = 0)),
                      column(4,
                             numericInput("qCut", "q-Value Cutoff",
                                          value = 0.05,
                                          min = 0,
                                          max = 1))
                    ),
                    fluidRow(
                      DT::dataTableOutput("diffTable")
                    )
           ),
           tabPanel("Time Course Plot",
                    fluidRow(
                      column(2,
                             selectInput("TCseq", "Transcript", 
                                         choices = colnames(read.csv("./Data/gene_rep_mat.csv")),
                                         selected = "Il1b")),
                      column(10,
                             plotOutput('TCplot', height = 600))
                    ))
           
)