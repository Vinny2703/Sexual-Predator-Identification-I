library("dplyr")
library("xml")
library("tidyr")
library("methods")
library("stringr")
library("readr")
library("data.tree")
library("base")

#Dateneinlesen
#Bereinigter orginal Trainingscorpus
tc_o<-xmlParse(file="tc_o.xml")
rootnode_tc_o <-xmlRoot(tc_o)
rootsize(rootnode_tc_o)
#Bereinigter eigener Trainingscorpus
tc_e<-xmlParse(file="tc_e.xml")
rootnode_tc_e <-xmlRoot(tc_e)
rootsize(rootnode_tc_e)

#Bereinigter orginal Testcorpus
tec_o<-xmlParse(file="tec_o.xml")
rootnode_tec_o <-xmlRoot(tec_o)
rootsize(rootnode_tec_o)
#Bereinigter eigener Testcorpus
tec_e<-xmlParse(file="tc_e.xml")
rootnode_tc_e <-xmlRoot(tc_e)
rootsize(rootnode_tc_e)

#Labeldateien einlesen
sexualpredetor_tc <- read.table("C:/Users/Mama/Desktop/softwareProjekt/pan12-sexual-predator-identification-training-corpus-predators-2012-05-01.txt")
print(sexualpredetor_tc)
sexualpredetor_tec<- read.table("")


#Feature-Funktionen 
startetconversation <- function(doc,wert){
  autorID<-toString(xpathApply(doc,paste0("//conversation[position()='",wert,"']/message[1]/author"),xmlValue))
return(autorID)
}


spamfilter <- function(wert, doc) {
  nr <- wert
  while (nr < length(xpathApply(doc, "//conversation", xmlAttrs))+1) {
    b <- 1
    j <- 0
    n1 <- 0
    n2 <- 0
    q1 <- 0
    q2 <- 0
    messagelist <- list()
    auth <- 1
    aut_ID <- toString(xpathApply(doc, paste0("//conversation[position()='",nr,"']/message[1]/author[1]"), xmlValue))
    autor1 <- aut_ID
    while (auth < length(xpathApply(doc, paste0("//conversation[position()='",nr,"']/message/author"), xmlAttrs))+1) {
      aut_ID2 <- toString(xpathApply(doc, paste0("//conversation[position()='",nr,"']/message[position()='",b,"']/author[1]"), xmlValue))
      if(aut_ID2%in%aut_ID){
        j <- j+1
        aut_ID <- toString(xpathApply(doc, paste0("//conversation[position()='",nr,"']/message[position()='",b,"']/author[1]"), xmlValue))
        length(messagelist) <- length(messagelist)+1
        messagelist[length(messagelist)]<-toString(xpathApply(doc, paste0("//conversation[position()='",nr,"']/message[position()='",b,"']/text[1]"), xmlValue))
        b <- b+1
        q <- 0
        if(j >= 3){
          if("?"%in%messagelist){
            q <- q+1
          }
          else if(" fm"%in%messagelist){
            q <- q+1
          }
          else if(" mf"%in%messagelist){
            q <- q+1
          }
          else if(" where "%in%messagelist){
            q <- q+1
          }
          else if(" what "%in%messagelist){
            q <- q+1
          }
          else if(" why "%in%messagelist){
            q <- q+1
          }
          else if(" how "%in%messagelist){
            q <- q+1
          }
          else if(" who "%in%messagelist){
            q <- q+1
          }
          if(autor1 == aut_ID){
            n1 <- n1+1
            q1 <- q1+q
          } else {
            autor2 <- autID
            n2 <- n2+1
            q2 <- q2+q
          }
        }
      } else {
        j <- 0
        messagelist <- list()
      }
      auth <- auth+1
    }
    r_autor1 <- q1/n1
    r_autor2 <- q2/n2
    print(nr)
    nr <- nr+1
  }
  autor <- c(autor1, autor2)
  ergebnis <- c(r_autor1,r_autor2)
  df <- data.frame(autor, ergebnis)
  return(df)
}


