message( paste( rep('-', 100 ), collapse = '' ) )

message( '\tLectura del listado de beneficiarios' )

#Cargando información financiera--------------------------------------------------------------------
file <- paste0(parametros$Data, 'BCE_pib.xlsx' )
file_tasas <- paste0(parametros$Data, 'BCE_tasas_referenciales.xlsx' )
file_salarios <- paste0(parametros$Data, 'IESS_salarios_promedios.xlsx' )
file_inflacion <- paste0(parametros$Data, 'INEC_inflacion.xlsx' )
file_sbu <- paste0(parametros$Data, 'MDT_sbu.xlsx' )

#Cargar función tíldes a latex----------------------------------------------------------------------
source( 'R/503_tildes_a_latex.R', encoding = 'UTF-8', echo = FALSE )

#Listado de hipétesis-------------------------------------------------------------------------------
pib <- read_excel(file,
                          #sheet = 'Imposiciones_ÚltimoSueldo',
                          col_names = TRUE,
                          col_types = NULL,
                          na = "",
                          skip = 0) %>% clean_names() %>% select(-x3)

tasas <- read_excel(file_tasas,
                  #sheet = 'Imposiciones_ÚltimoSueldo',
                  col_names = TRUE,
                  col_types = NULL,
                  na = "",
                  skip = 0) %>% clean_names() %>% 
  select(-tasa_legal, -tasa_maxima_convencional, -mes)

salarios <- read_excel(file_salarios,
                  #sheet = 'Imposiciones_ÚltimoSueldo',
                  col_names = TRUE,
                  col_types = NULL,
                  na = "",
                  skip = 0) %>% clean_names() %>% 
  select(anio:= aniper, mesper, sal_prom:= promedio_sal_n_afi) %>%
  group_by(anio) %>%
  mutate( sal_prom = mean(sal_prom, na.rm = TRUE)) %>%
  ungroup() %>%
  distinct(anio, .keep_all = TRUE) %>%
  arrange(anio) %>%
  select( -mesper)

inflacion <- read_excel(file_inflacion,
                    #sheet = 'Imposiciones_ÚltimoSueldo',
                    col_names = TRUE,
                    col_types = NULL,
                    na = "",
                    skip = 0) %>% clean_names()

sbu <- read_excel(file_sbu,
                        #sheet = 'Imposiciones_ÚltimoSueldo',
                        col_names = TRUE,
                        col_types = NULL,
                        na = "",
                        skip = 0) %>% clean_names()

#Base de ajuste-------------------------------------------------------------------------------------
tasas_macro <- pib %>% 
  left_join(., tasas, by = "anio") %>%
  left_join(., inflacion, by = "anio") %>%
  left_join(., salarios, by = "anio") %>%
  left_join(., sbu, by = "anio")

#Guardando en un Rdata------------------------------------------------------------------------------
message( '\tGuardando tasas' )

save( tasas_macro,
      file = paste0( parametros$RData, 'IESS_tasas_macro.RData' ) )

#Borrando data.frames-------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% 'parametros' ) ]  )
gc()