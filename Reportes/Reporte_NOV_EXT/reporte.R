# Script generado para compilar el informe
message( paste( rep( '-', 100 ), collapse = '' ) )

# Carga información --------------------------------------------------------------------------------
message('\tCargando información' )
setwd( parametros$work_dir )

# Control ------------------------------------------------------------------------------------------
REP_copy_final <- FALSE
REP_knit_quiet <- TRUE
REP_hacer_graficos <- TRUE
REP_hacer_tablas <- TRUE
REP_latex_clean <- FALSE
REP_latex_aux_clean <- FALSE
REP_latex_quiet <- TRUE

# Parámetros ---------------------------------------------------------------------------------------
message('\tEstableciendo parámetros')
REP_rep_nom <- parametros$reporte_nombre
REP_empresa <- parametros$empresa
REP_fec_eje <- format( parametros$fec_eje, '%Y_%m_%d' )
REP_rep_dir <- parametros$resultado_seguro
REP_rep_tab <- parametros$resultado_tablas
REP_rep_gra <- parametros$resultado_graficos
REP_rep_latex <- parametros$reporte_latex
REP_hor <- parametros$horizonte
REP_style <- 'style.tex'
REP_bib_lib <- 'bibliografia_libros.bib'
REP_bib_art <- 'bibliografia_articulos.bib'
REP_bib_ley <- 'bibliografia_leyes.bib'

REP_tit <- 'Estudio de la tasa de compensación de las novedades extemporáneas'
REP_seg <- switch( parametros$seguro,
                   'CE' = 'tasa de compensación de las novedades extemporáneas') 

paste( 'Seguro', parametros$seguro )
REP_fec_fin <- format( parametros$fec_fin, '%Y-%m-%d' )
REP_fec_val <- format( ymd( '2020-10-19' ), '%Y-%m-%d' )
REP_watermark <- paste0( 'Borrador ', parametros$fec_eje, ' ', format( Sys.time(), '%H:%M:%S' ) )
REP_version <- digest( paste0( 'IESSDAIE', format( Sys.time(), '%Y%m%d%H' ) ), algo = 'sha256', file = FALSE )

# Copia de resultados  -----------------------------------------------------------------------------
REP_file_latex_org <- c( paste( parametros$work_dir, 'Reportes/bibliografia_libros.bib', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/bibliografia_articulos.bib', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/bibliografia_leyes.bib', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/style.tex', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/logo_iess_azul.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/caratula.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/caratula_v2.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/sumilla_actuario.png', sep = '' ),
                         paste( parametros$work_dir, 'Reportes/firma_actuario.png', sep = '' ))

REP_file_latex_des <- c( paste( REP_rep_dir, 'bibliografia_libros.bib', sep = '' ), 
                         paste( REP_rep_dir, 'bibliografia_articulos.bib', sep = '' ),
                         paste( REP_rep_dir, 'bibliografia_leyes.bib', sep = '' ),
                         paste( REP_rep_dir, 'style.tex', sep = '' ),
                         paste( REP_rep_dir, 'graficos/logo_iess_azul.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/caratula.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/caratula_v2.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/sumilla_actuario.png', sep = '' ),
                         paste( REP_rep_dir, 'graficos/firma_actuario.png', sep = '' ))

REP_file_latex_clean <- c( paste( REP_rep_dir, 'bibliografia_libros.bib', sep = '' ), 
                           paste( REP_rep_dir, 'bibliografia_articulos.bib', sep = '' ),
                           paste( REP_rep_dir, 'bibliografia_leyes.bib', sep = '' ),
                           paste( REP_rep_dir, 'style.tex', sep = '' ),
                           paste( REP_rep_dir, 'graficos/logo_iess_azul.png', sep = '' ),
                           paste( REP_rep_dir, 'graficos/sumilla_actuario.png', sep = '' ),
                           paste( REP_rep_dir, 'graficos/firma_actuario.png', sep = '' ) )

file.copy( REP_file_latex_org, REP_file_latex_des, overwrite = TRUE  )

# Compilación reporte ------------------------------------------------------------------------------
message('\tInicio compilación')

# Genera información automática --------------------------------------------------------------------
source( paste0( parametros$reporte_seguro, 'auto_informacion.R' ), encoding = 'UTF-8', echo = FALSE )

# Kniting reporte ----------------------------------------------------------------------------------
setwd( parametros$reporte_seguro ) 
knit( input = "reporte.Rnw", 
      output = paste0( REP_rep_dir, REP_rep_latex ),
      quiet = REP_knit_quiet, encoding = 'utf8' )

# Compilacion LaTeX --------------------------------------------------------------------------------
message('\tInicio compilación LaTeX')
setwd( REP_rep_dir )
tools::texi2pdf( REP_rep_latex, quiet = REP_latex_quiet, clean = REP_latex_clean )  
setwd( parametros$work_dir )
message('\tFin compilación LaTeX')

if( REP_latex_aux_clean ) {
  unlink( REP_file_latex_clean, recursive = TRUE )
}

#Limpiar RAM----------------------------------------------------------------------------------------
message( paste( rep( '-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
