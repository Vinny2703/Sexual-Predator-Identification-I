#packages
library("dplyr")
library("tidyr")
library("XML")
library("methods")
library(stringr)
library(readr)

#Corpuse einlesen
#Trainingscorpus
tc <- xmlParse(file = "C:/Users/sandr/OneDrive/Desktop/r/pan12-sexual-predator-identification-training-corpus-2012-05-01.xml")
rootnode_tc <- xmlRoot(tc)
rootsize_tc <- xmlSize(rootnode_tc)
print(rootsize_tc)
#Testcorpus
tec <- xmlParse(file = "pan12-sexual-predator-identification-test-corpus-2012-05-21.xml")
rootnode_tec <- xmlRoot(tec)

#Pfade in xml Dateien

#schaut ob ein Element in einer liste ist
elementListe <- function(liste,Wert){
  g=FALSE
  for (i in length(liste)){
    if(Wert == liste[i] ){
      g=TRUE
    }
  }
  return(g)
}

#Funktionen
#F?r orginal und eigenen Corpus
#Erzuegen einer Autorenliste
autorenListe <- function() xpathApply(corpus, "//message"){
  aliste <- list()
  for (m in xpathApply(corpus, "//message")){
    autor <- xpathApply(m, "./author")
    autorID <- xpathApply(m, "./author[1]")
    if(elementListe(aliste,autorID) == FALSE){
      aliste <- aliste + autorID
    }
  }
  return(aliste)
}

wenigerals5Nachrichten<-function(autorenListe, //message){
  #Z?hlliste
  mc<- rep(NA,lenght(autorenListe))
  for (mes in //messages) {
    autorennr <- //message/author[0]
    for (i in length(autorenListe)){
      if(autorennr == autorenListe[i]){
        mc[i]<- mc[i]+1
      }
    }
  }
  for (element in lenght(mc)){
    if (mc[element]<5){
      return(TRUE)
    }
  }
  return(FALSE)
}

#Symbolbilder entfernen
Symbolbilder<-function(doc){
  conv <- //conversation
  for(conve in conv){
    messages<- //messages
    for(m in messages){
      text <- //text[0]
      
    }
  }
}
#schauen ob zuwenig Autoen
zuwenigAutoren<-function(liste){
  if(length(liste)>= 1){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}

toLowerCase<- function(doc){
  conv <- //conversation
  for (con in conv){
    mess <- //messages
    for (m in mess){
      textelemente <- //text[0]
      textklein <- toLowerCase(textelemente)
      //text[0] <- textklein
    }
  }
  return(doc)
}

Abkuerzungen<-function(doc){
  conv <- //conversation
  for (c in conv) {
    mess<- //messages
    for (m in messages) {
      text<- //text[0]
      #Abk?rzungen ersetzen
      text <- str_replace(text,"\blmfao\b","laughing my ass off")
      text <- str_replace(text,"\bu\b","you")
      text <- str_replace(text,"\bafk\b","away from Keyboard")
      text <- str_replace(text,"\bpls\b","please")
      text <- str_replace(text,"\bplz\b","please")
      text <- str_replace(text,"\bbbl\b","be back later")
      text <- str_replace(text,"\bbbs\b","be back soon")
      text <- str_replace(text,"\bily\b","i love you")
      text <- str_replace(text,"\bw/\b","with")
      text <- str_replace(text,"\bppl\b","people")
      text <- str_replace(text,"\bthx\b","thanks")
      text <- str_replace(text,"\bthxs\b","thanks")
      text <- str_replace(text,"\bbfn\b","bye for now")
      text <- str_replace(text,"\bb4n\b","bye for now")
      text <- str_replace(text,"\bnp\b","no problem")
      text <- str_replace(text,"\bya\b","you")
      text <- str_replace(text,"\badn\b","any day now")
      text <- str_replace(text,"\bkewl\b","cool")
      text <- str_replace(text,"\brofl\b","rolling on the floor laughing")
      text <- str_replace(text,"\bdon't\b","do not")
      text <- str_replace(text,"\bhaven't\b","have not")
      text <- str_replace(text,"\bwe're\b","we are")
      text <- str_replace(text,"\bwe'll\b","we will")
      
      
      //text[0] <-text
    }
  }
}
#Emoticon W?rterbuch
emotdic <- function(){
  dic <- file("C:/Users/marle/Documents/softwareprojekt1/EmoticonIDfinal.txt", open = "r")
  line <- read_lines("EmoticonIDfinal.txt", skip = 0, n_max = -1L)
  line
  lines <- unlist(strsplit(line, split = '\t'))
  emot_val <- lines[seq(1,length(lines), 2)]
  emot_id <- lines[seq(2, length(lines), 2)]
  close(dic)
  emot_dict <- data.frame(emot_val, emot_id)
  return(emot_dict)
}
#F?r orginal Corpus

#schauen ob Conversation 5 oder mehr Autoren hat
mehrals5<-function(liste){
  if(length(liste)>= 5){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


#F?r eigenen corpus
#schauen ob Conversation 2 oder mehr Autoren hat
mehrals2<-function(liste){
  if(length(liste)>= 2){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


#trainingscorpus orginal
tc_o <- for (c in //conversation){
  if (mehrals5(autorenListe)== T){
    #kind l?schen
  }
  else if(zuwenigAutoren(autorenListe)==T){
    #kind l?schen
  }
  else if(wenigerals4Nachrichten(autorenListe, //message)){
    #kind l?schen
  }
}
tc_o <- Symbolbilder(tc_o)
tc_o <- toLowerCase(tc_o)
tc_o <- Abkuerzungen(tc_o)

#traingscorpus
tc1 <- for (c in //conversation){
  if (mehrals2(autorenListe)== T){
    #kind l?schen
  }
  else if(zuwenigAutoren(autorenListe)==T){
    #kind l?schen
  }
  else if(wenigerals4Nachrichten(autorenListe, //message)){
    #kind l?schen
  }
}
tc1 <- Symbolbilder(tc1)
tc1 <- toLowerCase(tc1)
tc1 <- Abkuerzungen(tc1)


