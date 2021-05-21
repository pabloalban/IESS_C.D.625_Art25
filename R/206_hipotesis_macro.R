message(paste(rep("-", 100), collapse = ""))

#Paquetes-------------------------------------------------------------------------------------------
require(tidyverse)
require(tidymodels)
require(data.table)
require(tidyposterior)
require(tsibble)  #tsibble for time series based on tidy principles
require(fable)  #for forecasting based on tidy principles
require(ggfortify)  #for plotting timeseries
#require(forecast)  #for forecast function
#require(tseries)
require(chron)
require(lubridate)
require(directlabels)
require(zoo)
require(lmtest)
#require(TTR)  #for smoothing the time series
require(MTS)
#require(vars)
#require(fUnitRoots)
require(lattice)
require(grid)

#---------------------------------------------------------------------------------------------------
message("\tCargando tasas macro")
load(paste0(parametros$RData, "IESS_tasas_macro.RData"))


#Filtrar base---------------------------------------------------------------------------------------
base_ajuste <- tasas_macro %>%
  dplyr::mutate( porc_pib = pib / Lag(pib)-1 ,
                 porc_sal = sal_prom / Lag(sal_prom) -1,
                 por_sbu = sbu / Lag(sbu) -1 ) %>%
  dplyr::filter(anio>2006) %>%
  dplyr::filter(anio<2021) %>%
  select( -pib, -sal_prom, -sbu, -anio)

#Pruebas de estacionaridad de Dicker-Fuller---------------------------------------------------------

# Main packages - problem: both have different functions VAR
## Testing for stationarity
### tseries - standard test adt.test
apply(base_ajuste, 2, adf.test)

tseries::adf.test(base_ajuste[which(!is.na(base_ajuste$porc_pib)),]$porc_pib, k = 2)
tseries::adf.test(base_ajuste[which(!is.na(base_ajuste$porc_sal)),]$porc_sal, k = 4)
tseries::adf.test(base_ajuste[which(!is.na(base_ajuste$por_sbu)),]$por_sbu, k = 4)


# Differencing the whole mts
stnry = diffM(base_ajuste,2) #difference operation on a vector of time series. Default order of differencing is 1.

aux <- na.omit(stnry)
# Retest
apply(aux, 2, tseries::adf.test)
plot.ts(stnry)

#Gráfico 
autoplot(ts(stnry,
            start = c(1980),
            frequency = 1)) +
  ggtitle("Time Series Plot of the stationary `EuStockMarkets' Time-Series")

#Identificación del modelo--------------------------------------------------------------------------

# Lag order identification
#We will use two different functions, from two different packages to identify the lag order for the VAR model. 
#Both functions are quite similar to each other but differ in the output they produce. vars::VAR is a more powerful and convinient function to identify the correct lag order. 
VARselect(aux[,1:6], 
          type = "none", #type of deterministic regressors to include. We use none becasue the time series was made stationary using differencing above. 
          lag.max = 1) #highest lag order


# Creating a VAR model with vars
var.a <- vars::VAR(aux[,1:5],
                   lag.max = 1, #highest lag order for lag length selection according to the choosen ic
                   ic = "AIC", #information criterion
                   type = "none") #type of deterministic regressors to include
summary(var.a)


var.a <- vars::SVAR(aux[,2:5]) #type of deterministic regressors to include
summary(var.a)

# Residual diagnostics
#serial.test function takes the VAR model as the input.  
vars::serial.test(var.a)


causality(var.a, #VAR model
          cause = c("porc_pib")) #cause variable. If not specified then first column of x is used. Multiple variables can be used. 


## Forecasting VAR models
fcast = predict(var.a, n.ahead = 40) # we forecast over a short horizon because beyond short horizon prediction becomes unreliable or uniform
par(mar = c(2.5,2.5,2.5,2.5))
plot(fcast)





#################
data("mts-examples", package="MTS")

da=read.table("C:/Users/AMD-PC/Documents/Tsay/m-dec15678-6111.txt",header=T)

x=log(da[1:600,2:6]+1)*100  ## compute log returns, in percentages
rtn=cbind(x$dec5,x$dec8)  ## select Decile 5 and 8.
tdx=c(1:612)/12+1961  ## create calendar time
require(MTS) ## loag MTS package
colnames(rtn) <- c("d5","d8")

MTSplot(rtn,tdx)
ccm(rtn,lag=6)
VMAorder(rtn,lag=2)
m1=VMA(rtn,q=1) ## Estimation
summary(m1)

r1=m1$residuals
mq(r1,adj=4)
m2=VMAe(rtn,q=1)

aux<-cbind(base_ajuste$tasa_activa, log(base_ajuste$porc_pib+1) )
colnames(aux)<- c("d5","d8")
ccm(aux,lag=6)
VMA(aux,q=1)

VARorder(aux)

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
