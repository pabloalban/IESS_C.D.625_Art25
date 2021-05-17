message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura de la canasta básica familiar' )

#Cargando información financiera--------------------------------------------------------------------
file<-paste0(parametros$Data, 'IESS_canasta_basica_familiar.xlsx' )


#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Listado de beneficiarios---------------------------------------------------------------------------
CBF <- read_excel(file,
                            sheet = 'CBF',
                            col_names = TRUE,
                            col_types = NULL,
                            na = "",
                            skip = 0) %>% clean_names()

#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando canasta básica familiar' )

save( CBF,
      file = paste0( parametros$RData, 'IESS_canasta_basica_familiar.RData' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()