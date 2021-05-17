message(paste(rep("-", 100), collapse = ""))

message("\tCargando base de beneficiarios del Caso HOLCIM")
load(paste0(parametros$RData, "IESS_listado_beneficiarios.Rdata"))
load(paste0( parametros$RData, 'IESS_canasta_basica_familiar.RData'))

load(paste0( parametros$RData, 'IESS_ultimo_sueldo.RData'))

message("\tCalculando reliquidaciones de jubilados de los cementeros")
#Límite superior pago-------------------------------------------------------------------------------
beneficios <- beneficiarios %>%
  mutate(fecha_fin = as.character(fecha_fallecimiento) ) %>%
  mutate(fecha_fin = ifelse(is.na(fecha_fallecimiento), ("2010-09-30"),fecha_fin )) %>%
  mutate(fecha_fin = as.Date(fecha_fin,"%Y-%m-%d")) %>%
  mutate(fecha_fin = if_else(fecha_fin > as.Date("2010-09-30","%Y-%m-%d"),as.Date("2010-09-30","%Y-%m-%d"), fecha_fin )) %>%
  mutate(fecha_inicio = as.Date("2000-03-01","%Y-%m-%d") ) %>%
  mutate(fecha_inicio = if_else(ultima_planilla > as.Date("2000-03-01","%Y-%m-%d"),ultima_planilla, fecha_inicio )) %>%
  mutate(dif_meses = interval(fecha_inicio,fecha_fin) %/% months(1))  %>%
  mutate (id_ben = 1:n())

#Adjunto las Pensiones-------------------------------------------------------------------------------
beneficios <- beneficios %>%
  left_join(., pension, by='cedula') 

#Adjunto intereses-------------------------------------------------------------------------------
beneficios <- beneficios %>%
  mutate( i_p = 5.31/100 )

#Generación de la malla anual------------------------------------------------------------------------
beneficios_anual <- beneficios %>% 
  mutate( anio_ini = year(fecha_inicio), anio_fin = year(fecha_fin)) %>%
  mutate( dif_anios = anio_fin - anio_ini + 1 ) %>%
  slice(rep(1:n(),dif_anios)) %>%
  group_by(cedula) %>%
  mutate(contador = 1:n()) %>%
  mutate(anio_cal = contador + anio_ini - 1) %>%
  ungroup() %>%
  mutate( i = 2010 -  anio_cal) %>%
  arrange(id_ben, anio_cal ) %>%
  # mutate( meses_cal = ifelse( anio_cal == '2000', 12 - month(fecha_inicio) + 1, 12 ) ) %>%
  # mutate( meses_cal = ifelse( anio_cal == '2010', month(fecha_fin), 12 ) ) %>%
  mutate( meses_cal = if_else( anio_cal == anio_ini, 12 - month(fecha_inicio) + 1, 12 ) ) %>%
  mutate( meses_cal = if_else( anio_cal == anio_ini & anio_ini == year(fecha_fallecimiento) , month(fecha_fallecimiento) - month(fecha_inicio) + 1, meses_cal ) ) %>%
  mutate( meses_cal = if_else( anio_cal == anio_fin & anio_fin >= 2001, month(fecha_fin), meses_cal ) ) %>%
  mutate( meses_cal = if_else( anio_cal == anio_fin & anio_fin == year(fecha_fallecimiento) & anio_fin >= 2001, month(fecha_fallecimiento), meses_cal ) ) %>%
  mutate( meses_cal = ifelse( anio_cal == '2000' & is.na(meses_cal), 12 - month(fecha_inicio) + 1, meses_cal ) ) %>%
  mutate( meses_cal = ifelse( anio_cal == '2010' & is.na(meses_cal), month(fecha_fin), meses_cal ) ) %>%
  mutate( meses_cal = ifelse( anio_cal == '2007' & is.na(meses_cal), month(fecha_fin), meses_cal ) ) %>%
  mutate( meses_cal = ifelse( anio_cal == '2006' & is.na(meses_cal), month(fecha_fin), meses_cal ) ) %>%
  mutate( meses_cal = if_else( anio_cal == anio_ini & anio_cal > 2000, 12 - month(fecha_inicio) + 1, meses_cal ) ) %>%
  mutate( pension_anual = meses_cal * pension ) %>%
  mutate( interes =  pension_anual * ( i_p * i ) ) %>%
  mutate( liquidacion = pension_anual + interes) %>%
  select( id_ben, cedula, apellidos_y_nombres, fecha_fallecimiento , fecha_inicio, fecha_fin, ultimo_sueldo_nominal,
        anio_cal, meses_cal, i, pension, pension_anual,
        interes, liquidacion)

# sum(beneficios_anual$pension_anual)
# sum(beneficios_anual$interes)
# sum(beneficios_anual$liquidacion)
#Lista de liquidaciones individual------------------------------------------------------------------
lista_ben <- beneficios_anual %>%
  group_by(cedula) %>%
  mutate( pension_anual = sum(pension_anual, na.rm = TRUE),
          interes = sum(interes, na.rm = TRUE ),
          liquidacion = sum( liquidacion, na.rm = TRUE ) ) %>%
  ungroup() %>%
  distinct(cedula, .keep_all = TRUE) %>%
  select( id_ben, cedula, apellidos_y_nombres,  fecha_inicio, fecha_fin, fecha_fallecimiento,
          ultimo_sueldo_nominal, pension, pension_anual, interes, liquidacion)


#Guardar en un RData--------------------------------------------------------------------------------
message( '\tGuardando liquidaciones a jubilados' )

save( beneficios_anual,
      lista_ben,
      file = paste0( parametros$RData, 'IESS_liquidaciones.RData' ) )

# Borrar elementos restantes -----------------------------------------------------------------------
message(paste(rep("-", 100), collapse = ""))
rm(list = ls()[!(ls() %in% c("parametros"))])
gc()