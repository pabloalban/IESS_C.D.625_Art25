message( '\tLectura de la proyección de precios' )

# Carga de datos -----------------------------------------------------------------------------------
file_liquidaciones <- paste0( parametros$RData, 'IESS_liquidaciones.RData' )
file_beneficiarios <- paste0( parametros$RData, 'IESS_listado_beneficiarios.RData' )
load( file = file_liquidaciones )
load( file = file_beneficiarios )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

message( '\tGenerando listado de liquidaciones' )
#1. Lista de beneficiarios--------------------------------------------------------------------------
aux <- lista_demandantes %>%
  select(-fecha_fallecimiento, -anio_ultima_planilla, -mes_ultima_planilla, -ultima_planilla, -categoria_del_ultimo_aporte )
aux$apellidos_y_nombres <- gsub("Ñ", "$\\tilde{\\text{N}}$", aux$apellidos_y_nombres, fixed = TRUE)
aux$observacion <- gsub("á", "\\\'{a}", aux$observacion, fixed = TRUE)
aux$observacion <- gsub("é", "\\\'{e}", aux$observacion, fixed = TRUE)
aux$observacion <- gsub("í", "\\\'{i}", aux$observacion, fixed = TRUE)
aux$observacion <- gsub("ó", "\\\'{o}", aux$observacion, fixed = TRUE)
aux$observacion <- gsub("ú", "\\\'{u}", aux$observacion, fixed = TRUE)
aux$observacion <- gsub("Ú", "\\\'{U}", aux$observacion, fixed = TRUE)

aux_xtab <- xtable( aux, digits = c( 0, 0, 0, 0, 0, 0, 5, 0, 0  ) )


print( aux_xtab, 
       file = paste0( parametros$resultado_tablas, 'iess_demandantes','.tex' ),
       type = 'latex',
       include.colnames = FALSE, include.rownames = FALSE,
       format.args = list( decimal.mark = ',', big.mark = '.' ),
       only.contents = TRUE,
       hline.after = NULL,
       sanitize.text.function = identity)

#2. Tabla resumen de liquidaciones------------------------------------------------------------------

  aux <- lista_ben %>%
    select( -id_ben ) %>%
    mutate( fecha_fallecimiento = as.character(fecha_fallecimiento),
            fecha_inicio = as.character(fecha_inicio),
            fecha_fin  = as.character(fecha_fin ) )
  n <- nrow(aux)
  aux$apellidos_y_nombres <- gsub("Ñ", "$\\tilde{\\text{N}}$", aux$apellidos_y_nombres, fixed = TRUE)
  aux <- rbind((aux), c("Total", NA, NA, NA, NA, NA, NA, as.character(colSums(aux[,8:ncol(aux)]))))
  aux[6:ncol(aux)] <- lapply(aux[6:ncol(aux)], function(x) as.numeric(x))
  
  aux_xtab <- xtable( aux, digits = c( 0, 0, 0, 0, 0, 0, 5, 2, 2, 2, 2  ) )
  #aux_xtab <- tildes_a_latex(aux_xtab)
  print( aux_xtab, 
         file = paste0( parametros$resultado_tablas, 'iess_liquidacion','.tex' ),
         type = 'latex',
         include.colnames = FALSE, include.rownames = FALSE,
         format.args = list( decimal.mark = ',', big.mark = '.' ),
         only.contents = TRUE,
         hline.after = c( n ),
         sanitize.text.function = identity)

  
#---------------------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()