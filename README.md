# 🌿 Metree ESG Analyzer

**Metree ESG Analyzer** adalah aplikasi interaktif berbasis **R Shiny** untuk membantu investor dan pelaku bisnis dalam menilai performa ESG (Environmental, Social, Governance) perusahaan dari sisi rasio keuangan. Aplikasi ini mempermudah proses input data, analisis lanjutan, hingga pemanfaatan data siap pakai secara visual dan interaktif.

⚠️ Wajib: Install Dulu Package Ini

Sebelum menjalankan aplikasi ini, **pastikan kamu sudah menginstal semua package berikut di R/RStudio**:

install.packages(c(
  "shiny", 
  "dplyr", 
  "shinythemes", 
  "bslib", 
  "shinyWidgets", 
  "waiter", 
  "fontawesome"
))

---

## 📦 Fitur Utama

### 🏠 Beranda
Tampilan awal dengan navigasi tiga jalur analisis:
- 🚀 **Manual Input** – masukkan data keuangan perusahaan kamu secara langsung.
- 📂 **Analisis Lanjutan** – upload file hasil ringkasan rasio dan benchmark.
- 📊 **Data Siap Pakai** – pilih perusahaan dan sektor dari data yang telah tersedia.

---

### ✍️ Manual Input
Fitur ini memungkinkan kamu untuk:
- Mengisi data seperti: Total Debt, Equity, Revenue, dll.
- Menghitung rasio ESG secara otomatis:
  - **DER (Debt to Equity Ratio)**
  - **Current Ratio**
  - **ROE (Return on Equity)**
  - **GPM (Gross Profit Margin)**
  - **SGR (Sustainable Growth Rate)**
- Mendapatkan skor dan status ESG perusahaanmu.
- Mengunduh hasil analisis ke dalam file `.csv`.
- Membandingkan dengan data benchmark yang diunggah.

---

### 📂 Analisis Lanjutan
Fitur ini cocok untuk kamu yang sudah memiliki:
- Ringkasan hasil analisis rasio dalam file `.csv`
- Benchmark pembanding dalam format yang sama

Cukup upload kedua file tersebut, dan aplikasi akan menghitung skor akhir dan mengevaluasi status ESG berdasarkan nilai ambang batas (mean - standar deviasi benchmark).

---

### 🏢 Data Siap Pakai
- Pilih sektor dan perusahaan dari data statis yang sudah disediakan.
- Tampilkan rincian keuangan dan skor ESG.
- Bandingkan dengan benchmark sektor yang bersangkutan.

---

## ⚙️ Metode Penilaian ESG

### Rasio yang Digunakan dan Skor
| Rasio | Penjelasan | Skor Maksimum |
|-------|------------|---------------|
| DER (Debt to Equity) | Leverage | 5 (DER < 0.5) |
| Current Ratio | Likuiditas | 5 (CR > 2) |
| ROE | Profitabilitas | 5 (ROE > 15%) |
| GPM | Efisiensi Laba Kotor | 5 (GPM > 40%) |
| SGR | Potensi Pertumbuhan | 5 (SGR > 10%) |

**Total skor maksimal**: 25  
**Skor akhir ESG**: `(total skor / 25) * 100`  
**Status ESG**: ✅ Performed jika skor akhir ≥ (mean - standar deviasi benchmark)

---

## 📁 Struktur File yang Diperlukan

### ✅ Benchmark atau Data Siap Pakai (CSV)
```csv
Nama,Total_Debt,Total_Equity,Current_Assets,Current_Liabilities,Net_Income,Revenue,COGS,Dividend_Payout
