message( '\tLectura de la proyección de precios' )

# Carga de datos -----------------------------------------------------------------------------------
file_ultimo_sueldo <- paste0( parametros$RData, 'IESS_ultimo_sueldo.RData' )
file_liquidaciones <- paste0( parametros$RData, 'IESS_liquidaciones.RData' )
load( file = file_ultimo_sueldo )
load( file = file_liquidaciones )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

message( '\tGenerando actualización último sueldo' )
#1. Tabla resumen recaudación total-----------------------------------------------------------------
n <- ultimo_sueldo_pre_dolar %>%
  distinct(cedula , .keep_all = TRUE)
n <- nrow(n)

for (j in c(1:n)) {
aux <- ultimo_sueldo_pre_dolar %>%
  filter( id_ben == j) %>%
  mutate(var_ipc = 100 * var_ipc ,
         anio_cal = as.character(anio_cal) ) %>%
  select( -id_ben )

aux_xtab <- xtable( aux, digits = c( 0, 0, 0, 2, 2, 2  ) )

print( aux_xtab, 
       file = paste0( parametros$resultado_tablas,'iess_actualizacion_',j,'.tex' ),
       type = 'latex',
       include.colnames = FALSE, include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = NULL,
       sanitize.text.function = identity)
}
#---------------------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()