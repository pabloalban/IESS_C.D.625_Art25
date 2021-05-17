message(paste(rep("-", 100), collapse = ""))

message("\tCargando base de beneficiarios del Caso HOLCIM")
load(paste0(parametros$RData, "IESS_listado_beneficiarios.Rdata"))
load(paste0( parametros$RData, 'IESS_canasta_basica_familiar.RData'))
load(paste0( parametros$RData, 'IESS_var_ipc.RData'))
message("\tActualización del último sueldo")

#Ultimo salario antes dolarización------------------------------------------------------------------
ultimo_sueldo_pre_dolar <- beneficiarios %>%
  filter(ultima_planilla < as.Date("2000-01-01","%Y-%m-%d") ) %>%
  mutate( anio_actualizacion = 2000) %>%
  mutate (id_ben = 1:n()) %>%
  mutate( n = anio_actualizacion - anio_ultima_planilla + 1) %>%
  slice(rep(1:n(),n)) %>%
  group_by(cedula) %>%
  mutate(contador = 1:n()) %>%
  mutate(anio_cal = contador + anio_ultima_planilla - 1) %>%
  ungroup() %>%
  left_join( ., var_ipc, by = c('anio_cal'='anio')) %>%
  mutate( ultimo_sueldo_actualizado = ultimo_sueldo_nominal, ta = var_ipc ) %>%
  mutate(ta = if_else(anio_cal == anio_ultima_planilla, 1, ta + 1) ) %>%
  group_by(cedula) %>%
  mutate(ta = cumprod(ta)) %>%
  mutate(ultimo_sueldo_actualizado = ta * ultimo_sueldo_actualizado) %>%
  select(id_ben, cedula, anio_cal,  ultimo_sueldo_nominal, var_ipc, ultimo_sueldo_actualizado) %>%
  as_tibble()

n <- ultimo_sueldo_pre_dolar %>%
  distinct(cedula, .keep_all = TRUE)

n <- nrow(n)
#Ultimo salario después dolarización----------------------------------------------------------------
n2 <- beneficiarios %>% 
  filter(ultima_planilla > as.Date("2000-01-01","%Y-%m-%d") )

n2 <- nrow(n2)

ultimo_sueldo_pos_dolar <- beneficiarios %>% 
  filter(ultima_planilla > as.Date("2000-01-01","%Y-%m-%d") ) %>%
  mutate (id_ben = c((n + 1):(n+n2)) ) %>%
  select(id_ben, cedula, anio_cal:= anio_ultima_planilla, ultimo_sueldo_nominal,  ultimo_sueldo_actualizado:= ultimo_sueldo_nominal )

#Pension--------------------------------------------------------------------------------------------
aux_1 <- ultimo_sueldo_pre_dolar %>%
  filter(anio_cal == 2000) %>%
  select(cedula, pension := ultimo_sueldo_actualizado)

aux_2 <- ultimo_sueldo_pos_dolar %>%
  select(cedula, pension := ultimo_sueldo_actualizado)

pension <- rbind(aux_1, aux_2)

#Guardar en un RData--------------------------------------------------------------------------------
message( '\tGuardando ultimo sueldo' )

save( ultimo_sueldo_pre_dolar,
      ultimo_sueldo_pos_dolar,
      pension,
      file = paste0( parametros$RData, 'IESS_ultimo_sueldo.RData' ) )

# Borrar elementos restantes -----------------------------------------------------------------------
message(paste(rep("-", 100), collapse = ""))
rm(list = ls()[!(ls() %in% c("parametros"))])
gc()
