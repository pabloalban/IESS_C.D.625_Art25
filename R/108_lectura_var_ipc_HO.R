message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura de la variación del IPC' )

#Cargando información financiera--------------------------------------------------------------------
file<-paste0(parametros$Data, 'IESS_var_ipc.xlsx' )


#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Listado de beneficiarios---------------------------------------------------------------------------
var_ipc <- read_excel(file,
                  sheet = 'Hoja1',
                  col_names = TRUE,
                  col_types = NULL,
                  na = "",
                  skip = 0) %>%
  mutate(var_ipc = var_ipc / 100) %>%
  clean_names()

#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando la variación del ipc' )

save( var_ipc,
      file = paste0( parametros$RData, 'IESS_var_ipc.RData' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()