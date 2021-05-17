message( '\tLectura de la proyección de precios' )

# Carga de datos -----------------------------------------------------------------------------------
load(paste0(parametros$RData, "IESS_listado_beneficiarios.Rdata"))
load(paste0(parametros$RData, "IESS_ultimo_sueldo.RData"))
load(paste0(parametros$RData, "IESS_liquidaciones.RData"))


#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

message( '\tGenerando fechas de cese de beneficiarios de liquidaciones' )
#1. Tabla resumen recaudación total-----------------------------------------------------------------


write.xlsx(ultimo_sueldo_pre_dolar,
           file = paste0( parametros$resultado_seguro , 'liquidacion_holcim.xlsx' ),
           sheetName = "actualizacion", 
           col.names = TRUE,
           row.names = TRUE, 
           append = FALSE)

write.xlsx(beneficios_anual,
           file = paste0( parametros$resultado_seguro , 'liquidacion_holcim.xlsx' ),
           sheetName = "liquidacion", 
           col.names = TRUE,
           row.names = TRUE, 
           append = TRUE)

#2. Tabla liquidaciones-----------------------------------------------------------------------------
aux <- lista_ben %>%
  select( -id_ben ) %>%
  mutate( fecha_fallecimiento = as.character(fecha_fallecimiento),
          fecha_inicio = as.character(fecha_inicio),
          fecha_fin  = as.character(fecha_fin ) )

write.xlsx(aux,
           file = paste0( parametros$resultado_seguro , 'listado_liquidacion_holcim.xlsx' ),
           sheetName = "liquidacion", 
           col.names = TRUE,
           row.names = TRUE, 
           append = FALSE)
#---------------------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()