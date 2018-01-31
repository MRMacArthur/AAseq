library(ggplot2)
library(plotly)
library(shiny)
library(DT)

gene.diff <- read.csv("./Data/gene_diff.csv")
gene.diff$sig2 <- 0

gene.rep.mat <- read.csv("./Data/gene_rep_mat.csv")

function(input, output, session) {
  
  output$volcanoOut <- renderPlotly({
    
    gene.diff[gene.diff$q_value < input$sigQ & abs(gene.diff$log2_fold_change) > input$sigFC,]$sig2 <- 1
    gene.diff$sig2 <- factor(gene.diff$sig2)
    
    p <- ggplot(data = gene.diff[gene.diff$compared == input$compChoose & -log10(gene.diff$q_value) != 0,], 
                aes(x = log2_fold_change, y = -log10(q_value), 
                    color = sig2,
                    text = paste("Gene:", gene_short_name))) +
      geom_point(alpha = (1/4)) +
      labs(x = "Log2 Fold Change", y = "-log10 q Value") +
      guides(color = guide_legend(title = "Significant"))
    
    p <- ggplotly(p)
    
    print(p)
    
  })
  
  
  output$diffTable <- DT::renderDataTable(DT::datatable({
    
    if (input$tabCompChoose != "All") {
      gene.diff <- gene.diff[gene.diff$compared == input$tabCompChoose,]
    }
    
    sigVec <- ifelse((abs(gene.diff$log2_fold_change) > input$FCcut) & 
                       (gene.diff$q_value < input$qCut), T, F)
    
    cbind(gene.diff, sigVec)
    
  }))
  
  output$TCplot <- renderPlot({
    
    q <- ggplot(data = gene.rep.mat, aes_string(x = "Time", y = input$TCseq, color = "Treatment")) +
      geom_point() +
      stat_smooth(method = 'lm', formula = y ~ poly(x, 2), size = 1, alpha = 0.1)
    
    print(q)
    
  })
  
  
}



