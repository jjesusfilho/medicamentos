library(tidyverse)
library(tjsp)

classe <- "8714, 8501"
assunto <- "11561"

tjsp::tjsp_baixar_cjpg(classe  = classe,
                       assunto = assunto,
                       diretorio = "data-raw/cjpg",
                       paginas = 1:20)





a <- JurisMiner::dividir_sequencia(a, 80)
library(magrittr)
purrr::iwalk(a, ~{

  tjsp::ler_cjpg(.x) %>%
   saveRDS(paste0("data/cjpg/",.y,".rds"))


})

a <- JurisMiner::listar_arquivos("data/cjpg")

processos <- purrr::map(a,~{

  readRDS(.x) %>%
    dplyr::pull(processo)
}) %>%
  unlist()

processos <- unique(processos)

processos <- JurisMiner::dividir_sequencia(processos,20)


purrr::walk(processos,~{
  tjsp::autenticar()
  tjsp::tjsp_baixar_cpopg(.x, diretorio = "data-raw/cpopg")


})

saveRDS(processos,"data/processos_cjpg.rds")

a <- JurisMiner::listar_arquivos("data-raw/cpopg")

a <- JurisMiner::dividir_sequencia(a, 20)

purrr::iwalk(a,~{

  tjsp::tjsp_ler_dados_cpopg(.x, wide = TRUE) %>%
    saveRDS(paste0("data/cpopg/dados_",.y,".rds"))

  tjsp::tjsp_ler_partes(.x) %>%
      saveRDS(paste0("data/cpopg/partes_",.y,".rds"))

  tjsp::ler_movimentacao_cposg(.x) %>%
       saveRDS(paste0("data/cpopg/movimentacao_", .y, ".rds"))



})

m <- list.files("data/cpopg",full.names = TRUE, pattern="moviment")

mov <- purrr::map_dfr(m, readRDS)
saveRDS(mov,"data/movimentacao.rds")
save(mov,file = "data/movimentacao.rda")

mov <- mov %>%
     dplyr::mutate(grupo = dplyr::ntile(n = 10))

mov <- mov %>%
     dplyr::group_split( grupo)

purrr::walk(1:10,~{

  mov[[.x]] %>%
    dplyr::select(-grupo) %>%
    saveRDS(paste0("data/cpopg/movimentacao_",.x,".rds"))

})


file.remove(m)
p <- list.files("data/cpopg",full.names = TRUE, pattern="dado")
dados <- purrr::map_dfr(p,readRDS)

saveRDS(dados,"data/cpopg/dados.rds")
file.remove(p)
