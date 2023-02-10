library(png)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(cowplot)
library(plotly)
library(ggplot2)
library(data.table)
library(heatmaply)
library(shinyHeatmaply)
library(rsconnect)

#library(ComplexHeatmap)
#library(InteractiveComplexHeatmap)
#library(bslib) #themes
#library(shinythemes) #themes
#library(DataExplorer)

#read tables
fractionations <- read.table("fractionation_data_significantf2.txt", header = T, sep = "\t", quote = "", dec = ".")
Proteins <- fractionations$Proteins

pluripotency <- read.table("chromatome_proteome_all_states.txt", header = T, sep = "\t", quote = "", dec = ".")
Proteins2 <- pluripotency$Proteins


shinyServer(function(input, output, session) {
  
  ##function for fractionations 
  updateSelectizeInput(session, 'Proteins', choices = Proteins, server = TRUE)
  datasetInput <- reactive({
    fractionations %>% 
      dplyr::filter(Proteins %in% input$Proteins) %>% arrange(desc(Cluster))
  })
  output$volume <- plotly::renderPlotly({
   ##validate required to prevent error due to lacking input in the beginning
     validate(
      need(input$Proteins, "Please select a protein")
    )
    dataset <- datasetInput()
    df <- data.frame(a_Cytosol = rowMeans(dataset[1:3],na.rm = T),
                     b_Proteome = rowMeans(dataset[4:6],na.rm = T),
                     c_Nucleus = rowMeans(dataset[7:9],na.rm = T),
                     Chromatin_1 = rowMeans(dataset[10:12],na.rm = T),
                     Chromatin_2 = rowMeans(dataset[13:15],na.rm = T),
                     Chromatin_3 = rowMeans(dataset[16:18],na.rm = T),
                     Proteins = dataset$Proteins,
                     Protein.Group = dataset$Protein.Group,
                     Cluster = dataset$Cluster)
    ##ggplot plots in alphabetic order; how to circumvent in combination with gather & %>% ???
    #df$sample <- factor(c("Cytosol", "Proteome", "Nucleus", "Chromatome"), levels = c("Cytosol", "Proteome", "Nucleus", "Chromatome"))
    df %>% 
      tidyr::gather(key = "sample", value = "Z.score", -Proteins, -Protein.Group, -Cluster) %>% 
      ggplot(aes(sample, Z.score, color= Proteins, group= Protein.Group))+geom_path(aes(color=Proteins), size=1.5)+geom_point(size=2.3)+#geompoint(aes(fill=Gene), shape = 21,size = 3,color = "black"))
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+xlab("Fraction")+
      scale_colour_brewer(palette = "Dark2")
  })
  output$view <- DT::renderDataTable({
    dataset <- datasetInput()
    df <- data.frame(Cytosol = rowMeans(dataset[1:3],na.rm = T),
                     Proteome = rowMeans(dataset[4:6],na.rm = T),
                     Nucleus = rowMeans(dataset[7:9],na.rm = T),
                     Chromatin_1 = rowMeans(dataset[10:12],na.rm = T),
                     Chromatin_2 = rowMeans(dataset[13:15],na.rm = T),
                     Chromatin_3 = rowMeans(dataset[16:18],na.rm = T),
                     Proteins = dataset$Proteins,
                     Protein.Group = dataset$Protein.Group,
                     Cluster = dataset$Cluster)
    df})
  ##function for pluripotency
  updateSelectizeInput(session, 'Proteins2', choices = Proteins2, server = TRUE)  
  datasetInput2 <- reactive({
    pluripotency %>% 
      dplyr::filter(Proteins %in% input$Proteins2) %>% arrange(desc(Protein_Group %in% input$Proteins2))
  })

  output$view2 <- DT::renderDataTable({
    dataset2 <- datasetInput2()
    df2 <- data.frame(P_n_1 = dataset2[,1],
                      P_n_2 = dataset2[,2],
                      P_n_3 = dataset2[,3],
                      P_f_1 = dataset2[,4],
                      P_f_2 = dataset2[,5],
                      P_f_3 = dataset2[,6],
                      P_p_1 = dataset2[,7],
                      P_p_2 = dataset2[,8],
                      P_p_3 = dataset2[,9],
                      C_n_1 = dataset2[,10],
                      C_n_2 = dataset2[,11],
                      C_n_3 = dataset2[,12],
                      C_f_1 = dataset2[,13],
                      C_f_2 = dataset2[,14],
                      C_f_3 = dataset2[,15],
                      C_p_1 = dataset2[,16],
                      C_p_2 = dataset2[,17],
                      C_p_3 = dataset2[,18],
                     Proteins = dataset2$Proteins,
                     P_FDR_0.05 = dataset2$FP_FDR005,
                     P_FDR_0.01 = dataset2$FP_FDR001,
                     C_FDR_0.05 = dataset2$Ch_FDR005,
                     C_FDR_0.01 = dataset2$Ch_FDR001,
                     Protein_Group = dataset2$Protein_Group)
    df2
  })
    
    output$volume2 <- plotly::renderPlotly({
      validate(
        need(input$Proteins2, "Please select a protein")
      )
      dataset2 <- datasetInput2()
      df2 <- data.frame(naive_1 = dataset2[,1],
                        naive_2 = dataset2[,2],
                        naive_3 = dataset2[,3],
                        formative_1 = dataset2[,4],
                        formative_2 = dataset2[,5],
                        formative_3 = dataset2[,6],
                        primed_1 = dataset2[,7],
                        primed_2 = dataset2[,8],
                        primed_3 = dataset2[,9],
                        Proteins = dataset2$Proteins,
                        Protein_Group = dataset2$Protein_Group)
      row.names(df2) <- df2[,10] ## double row names not allowed
      df2_2 <- select(df2, c(1:9))  
      df2_matrix <- data.matrix(df2_2)
           heatmaply(df2_matrix, showticklabels=TRUE, Rowv=TRUE, Colv=NULL,
                  scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(low = "#2166ac", mid = "#f7f7f7", high = "#b2182b", midpoint = 0, limits = NULL),
                  grid_gap = 1, xlab ="Pluripotency phase (proteome)", hclustfun = hclust, dendogram = c("both"), show_dendogram =c(TRUE,FALSE))
     ##due to a bug in plotly, heatmaply ignores any na.value input which is why mid is set to a yellowish color and na is white
      ## to change dendogram line size you have to define the dendogram outside of heatmaply and then indicate it in Rowv=...
            })
    
    output$volume3 <- plotly::renderPlotly({
      validate(
        need(input$Proteins2, "Please select a protein")
      )
      dataset2 <- datasetInput2()
      df2 <- data.frame(naive_1 = dataset2[,10],
                       naive_2 = dataset2[,11],
                       naive_3 = dataset2[,12],
                       formative_1 = dataset2[,13],
                       formative_2 = dataset2[,14],
                       formative_3 = dataset2[,15],
                       primed_1 = dataset2[,16],
                       primed_2 = dataset2[,17],
                       primed_3 = dataset2[,18],
                       Proteins = dataset2$Proteins,
                       Protein_Group = dataset2$Protein_Group)
      
      
      row.names(df2) <- df2[,10] ## double row names not allowed
      df2_2 <- select(df2, c(1:9))  
      df2_matrix <- data.matrix(df2_2)
      heatmaply(df2_matrix, showticklabels=TRUE, Rowv=TRUE, Colv=NULL,
                scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(low = "#2166ac", mid = "#f7f7f7", high = "#b2182b", midpoint = 0, limits = NULL),
                grid_gap = 1, xlab ="Pluripotency phase (chromatome)", hclustfun = hclust, dendogram = c("both"), show_dendogram =c(TRUE,FALSE))
      ##due to a bug in plotly, heatmaply ignores any na.value input which is why mid is set to a yellowish color and na is white
      ## to change dendogram line size you have to define the dendogram outside of heatmaply and then indicate it in Rowv=...
    })
    
    output$data_download_1 <- downloadHandler(
      filename = function() { paste("fractionation_data_",Sys.Date(),".txt") },
      content = function(file) { write.table(fractionations, file, dec = ".", sep = "\t", row.names = FALSE, col.names = TRUE) }
    )
    
    output$data_download_2 <- downloadHandler(
      filename = function() { paste("pluripotency_atlas",Sys.Date(),".txt") },
      content = function(file) { write.table(pluripotency, file, dec = ".", sep = "\t", row.names = FALSE, col.names = TRUE) }
    )
    
   
    
})