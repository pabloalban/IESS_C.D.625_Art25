# Preparación---------------------------------------------------------------------------------------
source( 'R/400_preparar_reporte.R', encoding = 'UTF-8', echo = FALSE )

#Lectura--------------------------------------------------------------------------------------------
# source( 'R/106_lectura_demandantes_HO.R', encoding = 'UTF-8', echo = FALSE )

#Calculos-------------------------------------------------------------------------------------------
# source( 'R/201_actualizacion_sueldo_HO.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/303_calculo_liquidaciones_HO.R', encoding = 'UTF-8', echo = FALSE )

# Tablas -----------------------------------------------------------------------------------------
# source( 'R/501_tab_listado_beneficiarios_HO.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/502_listado_individual_liquidaciones_HO.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/504_tab_actualizacion_ultimo_sueldo_HO.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/505_lista_nombres.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/506_lista_fecha_cese.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/507_lista_ultimo_sueldo.R', encoding = 'UTF-8', echo = FALSE )
# source( 'R/508_lista_cedula.R', encoding = 'UTF-8', echo = FALSE )

#Tabla excel ---------------------------------------------------------------------------------------
# source( 'R/601_tablas_excel.R', encoding = 'UTF-8', echo = FALSE )

# Reporte LaTeX-------------------------------------------------------------------------------------
source( parametros$reporte_script, encoding = 'UTF-8', echo = FALSE )

# Reportes excel------------------------------------------------------------------------------------
#source( 'R/ces/601_reporte_balance_ces.R', encoding = 'UTF-8', echo = FALSE )