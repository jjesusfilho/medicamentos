library(tjsp)

dir.create("data-raw")
dir.create("data-raw/cjpg")

tjsp_baixar_cjpg(classe = "8714, 8501",
                 assunto = "11561",
                 paginas = 1:20, ## Coloque esta opção para limitar o n
                 diretorio = "data-raw/cjpg")


cjpg <- tjsp_ler_cjpg(diretorio = "data-raw/cjpg")

dir.create("data-raw/cpopg")

tjsp_baixar_cpopg(cjpg$processo, diretorio = "data-raw/cpopg")

arquivos <- list.files("data-raw/cpopg", full.names = TRUE)

dados <- tjsp_ler_dados_cpopg(arquivos, wide = TRUE)

partes <- tjsp_ler_partes(arquivos)

movimentacao <- ler_movimentacao_cposg(arquivos)






