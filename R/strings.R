
paste("jurimetria", "é", "uma", "disciplina", "do Direito")


paste("jurimetria", "é", "uma", "disciplina", "do Direito", sep = "_")

paste0("jurimetria", "é", "uma", "disciplina", "do Direito")

str_length("jurimetria")
nchar("jurimetria")

str_sub("jurimetria", 1,2)

cnj <- "00000023520178260596"

sequencial <- str_sub(cnj, 1,7)
sequencial
digito <- str_sub(cnj, 8,9)

ano <- str_sub(cnj, )
