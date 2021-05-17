message( '\tLectura de la proyección de precios' )

# Carga de datos -----------------------------------------------------------------------------------
file_liquidaciones <- paste0( parametros$RData, 'IESS_liquidaciones.RData' )
load(paste0(parametros$RData, "IESS_listado_beneficiarios.Rdata"))

load( file = file_liquidaciones )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

message( '\tGenerando nombres de beneficiarios de liquidaciones' )
#1. Tabla resumen recaudación total-----------------------------------------------------------------
for (j in c(1:nrow(lista_ben))) {
  
  aux <- lista_ben %>%
    filter( id_ben == j) %>%
    select( -id_ben ) %>%
    mutate( fecha_fallecimiento = as.character(fecha_fallecimiento),
            fecha_inicio = as.character(fecha_inicio),
            fecha_fin  = as.character(fecha_fin ) ) %>%
    select( apellidos_y_nombres) 
  
  aux <- data.frame(lapply(aux, function(x) { if(is.character(x)) gsub("Ñ", "$\\tilde{\\text{N}}$", x, fixed = TRUE) else x }))
  
  write.table(aux, file = paste0( parametros$resultado_tablas, 'iess_nombre_',j,'.tex' ),
              sep = ",",
              col.names = FALSE,
              row.names = FALSE,
              quote = FALSE,
              qmethod = "double")
  
}
#---------------------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()