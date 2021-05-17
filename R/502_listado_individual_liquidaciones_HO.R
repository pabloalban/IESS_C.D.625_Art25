message( '\tLectura de la proyección de precios' )

# Carga de datos -----------------------------------------------------------------------------------
file_liquidaciones <- paste0( parametros$RData, 'IESS_liquidaciones.RData' )
load( file = file_liquidaciones )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

message( '\tGenerando tablas individuales de liquidaciones' )
#1. Tabla resumen recaudación total-----------------------------------------------------------------
for (j in c(1:nrow(lista_ben))) {

  aux <- beneficios_anual %>%
    filter( id_ben == j) %>%
    select( -id_ben ) %>%
    mutate( fecha_fallecimiento = as.character(fecha_fallecimiento),
            fecha_inicio = as.character(fecha_inicio),
            fecha_fin  = as.character(fecha_fin ) ) %>%
    select( -apellidos_y_nombres, -ultimo_sueldo_nominal)
  n <- nrow(aux)
  
  aux <- rbind((aux), c("Total", NA, NA, NA, NA, NA, NA, NA, as.character(colSums(aux[,9:ncol(aux)]) ) ) )
  aux[c(8:ncol(aux))] <- lapply(aux[c(8:ncol(aux))], function(x) as.numeric(x))

  aux_xtab <- xtable( aux, digits = c( 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2  ) )
  
  print( aux_xtab, 
         file = paste0( parametros$resultado_tablas, 'iess_liquidacion_',j,'.tex' ),
         type = 'latex',
         include.colnames = FALSE, include.rownames = FALSE,
         format.args = list( decimal.mark = ',', big.mark = '.' ),
         only.contents = TRUE,
         hline.after = c( n ),
         sanitize.text.function = identity)
}
#---------------------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
