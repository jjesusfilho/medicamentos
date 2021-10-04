library(tidyverse)
library(janitor)
dados <- dados %>%
         clean_names()



## Select: permitte selecionar colunas de interesse

d <- dados %>%
    select(processo,classe,digital,distribuicao, foro, vara, juiz,valor_da_acao)

d <- dados %>%
    select(1,2,5)

d <- dados %>%
     select(-codigo_processo, -area)

d <- dados %>%
     select(3:7)

d <- dados %>%
     select(ends_with("processo"))

d <- dados %>%
     select(starts_with("outros"))

d <- dados %>%
     select(contains("ao"))


d <- dados %>%
    select(processo, status = situacao)

## Rename

dados <- dados %>%
        rename(status = situacao)


### Filter

d <- dados %>%
    filter(digital == TRUE)

fisicos <- dados %>%
     filter(digital == FALSE)

saveRDS(fisicos, "data/cpopg/dados_fisicos.rds")

extinto <- dados %>%
       filter(situacao == "Extinto")

findos <- dados %>%
      filter(situacao =="Extinto" | situacao == "Arquivado")

digital_extinto <- dados %>%
     filter(digital == TRUE, situacao =="Extinto")

digital_extinto_je <- dados %>%
           filter(digital == TRUE,
                  situacao == "Extinto",
                  classe =="Procedimento do Juizado Especial Cível")



### Count

dados %>%
   count(digital)

dados %>%
   count(classe)

foro <- dados %>%
   count(foro, sort = TRUE)

foro_digital <- dados %>%
      count(foro, digital, sort = TRUE, name = "frequencia")

### Mutate

tolower("Jurimetria")

dados <- dados %>%
     mutate(situacao = tolower(situacao))

dados <- dados %>%
      mutate(situacao2 = tolower(situacao))

dados <- dados %>%
      mutate(situacao2 = NULL)

dados <- dados %>%
         mutate(situacao1 = tolower(situacao), .before = situacao) %>%
         mutate(sitacao2 = toupper(situacao), .after = situacao)



dados <- dados %>%
  select(processo,classe,digital,distribuicao, foro, vara, juiz,valor_da_acao)

library(lubridate)

str_sub("17/12/2019 às 11:07 - Livre", 1,10) %>%
    dmy()

dados <- dados %>%
    mutate(data_distribuicao =  str_sub(distribuicao, 1,10) %>%
                                dmy(),
          .after = distribuicao)


dados <- dados %>%
        mutate(ano_distribuicao = year(data_distribuicao),
               .after = distribuicao) %>%
        mutate(mes_distribuicao = month(data_distribuicao, label = TRUE, abbr = FALSE),
               .after = ano_distribuicao) %>%
        mutate(dia_distribuicao = wday(data_distribuicao, label = TRUE, abbr = FALSE),
               .after = mes_distribuicao)

dados %>%
    count(ano_distribuicao)

dados %>%
    count(mes_distribuicao, sort = TRUE)

dados %>%
   count(dia_distribuicao, sort = TRUE)


dados <- dados %>%
      mutate(ano_distribuicao =NULL,
             mes_distribuicao = NULL,
             dia_distribuicao = NULL)

library(tjsp)

numero("R$ 2.578,56")

dados <- dados %>%
      mutate(valor_da_acao = numero(valor_da_acao))

hist(log1p(dados$valor_da_acao))

### summarize + group_by


sumario <- dados %>%
         filter(!is.na(valor_da_acao)) %>%
        filter(valor_da_acao < 45000, valor_da_acao > 20000) %>%
        group_by(ano_distribuicao, mes_distribuicao) %>%
        summarize(quantidade = n(),
                  minimo = min(valor_da_acao),
                  maximo = max(valor_da_acao),
                  media = mean(valor_da_acao),
                  mediana = median(valor_da_acao),
                  soma = sum(valor_da_acao),
                  desvio_padrao = sd(valor_da_acao)
                  ) %>%
         ungroup()


s <- select(sumario, minimo)


requerente <- partes %>%
              filter(tipo_parte == "Reqte")

requerido <- partes %>%
         filter(tipo_parte == "Reqdo"| tipo_parte =="Reqda")












