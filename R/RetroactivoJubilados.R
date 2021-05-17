library(tidyverse)
library(dplyr)
library(lubridate)
############################Carga de información###################
data <- (read.table( paste0( parametros$Data, 'Cementeros2.csv' ),
                     skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA",
                    encoding="UTF-8", 
                    colClasses = c("factor",
                                   "integer",
                                   "factor",
                                   "character",
                                   "factor",
                                   "character",
                                   "character",
                                   "factor",
                                   "factor",
                                   "integer",
                                   "factor",
                                   "factor",
                                   "factor",
                                   "factor",
                                   "numeric",
                                   "factor",
                                   "character",
                                   "numeric",
                                   "numeric",
                                   "integer",
                                   "integer",
                                   "character",
                                   "integer",
                                   "factor",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "integer",
                                   "integer",
                                   "character",
                                   "integer",
                                   "integer",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "integer",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "numeric",
                                   "numeric","numeric","numeric")))
data$cedula<-as.character(data$cedula)
#data[which(nchar(data$cedula)==9),]$cedula<-paste0(0,data[which(nchar(data$cedula)==9),]$cedula)

data$fecha_nacimiento<-as.Date(data$fecha_nacimiento,"%d/%m/%Y")
#classes <- sapply(data, class)
Coeficientes<-(read.table( paste0( parametros$Data, 'Coeficientes.csv' ),
                          skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA"))
CoefPenMaxMin <- (read.table(paste0( parametros$Data, 'CoeficientesPensionMaxMin.csv'),
                             skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA"))
SBU<-(read.table(paste0( parametros$Data, 'SBU.csv'),
                            skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA"))
#TablaBiom<-(read.table("TablasVMLogaritmica.csv",skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA",
TablaBiom<-(read.table(paste0( parametros$Data, 'TablasVejezNelson.csv'),
                       skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA",
                       colClasses = c("integer",
                                      "character",
                                      "numeric",
                                      "numeric")))

#data[which(data$sexo=="MASCULINO"),]$sexo<-"Hombre"
#data[which(data$sexo=="FEMENINO"),]$sexo<-"Mujer"
data$FechaJubilacion<-as.Date(data$FechaJubilacion, format="%d/%m/%Y")

RentaJubilados <- (read.table(paste0( parametros$Data, 'RentaIVMJubilados.csv'),
                              skip=0,dec = ",",header = TRUE,sep = ";",na.strings = "NA",
                    colClasses = c("character",
                                   "integer",
                                   "integer",
                                   "character",
                                   "numeric")))
RentaJubilados$Fechaderecho<-as.Date((RentaJubilados$Fechaderecho), format="%Y/%m/%d")

################################################
load(paste0( parametros$RData, 'VivosSalarioCorregido.Rdata'))
load(paste0( parametros$RData, 'Canasta.RData'))
JV<-subset(Vivos,Tipo=="Jb")

aux<-dplyr::select(data,cedula,RIC)
JV<-subset(Vivos,Tipo=="Jb")
JV<-dplyr::select(JV,-RIC)
JV<-left_join(JV,aux,by='cedula')
JV[which(is.na(JV$RIC)),]$RIC<-JV[which(is.na(JV$RIC)),]$ultima_pension
JV$UltimoSueldo<-JV$Ultimo_Sueldo
Aux<-dplyr::select(JV,cedula,razon_social,
            CargoHomologado,
            Tipo,
            #ultima_pension,
            #Año300,
            Coeficiente,
            Prestaciones,
            UltimoSueldo,
            UltimoSueldo,RIC)
Aux["AñosAportes"]<-as.integer(Aux$Prestaciones/12)
Aux<-left_join(Aux,CoefPenMaxMin,by="AñosAportes")
Aux<-left_join(RentaJubilados,Aux,by="cedula")
Aux<-dplyr::select(Aux,cedula,CargoHomologado,razon_social,Tipo,Año,Mes,Fechaderecho,Coeficiente,MinimoPorcentaje,MaximoPorcentaje,RIC,RentaIVM,UltimoSueldo)
##########SBU por año###############
Aux<-left_join(Aux,SBU,by=c("Año"="Año"))
##################Pensiones máximas y mínimas########
Aux["PenMaxima"]<-Aux$SBU*Aux$MaximoPorcentaje
Aux["PenMinima"]<-Aux$SBU*Aux$MinimoPorcentaje
##################RIC IVM#####################
Aux["RICIVM"]<-Aux$RIC
Aux<-dplyr::select(Aux,-RIC)
############Diferencia de entre IVM y ultimo Sueldo############
Aux["RentaCemento"]<-pmax(Aux$UltimoSueldo-Aux$RIC,0)

############RIC################
Aux["RIC"]<-Aux$RICIVM+Aux$RentaCemento
#############Renta Concedida################
Aux["RentaConcedida"]<-Aux$RentaIVM+Aux$RentaCemento
################Pensión cementera con máximos y mínimos###########
Aux["RentaConcedidaMaximos"]<-pmin(pmax(Aux$RentaConcedida,Aux$PenMinima),Aux$PenMaxima)

############Diferencia de entre IVM y ultimo Sueldo############
Aux["RetroactivoPE"]<-pmax(Aux$RentaConcedida-Aux$RentaIVM,0)
################Pensión cementera con máximos y mínimos###########
Aux["RetroactivoPMax"]<-pmax(Aux$RentaConcedidaMaximos-Aux$RentaIVM,0)

############Diferencia de entre IVM y ultimo Sueldo############
Aux["RetroactivoPE13"]<-pmax(13*(Aux$RentaConcedida-Aux$RentaIVM)/12,0)
############Diferencia de entre IVM y ultimo Sueldo############
Aux["RetroactivoPMax13"]<-pmax(13*(Aux$RentaConcedidaMaximos-Aux$RentaIVM)/12,0)
Aux<-subset(Aux,CargoHomologado=="Operativo u Otros")
sum(Aux$RetroactivoPE)
sum(Aux$RetroactivoPMax)
sum(Aux$RetroactivoPE13)
sum(Aux$RetroactivoPMax13)

#write.table(Aux,file = "RetroActivosJubilados.csv",row.names = FALSE,dec = ",",sep = ";",fileEncoding = "UTF-8")
RetroactivosJV<-Aux
#############Impacto##################
ImpactoRetroActivo<-dplyr::select(Aux,
                  cedula,
                  CargoHomologado,
                  razon_social,
                  Tipo,
                  Año,
                  UltimoSueldo,
                  #RetroactivoCementero,
                  RetroactivoPE,
                  RetroactivoPMax,
                  RetroactivoPE13,
                  RetroactivoPMax13)


ImpactoRetroActivo<-ImpactoRetroActivo%>%group_by(cedula)%>%mutate(SRetroactivoPension=sum(RetroactivoPE))
ImpactoRetroActivo<-ImpactoRetroActivo%>%group_by(cedula)%>%mutate(SRetroactivoMaximos=sum(RetroactivoPMax))
ImpactoRetroActivo<-ImpactoRetroActivo%>%group_by(cedula)%>%mutate(SRetroactivoPE13=sum(RetroactivoPE13))
ImpactoRetroActivo<-ImpactoRetroActivo%>%group_by(cedula)%>%mutate(SRetroactivoPMax13=sum(RetroactivoPMax13))

ImpactoRetroActivo<-subset(ImpactoRetroActivo,!duplicated(cedula))

ImpactoRetroActivo<-dplyr::select(ImpactoRetroActivo,
                           -Año,
                           -UltimoSueldo,
                           -RetroactivoPE,
                           -RetroactivoPMax,
                           -RetroactivoPE13,
                           -RetroactivoPMax13)






#########Codificacion##########
#breaks <- quantile(B18$DiferenciaPensionAritmetica,seq(0,1,by=0.3))
#hist(Impacto$DifDolarPenCementera,breaks = 50,xlim = c(0,5000))
breaks<-c(-0.5,500,1000,3000,5000,10000,25000,100000,1881457)
labels = 1:(length(breaks)-1)
seg <- cut(ImpactoRetroActivo$SRetroactivoPension,breaks,
           #labels=labels,
           include.lowest = TRUE, right = TRUE,dig.lab = 10)
df = data.frame(vector=ImpactoRetroActivo$SRetroactivoPension,seg=seg)
ImpactoRetroActivo["CodSRetroactivoPension"]<-df$seg
######################################
breaks<-c(-0.5,500,1000,3000,5000,10000,25000,100000,1881457)
labels = 1:(length(breaks)-1)
seg <- cut(ImpactoRetroActivo$SRetroactivoMaximos,breaks,
           #labels=labels,
           include.lowest = TRUE, right = TRUE,dig.lab = 10)
df = data.frame(vector=ImpactoRetroActivo$SRetroactivoMaximos,seg=seg)
ImpactoRetroActivo["CodSRetroactivoMaximos"]<-df$seg

######################################
breaks<-c(-0.5,500,1000,3000,5000,10000,25000,100000,1881457)
labels = 1:(length(breaks)-1)
seg <- cut(ImpactoRetroActivo$SRetroactivoPE13,breaks,
           #labels=labels,
           include.lowest = TRUE, right = TRUE,dig.lab = 10)
df = data.frame(vector=ImpactoRetroActivo$SRetroactivoPE13,seg=seg)
ImpactoRetroActivo["CodSRetroactivoPE13"]<-df$seg

######################################
breaks<-c(-0.5,500,1000,3000,5000,10000,25000,100000,1881457)
labels = 1:(length(breaks)-1)
seg <- cut(ImpactoRetroActivo$SRetroactivoPMax13,breaks,
           #labels=labels,
           include.lowest = TRUE, right = TRUE,dig.lab = 10)
df = data.frame(vector=ImpactoRetroActivo$SRetroactivoPMax13,seg=seg)
ImpactoRetroActivo["CodSRetroactivoPMax13"]<-df$seg

ImpactoRetroActivo<-dplyr::select(ImpactoRetroActivo,cedula,razon_social,CargoHomologado,Tipo,SRetroactivoPE13,SRetroactivoPMax13,CodSRetroactivoPE13,CodSRetroactivoPMax13)



#Guardar en un RData--------------------------------------------------------------------------------
message( '\tGuardando Retroactivos a jubilados' )

save( ImpactoRetroActivo,
      RetroactivosJV,
      file = paste0( parametros$RData, 'IESS_Reliquidaciones_JV.RData' ) )

#write.table(ImpactoRetroActivo0,file = "ImpactoRetroActivoVivos.csv",row.names = FALSE,dec = ",",sep = ";",fileEncoding = "UTF-8")
