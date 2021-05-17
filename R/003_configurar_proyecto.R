# Parámetros globales R ----------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tConfiguración global de R' )

options( scipen = 99 )
setNumericRounding( 2 )
options( stringsAsFactors = FALSE )

# Parámetros ---------------------------------------------------------------------------------------
message( '\tCreando entorno de parámetros' )

# Entorno con parámetros
parametros <- new.env()

# User name
parametros$user <- Sys.getenv( 'USER' )

parametros$fec_eje <- Sys.Date()

# Operating system name
parametros$opsys <- Sys.info()[[1]]

# Hostname
parametros$hostname <- Sys.info()[[4]]

#Servidor de datos
if ( parametros$hostname %in% c( 'huracan', 'tornado', 'lahar', 'empty', 'tifon','LEOVELEZ',
                                 'temu-Ubuntu', 'ava.local','DESKTOP-380U0P5', 'DESKTOP-N4VHK6P', 'HP-USER',
                                 'AIOUIOMTZ513L35') ) {
  # global Risko
  parametros$data_server <- '/mnt/data/IESS/IESS_estudio/'
  if ( parametros$hostname %in% c('LEOVELEZ') ){ # máquina samsung
    parametros$data_server <- 'Z:/IESS/IESS_estudio/'
  }
  if ( parametros$hostname %in% c('ava.local') ){ # máquina samsung
    parametros$data_server <- '/Volumes/data/IESS/IESS_estudio/'
  }
  if ( parametros$hostname %in% c('DESKTOP-380U0P5') ){ # máquina teletrabajo
    parametros$data_server <- paste0( getwd(), '/' )
  }
  if( parametros$hostname %in% c('DESKTOP-N4VHK6P') ){
    parametros$data_server <- paste0( getwd(), '/' )
  }
  if( parametros$hostname %in% c('HP-USER') ){
    parametros$data_server <- paste0( getwd(), '/' )
  }
  if( parametros$hostname %in% c('AIOUIOMTZ513L35') ){
    parametros$data_server <- paste0( getwd(), '/' )
  }
  else {
  # global: se necesita acceso a la red de la direccion actuarial para conectarse
  #parametros$data_server <- 'C:/Users/Jendry Toapanta/Downloads/RESPALDO/IESS_estudio/'
  }
}
# local
# parametros$data_server <- paste0( getwd(), '/' )


# Directorio de trabajo
parametros$work_dir <- paste0( getwd(), '/' )

# Setting Time Zone
parametros$time_zone <- "America/Guayaquil"

# Colores IESS
parametros$iess_blue <- rgb( 0, 63, 138, maxColorValue = 255 )
parametros$iess_green <- rgb( 0, 116, 53, maxColorValue = 255 )

# Calcular balance
# parametros$calcular_balance <- FALSE

parametros$mont_prop_afi <- 0.1275

# Direcciones globables  ---------------------------------------------------------------------------
message( '\tEstableciendo directorios globales' )
parametros$empresa <- 'IESS'

message( '\tConfiguración seguro' )
parametros$seguro <- 'NOV_EXT'
parametros$hacer_ana_dem <- FALSE
parametros$calcular_balance <- FALSE

# Configuraciones particulares por seguro ----------------------------------------------------------
parametros$fec_fin <- ymd( '2010-09-30' )
parametros$fec_ini <- ymd( '2000-03-31' )
parametros$anio_ini <- 2000
parametros$mes_ini <- 2000
parametros$anio_fin <- 2010
parametros$mes_fin <- 2010
parametros$tasa_interes <- 0.0531
parametros$anio <- 2020 # Año del estudio
parametros$edad_max <- 105

# Incluir casos según corresponda
  parametros$horizonte <- 25 # en años
  parametros$cal_add_esc <- FALSE

# Variables automáticas ----------------------------------------------------------------------------
parametros$RData <- paste0( parametros$data_server, 'RData/' )
parametros$Data <- paste0( parametros$data_server, 'Data/' )

parametros$reportes <- paste0( parametros$work_dir, 'Reportes/' )
parametros$resultados <- paste0( parametros$work_dir, 'Resultados/' )
parametros$reporte_seguro <- paste0( parametros$work_dir, 'Reportes/Reporte_', 
                                     parametros$seguro, '/' )
#Calculo del balace---------------------------------------------------------------------------------
  # parametros$calculo_balance <- paste0( parametros$work_dir, 'R/ivm/303_calculo_escenarios_balance_ivm.R' )
  # parametros$reporte_genera <- paste0( parametros$work_dir, 'R/ivm/600_reporte_latex_ivm.R' )

parametros$reporte_script <- paste0( parametros$reporte_seguro, 'reporte.R' )
parametros$reporte_nombre <- paste0( parametros$empresa, '_',
                                     parametros$seguro, '_estudio' )
parametros$reporte_latex <- paste0( parametros$reporte_nombre, '.tex' )
parametros$resultado_seguro <- paste0( parametros$resultados, parametros$reporte_nombre, '_',
                                       format( parametros$fec_eje, '%Y_%m_%d' ), '/' )
parametros$resultado_tablas <- paste0( parametros$resultados, parametros$reporte_nombre, '_',
                                       format( parametros$fec_eje, '%Y_%m_%d' ), '/tablas/' )
parametros$resultado_graficos <- paste0( parametros$resultados, parametros$reporte_nombre, '_',
                                         format( parametros$fec_eje, '%Y_%m_%d' ), '/graficos/' )

parametros$graf_modelo_1 <- 'R/401_graf_plantilla.R'
parametros$graf_ext <- '.png'

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()
