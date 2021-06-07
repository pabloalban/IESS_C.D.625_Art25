message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura del listado de beneficiarios' )

#Cargando información financiera--------------------------------------------------------------------
file <- paste0(parametros$Data, 'INFO-10877_10.tsv' )
file2 <- paste0(parametros$Data,'INFO-11051-DAIE-Novedades/', 'INFO-11051.tsv' )
file3 <- paste0('D:/disk.frame/', 'INFO-11051.tsv')
#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Listado de hipétesis-------------------------------------------------------------------------------
#vroom(file, delim = ",")

#Base de ajuste-------------------------------------------------------------------------------------
flights.df <- csv_to_disk.frame(
  file, 
  outdir = "tmp_flights.df",
  overwrite = T,
  outdir = "tmp_flights_too_large.df",
  in_chunk_size = 10000000,
  nchunks)

flights.df

class(flights.df1)

str(flights.df1)

flights.df1 <- select(flights.df, ANIPER,	MESPER,	RUCEMP,	CODSUC,	CODSEC)
flights.df1

class(flights.df1)

collect(flights.df1) %>% head

aux <- flights.df1 %>% collect()


###
info <- csv_to_disk.frame(
  file2, 
  outdir = "tmp_info.df",
  overwrite = T,
  in_chunk_size = 10000000,
  nchunks=16,
  shardby = c("NUMAFI","CODTIPNOVHISLAB", "CODRELTRA") 	)

class(info)

str(info)

aux <- select(info,NUMAFI,CODTIPNOVHISLAB, CODRELTRA) %>% head()

class(flights.df1)

collect(flights.df1) %>% head

aux <- flights.df1 %>% collect()


###########
# read 10 millions at once
in_chunk_size = 1e7

system.time( info <- csv_to_disk.frame(
  file.path(file3), 
  in_chunk_size = in_chunk_size,
  outdir = "D:/disk.frame/tmp_info.df",
  overwrite = T,
  colClasses = list(character = c("NUMAFI","RUCEMP","CODSUC"))
))

class(info)
collect(info) %>% head


tic = Sys.time()

# doing group-by in two-stages which is annoying; I am working on something better
data <- info %>%
  srckeep(c("NUMAFI","RUCEMP","CODSUC","CODTIPNOVHISLAB","FECREGNOV")) %>% head(.)
(toc = Sys.time() - tic)

str(data)



tic = Sys.time()

# doing group-by in two-stages which is annoying; I am working on something better
data <- info %>%
  srckeep(c("FECREGNOV","CODTIPNOVHISLAB")) %>%
  mutate(FECREGNOV = as.Date(FECREGNOV, "%d/%m/%Y")) %>%
  #select(FECREGNOV) %>%
  chunk_summarize( anio = year(FECREGNOV)) %>%
  group_by(anio,CODTIPNOVHISLAB) %>%
  mutate( registros = n()) 
(toc = Sys.time() - tic)


tic = Sys.time()

data <- info %>%
  srckeep(c("FECREGNOV","CODTIPNOVHISLAB")) %>%
  mutate(FECREGNOV = as.Date(FECREGNOV, "%d/%m/%Y")) %>%
  mutate(anio = year(FECREGNOV)) %>%
  hard_group_by(anio,CODTIPNOVHISLAB) %>%
  mutate( registros = n())  
  

#write_disk.frame(flights.df, outdir="out")

aux <- data %>% collect(parallel = T) %>%
  group_by(anio,CODTIPNOVHISLAB ) %>% 
  distinct(anio,CODTIPNOVHISLAB, .keep_all = TRUE) %>%
  ungroup()
(toc = Sys.time() - tic)


data <- data %>% collect(parallel = T) %>%
  group_by(anio,CODTIPNOVHISLAB ) %>% 
  summarise(registros = sum(registros)) %>% head(100)
(toc = Sys.time() - tic)
#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando tasas' )

save( tasas_macro,
      file = paste0( parametros$RData, 'IESS_tasas_macro.RData' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()