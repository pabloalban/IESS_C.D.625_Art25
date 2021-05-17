message( '\tEstableciendo información para la configuración del reporte' )

REP <- new.env()

cap_ini <- '11.007.889,78'

# load( paste0( parametros$RData, 'IESS_ultimo_sueldo', '.RData' ) )
# load( paste0( parametros$RData, 'IESS_liquidaciones', '.RData' ) )
# load( paste0( parametros$RData, 'IESS_listado_beneficiarios', '.RData' ) )
# 
# #Nombre y apellido de beneficiarios------------------------------------------------------------------
# ben <- lista_ben %>% 
#     #filter(id_ben == j) %>% 
#     select(apellidos_y_nombres)
# 
# textbf <- function(text) 
#   paste0("\\textbf{", text, "}")
# 
# LaTeXMacro <- function(macro, text) 
#   paste0("\\", macro, "{", text, "}")
# 
# 
#   rhs <- paste("ben_", 1:nrow(ben), "<-","'", ben$apellidos_y_nombres,"'", sep="")
#   eval(parse(text=rhs)) 
# 
# liquidacion <- format( sum(beneficios_anual$liquidacion),
#                                                     digits = 2, nsmall = 2, big.mark = '.',
#                                                     decimal.mark = ',', format = 'f' )
#                        
# intereses <- format( sum(beneficios_anual$interes),
#                        digits = 2, nsmall = 2, big.mark = '.',
#                        decimal.mark = ',', format = 'f' )                       
# 
# capital <- format( sum(beneficios_anual$pension_anual),
#                      digits = 2, nsmall = 2, big.mark = '.',
#                      decimal.mark = ',', format = 'f' )  