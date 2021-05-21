message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura del listado de beneficiarios' )

#Cargando información financiera--------------------------------------------------------------------
file <- paste0(parametros$Data, 'BCE_pib.xlsx' )
file_tasas <- paste0(parametros$Data, 'BCE_tasas_referenciales.xlsx' )
file_salarios <- paste0(parametros$Data, 'IESS_salarios_promedios.xlsx' )
file_inflacion <- paste0(parametros$Data, 'INEC_inflacion.xlsx' )
file_sbu <- paste0(parametros$Data, 'MDT_sbu.xlsx' )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Listado de hipétesis-------------------------------------------------------------------------------
vroom(file, delim = ",")

#Base de ajuste-------------------------------------------------------------------------------------
tasas_macro <- pib %>% 
  left_join(., tasas, by = "anio") %>%
  left_join(., inflacion, by = "anio") %>%
  left_join(., salarios, by = "anio") %>%
  left_join(., sbu, by = "anio")

#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando tasas' )

save( tasas_macro,
      file = paste0( parametros$RData, 'IESS_tasas_macro.RData' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()