# Creación estructura reporte ----------------------------------------------------------------------
if ( dir.exists( parametros$resultado_seguro ) ) {
  unlink( parametros$resultado_tablas, recursive = TRUE, force = TRUE )
  unlink( parametros$resultado_graficos, recursive = TRUE, force = TRUE )
  unlink( parametros$resultado_seguro, recursive = TRUE, force = TRUE )
} 
dir.create( parametros$resultado_seguro )
dir.create( parametros$resultado_tablas )
dir.create( parametros$resultado_graficos )
