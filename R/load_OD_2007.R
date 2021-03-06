# Aim: Read (.mdb) OD 2007 data


library(raster)

# od_zone <- shapefile("C:/Users/juanita82/Dropbox/Robin-SaoPaulo/SaoPaulo/Data/OD-2007/Mapas OD/ZONAS_od07.shp")
od_zone <- shapefile("Data/OD-2007/Mapas OD/ZONAS_od07.shp")
od_flow <- read.table("Data/OD-2007/OD_2007.txt", sep=",")
# od_flow <- read.table("D://data-2-irc/sao-paulo/Data/OD-2007/OD_2007.txt", sep=",")
colnames(od_flow) <- c("ZONA",  "MUNI_DOM",	"CO_DOM_X",	"CO_DOM_Y",	"ID_DOM",	"F_DOM",	"FE_DOM",	"DOM",	"CD_ENTRE",	"DATA",	"TIPO_DOM",	"NO_MORAD",	"TOT_FAM",	"ID_FAM",	"F_FAM",	"FE_FAM",	"FAMILIA",	"NO_MORAF",	"CONDMORA",	"QT_RADIO",	"QT_GEL1",	"QT_GEL2",	"QT_TVCOR",	"QT_FREEZ",	"QT_VIDEO",	"QT_BANHO",	"QT_MOTO",	"QT_AUTO",	"QT_ASPIR",	"QT_MLAVA",	"QT_EMPRE",	"QT_MICRO",	"QT_BICICLE",	"NAO_DCL_IT",	"CRITERIO_B",	"ANO_AUTO1",	"ANO_AUTO2",	"ANO_AUTO3",	"RENDA_FA",	"CD_RENFA",	"ID_PESS",	"F_PESS",	"FE_PESS",	"PESSOA",	"SIT_FAM",	"IDADE",	"SEXO",	"ESTUDA",	"GRAU_INS",	"CD_ATIVI",	"CO_REN_I",	"VL_REN_I",	"ZONA_ESC",	"MUNIESC",	"CO_ESC_X",	"CO_ESC_Y",	"TIPO_ESC",	"ZONATRA1",	"MUNITRA1",	"CO_TR1_X",	"CO_TR1_Y",	"TRAB1_RE",	"TRABEXT1",	"OCUP1",	"SETOR1",	"VINC1",	"ZONATRA2",	"MUNITRA2",	"CO_TR2_X",	"CO_TR2_Y",	"TRAB2_RE",	"TRABEXT2",	"OCUP2",	"SETOR2",	"VINC2",	"N_VIAG",	"FE_VIA",	"DIA_SEM",	"TOT_VIAG",	"ZONA_O",	"MUNI_O",	"CO_O_X",	"CO_O_Y",	"ZONA_D",	"MUNI_D",	"CO_D_X",	"CO_D_Y",	"ZONA_T1",	"MUNI_T1",	"CO_T1_X",	"CO_T1_Y",	"ZONA_T2",	"MUNI_T2",	"CO_T2_X",	"CO_T2_Y",	"ZONA_T3",	"MUNI_T3",	"CO_T3_X",	"CO_T3_Y",	"MOTIVO_O",	"MOTIVO_D",	"SERVIR_O",	"SERVIR_D",	"MODO1",	"MODO2",	"MODO3",	"MODO4",	"H_SAIDA",	"MIN_SAIDA",	"ANDA_O",	"H_CHEG",	"MIN_CHEG",	"ANDA_D",	"DURACAO",	"MODOPRIN",	"TIPOVG",	"PAG_VIAG",	"TP_ESAUTO",	"VL_EST",	"PE_BICI",	"TP_ESBICI",	"ID_ORDEM")

# generate distances
# dist(matrix(1:4, ncol = 2))
od_flow$Distance = sqrt((od_flow$CO_O_X - od_flow$CO_D_X)^2 + (od_flow$CO_O_Y - od_flow$CO_D_Y)^2)
hist(od_flow$Distance)


# reformat columns - our column - lower case
od_flow$day <- factor(od_flow$DIA_SEM)
# levels = c("0", Mon", "Tue", "Wed", "Thu", "Fri"))
summary(od_flow$day)
od_flow$mode <- factor(od_flow$MODO1)
summary(od_flow$mode)
levels(od_flow$mode) <- c(
  "Bus", # 01 – Ônibus Município S.Paulo
  "Bus", # 02 – Ônibus Outros Municípios
  "Bus", # 03 – Ônibus Metropolitano
  "Bus", # 04 - Ônibus Fretado
  "School Bus", # 05 - Escolar
  "Car", # 06 - Dirigindo Automóvel
  "Car", # 07 - Passageiro de Automóvel
  "Car", # 08 - Táxi
  "Minibus", # 09 – Microônibus/Van Município de S.Paulo
  "Minibus", # 10 – Microônibus/Van Outros Município
  "Minibus", # 11 – Microônibus/Van Metropolitano
  "Rail", # 12 - Metrô
  "Rail", # 13 - Trem
  "Other", # 14 - Moto
  "Bicycle", # 15 - Bicicleta
  "Walk", # 16 - A Pé
  "Other" # 17 - Outros
)
summary(od_flow$mode) # makes sense? Yes

# Are you studying? variable (to get only fundamental + ensino students)
od_flow$student <- factor(od_flow$ESTUDA)
summary(od_flow$student)
levels(od_flow$student) <- c(
  "No", # 01 – Não
  "Primary", # 2 - Creche/Pré-Escola
  "Fundam", # 3 - 1º Grau /Fundamental
  "Medio", # 4 - 2º Grau/Médio
  "Superior", # 5 – Superior/Universitário
  "Others" # 6 - Others
)

# How many in fundamental + medio (our sample)
sum(od_flow$student=="Fundam") + sum(od_flow$student=="Medio")

# Type of school
od_flow$type <- factor(od_flow$TIPO_ESC)
levels(od_flow$type) <- c(
  "State", # 1 - Pública
  "Private" # 2 - Particular
)

summary(od_flow$type)

od_flow$Mode_type = od_flow$mode
levels(od_flow$Mode_type) = c(
  "Public",
  "Public",
  "Private",
  "Public",
  "Public",
  "Other",
  "Active",
  "Active"
  )

od_flow$School_type = factor(od_flow$TIPO_ESC, labels = c("Public", "Private"))
summary(od_flow$School_type)
