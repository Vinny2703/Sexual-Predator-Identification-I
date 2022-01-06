#packages
library("dplyr")
library("tidyr")
library("XML")
library("methods")
library("stringr")
library("readr")
library("data.tree")
library("base")

#Corpuse einlesen
#Testcorpus orginal
tc <- xmlParse(file = "tc.xml")
rootnode_tc <- xmlRoot(tc)
rootsize_tc <- xmlSize(rootnode_tc)
print(rootsize_tc)
#Testcorpus eigener
tc1 <- xmlParse(file = "tc1.xml")
rootnode_tc1 <- xmlRoot(tc1)
rootsize_tc1 <- xmlSize(rootnode_tc1)
print(rootsize_tc1)

#Liste mit Sexualpredetorn einlesen
sexualpredetor <- read.table("pan12-sexual-predator-identification-groundtruth-problem1.txt")
print(sexualpredetor)

#Autorenliste für alle Konversationen (Funktion)
autorenListe_C <- function(doc){ 
  aliste_c <- list()
  aliste_c <- xpathApply(doc, "/conversations/conversation/message[not(author = following-sibling::message/author)]/author", xmlValue)
  return(aliste_c)
}
#Sexualstraftäterzahl in Corpus feststellen
sexualpredetorAnzahl<-function(autoren,sexualpredetor){
  s<-0
  for(i in 1:length(sexualpredetor[[1]])){
    sexpred <- sexualpredetor[[i,1]]
    if ((sexpred %in% autoren) == TRUE){
      s<-s+1
    }
    print(i)
  }
  return(s)
}

#Autorenlisten erstellen
#orginal
a_tc<-autorenListe_C(tc)
#eigener
a_tc1<-autorenListe_C(tc1)

#gesamt Anzahl von Autoren
#orginal
an_tc<-length(a_tc)
an_tc
#eigener
an_tc1<-length(a_tc1)
#Anzahl von Sexualstraftätern
#orginal
s_tc<-sexualpredetorAnzahl(a_tc,sexualpredetor)
s_tc
#eigenen
s_tc1<-sexualpredetorAnzahl(a_tc1,sexualpredetor)
s_tc1

#Anzahl anderer Autoren
#orginal
aa_tc<-an_tc-s_tc
aa_tc
#eigener
aa_tc1<-an_tc1-s_tc1
aa_tc1