#Liste mit Conversationen
#Funktion für erstellen der Listen
conversationliste<-function(doc){
  con_l<-c()
  for(c in 1:length(xpathApply(doc, "//conversation", xmlAttrs))){
    conID <- toString(xpathApply(doc, paste0("//conversation[position()='",c,"']"), xmlAttrs))
    if((conID %in% con_l) == FALSE){
      length(con_l) <- length(con_l)+1
      con_l[length(con_l)]<-conID
    }
  }
  return(con_l)
}
#Funktion zum erstellen einer Autorenliste
autorenListe <- function(wert,doc){ 
  aliste <- list()
  i <- wert
  m<- 1
  while(m < length(xpathApply(doc, paste0("//conversation[position()='",i,"']/message"), xmlAttrs))+1){
    autorID <- toString(xpathApply(doc, paste0("//conversation[position()='",i,"']/message[position()='",m,"']/author"), xmlValue))
    if((autorID %in% aliste) == FALSE){
      length(aliste) <- length(aliste)+1
      aliste[length(aliste)]<-autorID
    }
  }
  return(aliste)
}
#Listen der Conversationen in Corpa
conl_tc_o<-conversationliste(tc_o)
conl_tc_e<-conversationliste(tc_e)
conl_tec_o<-conversationliste(tec_o)
conl_tec_e<-conversationliste(tec_e)

#Featurextrator

featureExtrator<- funktion(doc,conversationl,label,featureDictionary){
 #Vectoren für die Initialisierung des leeren Feature Dictionary 
  autorID<-vector()
  CID<-vector()
  starts<-numeric()#1-gestartet 0-nicht gestartet
  spam<-numeric()
  l<-numeric()#1-sexualpredetor 0-kein sexualpredetor
  featureDictionary <-data.frame(autorID,CID,starts,spam,l)
for(i in 1:length(xpathApply(doc, "//conversation",xmlAttrs))){
  conversationID<-toString(xpathApply(doc, paste0("//conversation[position()='",i,"']"), xmlAttrs))
  #AutorID von Autor, der Konversation gestartet hat
  starter<- startetconversation(doc,i)
  #!!!!Spamfilter (nicht fuer originalen Korpus)!!!! 
  spamf <- spamfilter(i,doc)
  #
  for (m in 1:length(autorenListe(i,doc))) {
    aliste<-autorenListe(i,doc)
    autorID <-aliste[m]
  if(autorID%in%label){
    if(starter==autorID){
      autorID<-c(autorID)
      CID<- c(conversationID)
      starts<-c(1)
      spam<-c(spam) #<--- Hier müssen die richten Spamwerte (r_autor1 oder r_autor2) den richtigen autoren zugeordnet werden 
      l<-c(1)
      x<-data.frame(autorID,CID,starts,spam,l)
      featureDictionary<-rbind(featureDictionary,x)
    }
    else{
      autorID<-c(autorID)
      CID<- c(conversationID)
      starts<-c(0)
      spam<-numeric()
      l<-c(1)
      x<-data.frame(autorID,CID,starts,spam,l)
      featureDictionary<-rbind(featureDictionary,x)
  }
  }else{
    if(starter==autorID){
      autorID<-c(autorID)
      CID<- c(conversationID)
      starts<-c(1)
      spam<-numeric()
      l<-c(0)
      x<-data.frame(autorID,CID,starts,spam,l)
      featureDictionary<-rbind(featureDictionary,x)
    }
    else{
      autorID<-c(autorID)
      CID<- c(conversationID)
      starts<-c(0)
      spam<-numeric()
      l<-c(0)
      x<-data.frame(autorID,CID,starts,spam,l)
      featureDictionary<-rbind(featureDictionary,x)
    }
  }
}
} 
  return(featureDictionary)
  } 

#Featurextraktion
#Trainingsdaten orginal
featureT_tc_o <-featureExtrator(tc_o,conl_tc_o,sexualpredetor_tc,featureT_tc_o)
#Testdaten orginal
featureT_tec_o<-featureExtrator(tec_o,conl_tec_o,sexualpredetor_tec,featureT_tec_o)

#Trainingsdaten eigene
featureT_tc_e <-featureExtrator(tc_e,conl_tc_e,sexualpredetor_tc,featureT_tc_e)
#Testdaten eigene
featureT_tec_e<-featureExtrator(tec_e,conl_tec_e,sexualpredetor_tec,featureT_tec_e)
                