# Metree ESG Analyzer

**Metree ESG Analyzer** adalah aplikasi berbasis Shiny untuk membantu investor menganalisis skor ESG (Environmental, Social, Governance) dari perusahaan berdasarkan data keuangan dan benchmark yang tersedia. Aplikasi ini menyediakan tiga mode input: manual input, upload file untuk analisis lanjutan, dan data siap pakai untuk analisis otomatis.

---

## Fitur Utama

- Input data perusahaan secara manual dan hitung skor ESG berdasarkan rasio keuangan utama.
- Upload hasil analisis sebelumnya dan bandingkan dengan benchmark custom.
- Pilih perusahaan dari data siap pakai untuk melihat analisis dan perbandingan dengan benchmark.
- Tampilan user-friendly dengan tema yang modern dan interaktif.

---

## Cara Instalasi

Pastikan R dan RStudio sudah terpasang, lalu install package berikut:

```r
install.packages(c("shiny", "dplyr", "shinythemes", "bslib", "shinyWidgets", "waiter", "fontawesome"))
