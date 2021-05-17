message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura del listado de beneficiarios' )

#Cargando información financiera--------------------------------------------------------------------
file<-paste0(parametros$Data, 'IESS_listado_beneficiarios.xls' )


#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Listado de beneficiarios---------------------------------------------------------------------------
beneficiarios <- read_excel(file,
                          sheet = 'Imposiciones_ÚltimoSueldo',
                          col_names = TRUE,
                          col_types = NULL,
                          na = "",
                          skip = 0) %>% clean_names() %>% drop_na(apellidos_y_nombres)

beneficiarios$fecha_fallecimiento <-  as.Date(beneficiarios$fecha_fallecimiento, "%Y-%m-%d")



beneficiarios['anio_ultima_planilla'] <- (substr(beneficiarios$periodo_ultima_planilla, 1, 4))
beneficiarios['mes_ultima_planilla'] <- (substr(beneficiarios$periodo_ultima_planilla, 6, 7))
beneficiarios['ultima_planilla'] <- paste0(beneficiarios$anio_ultima_planilla,'-',beneficiarios$mes_ultima_planilla,'-','01')
beneficiarios$ultima_planilla <- as.Date(beneficiarios$ultima_planilla, "%Y-%m-%d")
beneficiarios$anio_ultima_planilla <- as.integer(beneficiarios$anio_ultima_planilla)
beneficiarios$mes_ultima_planilla <- as.integer(beneficiarios$mes_ultima_planilla)

lista_demandantes <- beneficiarios
#Filtrado de benficiarios con derecho---------------------------------------------------------------
beneficiarios <- beneficiarios %>%
  filter(cumple_derecho_pago_sentencia_2000_2010 == 'Si') %>%
  #filter( ultima_planilla > as.Date("1989-03-29","%Y-%m-%d")) %>%
  arrange(ultima_planilla)

#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando listado de beneficiarios' )

save( beneficiarios,lista_demandantes,
      file = paste0( parametros$RData, 'IESS_listado_beneficiarios.RData' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()