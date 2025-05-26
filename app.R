library(shiny)
library(dplyr)
library(shinythemes)
library(bslib)
library(shinyWidgets)
library(waiter)
library(fontawesome)

# Load data lokal
benchmark_df <- read.csv("C:/Users/Marsel/Semester 2/ESG_Metree_Analysis/Benchmark_Cyclical_file.csv")
perusahaan_df <- read.csv("C:/Users/Marsel/Semester 2/ESG_Metree_Analysis/Perusahaan_Cyclical_file.csv")
if (!"Sektor" %in% colnames(perusahaan_df)) {
  perusahaan_df$Sektor <- "Cyclical"
}

# Custom Theme
theme_custom <- bs_theme(
  version = 4,
  bootswatch = "minty",
  primary = "#2cb67d",
  base_font = font_google("Inter"),
  heading_font = font_google("Poppins")
)

# UI
ui <- navbarPage(
  id = "navbar",
  title = "Metree ESG Analyzer",
  theme = theme_custom,
  
  tabPanel("Beranda",
           fluidPage(
             useWaiter(),
             tags$head(
               tags$style(HTML("
                 .welcome-page {
                   padding-top: 80px;
                   text-align: center;
                   background: linear-gradient(to right, #e6f4f1, #c2e9e2);
                   height: 100vh;
                 }
                 .welcome-title {
                   font-size: 48px;
                   font-weight: bold;
                   color: #0d4b43;
                   margin-bottom: 20px;
                   text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
                 }
                 .welcome-subtitle {
                   font-size: 22px;
                   color: #134e4a;
                   margin-bottom: 40px;
                 }
                 .start-button {
                   font-size: 20px;
                   padding: 10px 30px;
                   border-radius: 10px;
                 }
               "))
             ),
             div(class = "welcome-page",
                 icon("leaf", class = "fa-3x"),
                 div("Selamat Datang di", class = "welcome-subtitle"),
                 div("Metree ESG Analyzer", class = "welcome-title"),
                 div("Analisis ESG Cerdas untuk Investor Masa Depan.", class = "welcome-subtitle"),
                 br(),
                 actionBttn("go_manual", "🚀 Masuk Manual Input", style = "gradient", color = "success", size = "lg", class = "start-button"),
                 br(),
                 actionBttn("go_lanjutan", "📂 Masuk Analisis Cerdas", style = "stretch", color = "warning", size = "lg", class = "start-button"),
                 br(),
                 actionBttn("go_auto", "📊 Data Siap Pakai", style = "unite", color = "primary", size = "lg", class = "start-button")
             )
           )
  ),
  
  tabPanel("Manual Input",
           fluidPage(
             useWaiter(),
             tags$head(
               tags$style(HTML("
                 body {
                   background: linear-gradient(to bottom right, #e6f4f1, #c2e9e2);
                   font-family: 'Segoe UI', sans-serif;
                 }
                 .main-title {
                   font-size: 38px;
                   font-weight: 800;
                   color: #0d4b43;
                   text-align: center;
                   margin-top: 30px;
                   margin-bottom: 20px;
                   text-shadow: 1px 1px 2px rgba(0,0,0,0.05);
                 }
                 .score-box {
                   background-color: #ffffff;
                   padding: 25px;
                   border-radius: 15px;
                   box-shadow: 0 4px 14px rgba(0, 128, 96, 0.08);
                   margin-top: 20px;
                   border-left: 6px solid #2cb67d;
                 }
                 .sidebar-panel {
                   background-color: #f0fbf8;
                   padding: 25px;
                   border-radius: 12px;
                   box-shadow: 0 2px 12px rgba(0,0,0,0.05);
                 }
                 h4 {
                   color: #134e4a;
                   font-weight: 700;
                   margin-bottom: 15px;
                 }
                 .shiny-input-container > label {
                   font-weight: 600;
                   color: #0d4b43;
                 }
               "))
             ),
             
             div(HTML("<i class='fa-solid fa-recycle'></i> Smart Investors use <b>Metree</b>"), class = "main-title"),
             
             sidebarLayout(
               sidebarPanel(
                 class = "sidebar-panel",
                 textInput("nama_perusahaan", "\U0001F4CC Nama Perusahaan Anda:"),
                 numericInput("total_debt", "\U0001F4B8 Total Debt:", 0, min = 0),
                 numericInput("total_equity", "\U0001F3E2 Total Equity:", 0, min = 0),
                 numericInput("current_assets", "\U0001F4E6 Current Assets:", 0, min = 0),
                 numericInput("current_liabilities", "\U0001F4C9 Current Liabilities:", 0, min = 0),
                 numericInput("net_income", "\U0001F4B0 Net Income:", 0),
                 numericInput("revenue", "\U0001F4C8 Revenue (Sales):", 0, min = 0),
                 numericInput("cogs", "\U0001F3ED Cost of Goods Sold (COGS):", 0, min = 0),
                 numericInput("dividend_payout", "\U0001F4B5 Dividend Payout Ratio (0 - 1):", 0, min = 0, max = 1, step = 0.01),
                 fileInput("benchmark_file", "\U0001F4C2 Upload Benchmark CSV", accept = ".csv"),
                 
                 actionBttn("run_analysis", "🚀 Hitung Skor ESG", style = "jelly", color = "success", size = "lg")
               ),
               
               mainPanel(
                 conditionalPanel(
                   condition = "input.run_analysis % 2 == 1",
                   
                   div(class = "score-box",
                       h4("\U0001F50D Ringkasan Rasio dan Skor"),
                       withWaiter(verbatimTextOutput("ratios")),
                       br(),
                       downloadButton("download_rasio", "📥 Download Ringkasan Rasio", class = "btn btn-primary")
                   ),
                   
                   div(class = "score-box",
                       h4("\U0001F4CB Hasil Benchmark ESG"),
                       withWaiter(verbatimTextOutput("benchmark_result"))
                   )
                 )
               )
             )
           )
  ),
  
  tabPanel("Analisis Lanjutan",
           fluidPage(
             div(HTML("<i class='fa-solid fa-leaf'></i> Smart Investors use <b>Metree</b>"), class = "main-title"),
             sidebarLayout(
               sidebarPanel(
                 fileInput("upload_manual_result", "📥 Upload Ringkasan Rasio Anda (.csv)", accept = ".csv"),
                 fileInput("upload_benchmark_custom", "📂 Upload Benchmark Pembanding (.csv)", accept = ".csv"),
                 actionBttn("compare_manual_upload", "🔍 Bandingkan dengan Benchmark", style = "unite", color = "primary")
               ),
               mainPanel(
                 conditionalPanel(
                   condition = "input.compare_manual_upload % 2 == 1",
                   div(class = "score-box",
                       h4("📊 Detail Ringkasan Anda"),
                       verbatimTextOutput("uploaded_manual_detail")
                   ),
                   div(class = "score-box",
                       h4("📈 Benchmark & Status ESG"),
                       verbatimTextOutput("uploaded_comparison_result")
                   )
                 )
               )
             )
           )
  ),
  
  
  tabPanel("Data Siap Pakai",
           fluidPage(
             div(HTML("<i class='fa-solid fa-database'></i> Smart Investors use <b>Metree</b>"), class = "main-title"),
             fluidRow(
               column(6,
                      tags$h4("📂 Pilih Sektor & Perusahaan"),
                      selectInput("selected_sector", "Pilih Sektor", 
                                  choices = unique(perusahaan_df$Sektor), 
                                  selected = unique(perusahaan_df$Sektor)[1]),
                      uiOutput("select_company")
               ),
               column(6,
                      tags$h4("📊 Rincian Perusahaan"),
                      div(class = "score-box detail-box",
                          verbatimTextOutput("company_detail")
                      )
               )
             ),
             tags$h4("✅ Hasil ESG"),
             div(class = "score-box",
                 verbatimTextOutput("compare_result")
             )
           )
      )
  )


server <- function(input, output, session) {
  
  observeEvent(input$go_manual, {
    updateNavbarPage(session, "navbar", selected = "Manual Input")
  })
  
  observeEvent(input$go_lanjutan, {
    updateNavbarPage(session, "navbar", selected = "Analisis Lanjutan")
  })
  
  
  observeEvent(input$go_auto, {
    updateNavbarPage(session, "navbar", selected = "Data Siap Pakai")
  })
  
  output$ratios <- renderPrint({
    h <- hasil()
    cat("Nama Perusahaan:", h$nama, "\n")
    cat("Debt to Equity Ratio (DER):", round(h$DER, 2), "- Skor:", h$skor_DER, "\n")
    cat("Current Ratio:", round(h$Current_Ratio, 2), "- Skor:", h$skor_Current, "\n")
    cat("Return on Equity (ROE):", round(h$ROE * 100, 2), "% - Skor:", h$skor_ROE, "\n")
    cat("Gross Profit Margin (GPM):", round(h$GPM * 100, 2), "% - Skor:", h$skor_GPM, "\n")
    cat("Sustainable Growth Rate (SGR):", round(h$SGR * 100, 2), "% - Skor:", h$skor_SGR, "\n\n")
    cat("Total Skor:", h$total_skor, "dari 25\n")
    cat("Skor Akhir:", round(h$skor_akhir, 2), "%\n")
  })
  
  
  hasil <- reactive({
    DER <- ifelse(input$total_equity == 0, NA, input$total_debt / input$total_equity)
    Current_Ratio <- ifelse(input$current_liabilities == 0, NA, input$current_assets / input$current_liabilities)
    ROE <- ifelse(input$total_equity == 0, NA, input$net_income / input$total_equity)
    GPM <- ifelse(input$revenue == 0, NA, (input$revenue - input$cogs) / input$revenue)
    SGR <- ifelse(is.na(ROE), NA, ROE * (1 - input$dividend_payout))
    
    skor_DER <- ifelse(is.na(DER), 0, ifelse(DER < 0.5, 5, ifelse(DER <= 1.0, 3, 1)))
    skor_Current <- ifelse(is.na(Current_Ratio), 0, ifelse(Current_Ratio > 2, 5, ifelse(Current_Ratio >= 1, 3, 1)))
    skor_ROE <- ifelse(is.na(ROE), 0, ifelse(ROE > 0.15, 5, ifelse(ROE >= 0.05, 3, 1)))
    skor_GPM <- ifelse(is.na(GPM), 0, ifelse(GPM > 0.4, 5, ifelse(GPM >= 0.2, 3, 1)))
    skor_SGR <- ifelse(is.na(SGR), 0, ifelse(SGR > 0.10, 5, ifelse(SGR >= 0.05, 3, 1)))
    
    total_skor <- skor_DER + skor_Current + skor_ROE + skor_GPM + skor_SGR
    skor_akhir <- (total_skor / 25) * 100
    
    list(
      nama = input$nama_perusahaan,
      DER = DER, skor_DER = skor_DER,
      Current_Ratio = Current_Ratio, skor_Current = skor_Current,
      ROE = ROE, skor_ROE = skor_ROE,
      GPM = GPM, skor_GPM = skor_GPM,
      SGR = SGR, skor_SGR = skor_SGR,
      total_skor = total_skor,
      skor_akhir = skor_akhir
    )
  })
  
  output$download_rasio <- downloadHandler(
    filename = function() {
      paste0(gsub("\\s+", "_", input$nama_perusahaan), "_ringkasan_rasio.csv")
    },
    content = function(file) {
      h <- hasil()
      ringkasan <- data.frame(
        Nama = h$nama,
        DER = round(h$DER, 4),
        Skor_DER = h$skor_DER,
        Current_Ratio = round(h$Current_Ratio, 4),
        Skor_Current = h$skor_Current,
        ROE = round(h$ROE * 100, 2),
        Skor_ROE = h$skor_ROE,
        GPM = round(h$GPM * 100, 2),
        Skor_GPM = h$skor_GPM,
        SGR = round(h$SGR * 100, 2),
        Skor_SGR = h$skor_SGR,
        Total_Skor = h$total_skor,
        Skor_Akhir = round(h$skor_akhir, 2)
      )
      write.csv(ringkasan, file, row.names = FALSE)
    }
  )
  
  output$benchmark_result <- renderPrint({
    req(benchmark_stats())
    b <- benchmark_stats()
    h <- hasil()
    cat("Rata-rata Skor Akhir Benchmark:", round(b$mean, 2), "%\n")
    cat("Standar Deviasi:", round(b$sd, 2), "%\n")
    cat("Batas Minimum ESG:", round(b$threshold, 2), "%\n\n")
    cat("Perusahaan Anda:", h$nama, "\n")
    cat("Skor Akhir:", round(h$skor_akhir, 2), "%\n")
    cat("Status ESG:", ifelse(h$skor_akhir >= b$threshold, "\u2705 ESG Performed", "\u274c Belum ESG Performed"), "\n")
  })
  
  uploaded_manual_data <- reactive({
    req(input$upload_manual_result)
    read.csv(input$upload_manual_result$datapath)
  })
  
  uploaded_benchmark_data <- reactive({
    req(input$upload_benchmark_custom)
    read.csv(input$upload_benchmark_custom$datapath) %>%
      mutate(
        DER = Total_Debt / Total_Equity,
        Current_Ratio = Current_Assets / Current_Liabilities,
        ROE = Net_Income / Total_Equity,
        GPM = (Revenue - COGS) / Revenue,
        SGR = ROE * (1 - Dividend_Payout),
        Total_Skor = case_when(
          DER < 0.5 ~ 5, DER <= 1.0 ~ 3, TRUE ~ 1
        ) + case_when(
          Current_Ratio > 2 ~ 5, Current_Ratio >= 1 ~ 3, TRUE ~ 1
        ) + case_when(
          ROE > 0.15 ~ 5, ROE >= 0.05 ~ 3, TRUE ~ 1
        ) + case_when(
          GPM > 0.4 ~ 5, GPM >= 0.2 ~ 3, TRUE ~ 1
        ) + case_when(
          SGR > 0.10 ~ 5, SGR >= 0.05 ~ 3, TRUE ~ 1
        ),
        Skor_Akhir = (Total_Skor / 25) * 100
      )
  })
  
  benchmark_custom_stats <- reactive({
    b <- uploaded_benchmark_data()
    mean_score <- mean(b$Skor_Akhir)
    sd_score <- sd(b$Skor_Akhir)
    threshold <- mean_score - sd_score
    list(mean = mean_score, sd = sd_score, threshold = threshold)
  })
  
  output$uploaded_manual_detail <- renderPrint({
    req(uploaded_manual_data())
    h <- uploaded_manual_data()
    cat("Nama:", h$Nama[1], "\n")
    cat("DER:", h$DER[1], "- Skor:", h$Skor_DER[1], "\n")
    cat("Current Ratio:", h$Current_Ratio[1], "- Skor:", h$Skor_Current[1], "\n")
    cat("ROE:", h$ROE[1], "% - Skor:", h$Skor_ROE[1], "\n")
    cat("GPM:", h$GPM[1], "% - Skor:", h$Skor_GPM[1], "\n")
    cat("SGR:", h$SGR[1], "% - Skor:", h$Skor_SGR[1], "\n")
    cat("Total Skor:", h$Total_Skor[1], "/ 25\n")
    cat("Skor Akhir:", h$Skor_Akhir[1], "%\n")
  })
  
  output$uploaded_comparison_result <- renderPrint({
    req(uploaded_manual_data(), benchmark_custom_stats())
    h <- uploaded_manual_data()
    b <- benchmark_custom_stats()
    skor_akhir <- h$Skor_Akhir[1]
    cat("Rata-rata Skor Akhir Benchmark:", round(b$mean, 2), "%\n")
    cat("Standar Deviasi:", round(b$sd, 2), "%\n")
    cat("Batas Minimum ESG:", round(b$threshold, 2), "%\n\n")
    cat("Skor Anda:", skor_akhir, "%\n")
    cat("Status ESG:", ifelse(skor_akhir >= b$threshold, "\u2705 ESG Performed", "\u274c Belum ESG Performed"), "\n")
  })
  
  
  benchmark_data <- reactive({
    read.csv("Benchmark_Cyclical_file.csv") %>%
      mutate(
        DER = Total_Debt / Total_Equity,
        Current_Ratio = Current_Assets / Current_Liabilities,
        ROE = Net_Income / Total_Equity,
        GPM = (Revenue - COGS) / Revenue,
        SGR = ROE * (1 - Dividend_Payout),
        Total_Skor = case_when(
          DER < 0.5 ~ 5, DER <= 1.0 ~ 3, TRUE ~ 1
        ) + case_when(
          Current_Ratio > 2 ~ 5, Current_Ratio >= 1 ~ 3, TRUE ~ 1
        ) + case_when(
          ROE > 0.15 ~ 5, ROE >= 0.05 ~ 3, TRUE ~ 1
        ) + case_when(
          GPM > 0.4 ~ 5, GPM >= 0.2 ~ 3, TRUE ~ 1
        ) + case_when(
          SGR > 0.10 ~ 5, SGR >= 0.05 ~ 3, TRUE ~ 1
        ),
        Skor_Akhir = (Total_Skor / 25) * 100
      )
  })
  
  benchmark_stats <- reactive({
    b <- benchmark_data()
    mean_score <- mean(b$Skor_Akhir)
    sd_score <- sd(b$Skor_Akhir)
    threshold <- mean_score - sd_score
    list(mean = mean_score, sd = sd_score, threshold = threshold)
  })
  
  perusahaan_data <- reactive({ perusahaan_df })
  
  output$select_company <- renderUI({
    req(input$selected_sector)
    perusahaan_terfilter <- perusahaan_df %>%
      filter(Sektor == input$selected_sector)
    
    selectInput("chosen_company", "Pilih Perusahaan", choices = perusahaan_terfilter$Nama)
  })
  
  
  output$compare_result <- renderPrint({
    req(input$chosen_company)
    df <- perusahaan_data()
    b <- benchmark_data()
    row <- df[df$Nama == input$chosen_company, ]
    DER <- row$Total_Debt / row$Total_Equity
    Current_Ratio <- row$Current_Assets / row$Current_Liabilities
    ROE <- row$Net_Income / row$Total_Equity
    GPM <- (row$Revenue - row$COGS) / row$Revenue
    SGR <- ROE * (1 - row$Dividend_Payout)
    skor_total <- sum(
      case_when(DER < 0.5 ~ 5, DER <= 1.0 ~ 3, TRUE ~ 1),
      case_when(Current_Ratio > 2 ~ 5, Current_Ratio >= 1 ~ 3, TRUE ~ 1),
      case_when(ROE > 0.15 ~ 5, ROE >= 0.05 ~ 3, TRUE ~ 1),
      case_when(GPM > 0.4 ~ 5, GPM >= 0.2 ~ 3, TRUE ~ 1),
      case_when(SGR > 0.10 ~ 5, SGR >= 0.05 ~ 3, TRUE ~ 1)
    )
    skor_akhir <- (skor_total / 25) * 100
    threshold <- mean(b$Skor_Akhir) - sd(b$Skor_Akhir)
    cat("Perusahaan:", row$Nama, "\n")
    cat("Skor Akhir:", round(skor_akhir, 2), "%\n")
    cat("Benchmark Threshold:", round(threshold, 2), "%\n")
    cat("Status ESG:", ifelse(skor_akhir >= threshold, "\u2705 ESG Performed", "\u274c Belum ESG Performed"), "\n")
  })
  
  output$company_detail <- renderPrint({
    req(input$chosen_company)
    df <- perusahaan_data()
    row <- df[df$Nama == input$chosen_company, ]
    DER <- row$Total_Debt / row$Total_Equity
    Current_Ratio <- row$Current_Assets / row$Current_Liabilities
    ROE <- row$Net_Income / row$Total_Equity
    GPM <- (row$Revenue - row$COGS) / row$Revenue
    SGR <- ROE * (1 - row$Dividend_Payout)
    skor_DER <- ifelse(DER < 0.5, 5, ifelse(DER <= 1.0, 3, 1))
    skor_Current <- ifelse(Current_Ratio > 2, 5, ifelse(Current_Ratio >= 1, 3, 1))
    skor_ROE <- ifelse(ROE > 0.15, 5, ifelse(ROE >= 0.05, 3, 1))
    skor_GPM <- ifelse(GPM > 0.4, 5, ifelse(GPM >= 0.2, 3, 1))
    skor_SGR <- ifelse(SGR > 0.10, 5, ifelse(SGR >= 0.05, 3, 1))
    total_skor <- skor_DER + skor_Current + skor_ROE + skor_GPM + skor_SGR
    skor_akhir <- (total_skor / 25) * 100
    cat("🔍 Rincian Perusahaan:", row$Nama, "\n")
    cat("DER:", round(DER, 2), "- Skor:", skor_DER, "\n")
    cat("Current Ratio:", round(Current_Ratio, 2), "- Skor:", skor_Current, "\n")
    cat("ROE:", round(ROE * 100, 2), "% - Skor:", skor_ROE, "\n")
    cat("GPM:", round(GPM * 100, 2), "% - Skor:", skor_GPM, "\n")
    cat("SGR:", round(SGR * 100, 2), "% - Skor:", skor_SGR, "\n\n")
    cat("Total Skor:", total_skor, "/ 25\n")
    cat("Skor Akhir:", round(skor_akhir, 2), "%\n")
  })
}

# Run App
shinyApp(ui = ui, server = server)

