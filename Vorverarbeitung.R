#packages
library("dplyr")
library("tidyr")
library("XML")
library("methods")
library("stringr")
library("readr")
library("data.tree")
library("base")
library("xml2")

#Corpuse einlesen
#Trainingscorpus
tc <- xmlParse(file = "C:/Users/marle/Documents/softwareprojekt1/pan12-sexual-predator-identification-training-corpus-2012-05-01.xml")
rootnode_tc <- xmlRoot(tc)
rootsize_tc <- xmlSize(rootnode_tc)
print(rootsize_tc)
#Testcorpus
tec <- xmlParse(file = "pan12-sexual-predator-identification-test-corpus-2012-05-21.xml")
rootnode_tec <- xmlRoot(tec)


#Funktionen
#F?r orginal und eigenen Corpus
#Erzuegen einer Autorenliste
autorenListe <- function(wert,doc){ 
aliste <- list()
aliste <- xpathApply(doc, paste0("//conversation[position()='",wert,"']/message[not(author = following-sibling::message/author)]/author"), xmlValue)
return(aliste)
}

wenigerals5Nachrichten<-function(wert,liste,doc){
  for(i in 1:length(liste)){
    if(xmlSize(xpathApply(doc, paste0("//conversation[position()='",wert,"']/message[author='",liste[i],"']"))) < 5){
      return(TRUE)
    }else{
      return(FALSE)
    }
   }
}

#Symbolbilder entfernen
epsilon <- 1e-6
Symbolbilder<-function(doc){
  conv <- length(xpathApply(doc, "//conversation",xmlAttrs))
  for(conve in 1:conv) {
    messages<- strtoi(xpathApply(doc, paste0("//conversation[position()='",conve,"']/message[last()]"),xmlAttrs))
    for(m in 1:messages){
      print(m)
      tokencount <- 0
      symbolcount <- 0
      text <- toString(xpathApply(doc, paste0("//conversation[position()='",conve,"']/message[position()='",m,"']/text[1]"),xmlValue))
      linesnum <- unlist(strsplit(text, split = '\n'))
      if(length(linesnum) > 5) {
        symbole <- tokenize_characters(text)
        for (s in 1:length(symbole[[1]])) {
          tokencount <- tokencount+1
          if(symbole[[1]][s]== "."){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == ","){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == ":"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == ";"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "-"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "_"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "!"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "Â§"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "$"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "%"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "&"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "/"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "("){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == ")"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "="){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "?"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "`"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "Â´"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "*"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "+"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "~"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == ">"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "<"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "|"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "{"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "["){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "]"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "}"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "^"){
            symbolcount <- symbolcount+1
          }
          else if(symbole[[1]][s] == "Â°"){
            symbolcount <- symbolcount+1
          }
          anteilSym <- (symbolcount/(tokencount+epsilon))
          if(anteilSym > 0.45){
            xml_remove(xpathApply(tc, paste0("//conversation[position()='",conve,"']/message[position()='",m,"']/text[1]")), free = TRUE)
          }
        }
      }
    }
  }
  return(doc)
}


#schauen ob zuwenig Autoen
zuwenigAutoren<-function(liste){
  if(length(liste)> 1){
    return(FALSE)
  }
  else{
    return(TRUE)
  }
}

toLowerCase<- function(doc){
  conv <- length(xpathApply(doc, "//conversation",xmlAttrs))
  for (con in 1:conv){
    mess <- strtoi(xpathApply(doc, paste0("//conversation[position()='",con,"']/message[last()]"),xmlAttrs))
    for (m in 1:mess){
      textelemente <- xpathApply(doc, paste0("//conversation[position()='",con,"']/message[position()='",m,"']/text[1]"),xmlValue)
      nodes <- getNodeSet(doc, paste0("//conversation[position()='",con,"']/message[position()='",m,"']/text[1]"))
      sapply(nodes, function(G){
        xmlValue(G) <- gsub("[^A-Za-z0-9~!@#$%^&§|???*(){}_+:\"<>?,./;'[]-=`´]"," ", tolower(textelemente))
      })
    }
  }
  return(doc)
}

Abkuerzungen<-function(doc){
  conv <- length(xpathApply(doc, "//conversation",xmlValue))
  for (c in 1:conv) {
    mess<- strtoi(xpathApply(doc, paste0("//conversation[position()='",c,"']/message[last()]"),xmlAttrs))
    for (m in 1:mess) {
      text <- xpathApply(doc, paste0("//conversation[position()='",c,"']/message[position()='",m,"']/text[1]"),xmlValue)
      nodes <- getNodeSet(doc, paste0("//conversation[position()='",c,"']/message[position()='",m,"']/text[1]"))
                          sapply(nodes, function(G){
                            xmlValue(G) <- gsub("m or f","male or female",text)
                            xmlValue(G) <- gsub(" lmfao ","laughing my ass off",text)
                            xmlValue(G) <- gsub(" u ","you",text)
                            xmlValue(G) <- gsub(" afk ","away from Keyboard",text)
                            xmlValue(G) <- gsub(" pls ","please",text)
                            xmlValue(G) <- gsub(" plz ","please",text)
                            xmlValue(G) <- gsub(" bbl ","be back later",text)
                            xmlValue(G) <- gsub(" bbs ","be back soon",text)
                            xmlValue(G) <- gsub(" ily ","i love you",text)
                            xmlValue(G) <- gsub(" w/ ","with",text)
                            xmlValue(G) <- gsub(" ppl ","people",text)
                            xmlValue(G) <- gsub(" thx ","thanks",text)
                            xmlValue(G) <- gsub(" thxs ","thanks",text)
                            xmlValue(G) <- gsub(" bfn ","bye for now",text)
                            xmlValue(G) <- gsub(" b4n ","bye for now",text)
                            xmlValue(G) <- gsub(" np ","no problem",text)
                            xmlValue(G) <- gsub(" ya ","you",text)
                            xmlValue(G) <- gsub(" adn ","any day now",text)
                            xmlValue(G) <- gsub(" kewl ","cool",text)
                            xmlValue(G) <- gsub(" rofl ","rolling on the floor laughing",text)
                            xmlValue(G) <- gsub(" don't ","do not",text)
                            xmlValue(G) <- gsub(" haven't ","have not",text)
                            xmlValue(G) <- gsub(" we're ","we are",text)
                            xmlValue(G) <- gsub(" we'll ","we will",text)
                            xmlValue(G) <- gsub(" i've ","i have",text)
                            xmlValue(G) <- gsub(" i'll ","i will",text)
                            xmlValue(G) <- gsub(" i'd ","i would",text)
                            xmlValue(G) <- gsub(" i'm ","i am",text)
                            xmlValue(G) <- gsub(" m ","male",text)
                            xmlValue(G) <- gsub(" f ","female",text)
                            xmlValue(G) <- gsub(" ons ","one night stand",text)
                            xmlValue(G) <- gsub(" g2g ","got to go",text)
                            xmlValue(G) <- gsub(" diya ","dildo in your ass",text)
                            xmlValue(G) <- gsub(" lol ","laughing out loud",text)
                            xmlValue(G) <- gsub(" bf ","boyfriend",text)
                            xmlValue(G) <- gsub(" gf ","girlfriend",text)
                            xmlValue(G) <- gsub(" rpg ","role playing games",text)
                            xmlValue(G) <- gsub(" it's ","it is",text)
                            xmlValue(G) <- gsub(" it's been ","it has been",text)
                            xmlValue(G) <- gsub(" isn't ","is not",text)
                            xmlValue(G) <- gsub(" 1st ","first",text)
                            xmlValue(G) <- gsub(" n ","and",text)
                            xmlValue(G) <- gsub(" that's ","that is",text)
                            xmlValue(G) <- gsub(" sry ","sorry",text)
                            xmlValue(G) <- gsub(" bcuz ","because",text)
                            xmlValue(G) <- gsub(" afaik ","as far as i know",text)
                            xmlValue(G) <- gsub(" bak ","back at keyboard",text)
                            xmlValue(G) <- gsub(" nd ","and",text)
                            xmlValue(G) <- gsub(" cya ","see you",text)
                            xmlValue(G) <- gsub(" ttyl ","talk to you later",text)
                            xmlValue(G) <- gsub(" bc ","because",text)
                            xmlValue(G) <- gsub(" fav ","favourite",text)
                            xmlValue(G) <- gsub(" wtf ","what the fuck",text)
                            xmlValue(G) <- gsub(" omg ","oh my god",text)
                            xmlValue(G) <- gsub(" can't ","can not",text)
                            xmlValue(G) <- gsub(" shouldn't ","should not",text)
                            xmlValue(G) <- gsub(" couldn't ","could not",text)
                            xmlValue(G) <- gsub(" couldnt ","could not",text)
                            xmlValue(G) <- gsub(" wouldnt ","would not",text)
                            xmlValue(G) <- gsub(" urs ","yours",text)
                            xmlValue(G) <- gsub(" omfg ","oh my fucking god",text)
                            xmlValue(G) <- gsub(" puter ","computer",text)
                            xmlValue(G) <- gsub(" how're ","how are",text)
                            xmlValue(G) <- gsub(" asap ","as soon as possible",text)
                            xmlValue(G) <- gsub(" brb ","be right back",text)
                            xmlValue(G) <- gsub(" brt ","be right there",text)
                            xmlValue(G) <- gsub(" idc ","i do not care",text)
                            xmlValue(G) <- gsub(" idk ","i do not know",text)
                            xmlValue(G) <- gsub(" gfn ","gone for now",text)
                            xmlValue(G) <- gsub(" k ","okay",text)
                            xmlValue(G) <- gsub(" btw ","by the way",text)
                            xmlValue(G) <- gsub(" r ","are",text)
                            xmlValue(G) <- gsub(" b  or  g ","boy or girl",text)
                            xmlValue(G) <- gsub(" b  or a  g ","boy or a girl",text)
                            xmlValue(G) <- gsub(" m/f ","male or female",text)
                            xmlValue(G) <- gsub(" g ","girl",text)
                            xmlValue(G) <- gsub(" bta ","but then again",text)
                            xmlValue(G) <- gsub(" luv ","love",text)
                            xmlValue(G) <- gsub(" you're ","you are",text)
                            xmlValue(G) <- gsub(" you'll ","you will",text)
                            xmlValue(G) <- gsub(" you'd ","you would",text)
                            xmlValue(G) <- gsub(" 4ever ","forever",text)
                            xmlValue(G) <- gsub(" b4 ","before",text)
                            xmlValue(G) <- gsub(" cwyl ","chat with you later",text)
                            xmlValue(G) <- gsub(" fyi ","for your information",text)
                            xmlValue(G) <- gsub(" bg ","big grin",text)
                            xmlValue(G) <- gsub(" he's ","he is",text)
                            xmlValue(G) <- gsub(" she's ","she is",text)
                            xmlValue(G) <- gsub(" wuz ","was",text)
                            xmlValue(G) <- gsub(" alol ","actually laughing out loud",text)
                            xmlValue(G) <- gsub(" asl ","age, sex and location",text)
                            xmlValue(G) <- gsub(" nite ","night",text)
                            xmlValue(G) <- gsub(" ur ","your",text)
                            xmlValue(G) <- gsub(" atk ","at the keyboard",text)
                            xmlValue(G) <- gsub(" ani ","age not important",text)
                            xmlValue(G) <- gsub(" l8r ","later",text)
                            xmlValue(G) <- gsub(" cul8r ","see you later",text)
                            xmlValue(G) <- gsub(" aight ","alright",text)
                            xmlValue(G) <- gsub(" jk ","just kidding",text)
                            xmlValue(G) <- gsub(" he'll ","he will",text)
                            xmlValue(G) <- gsub(" she'll ","she will",text)
                            xmlValue(G) <- gsub(" wb ","welcome back",text)
                            xmlValue(G) <- gsub(" tbh ","to be honest",text)
                            xmlValue(G) <- gsub(" atm ","at the moment",text)
                            xmlValue(G) <- gsub(" we'd ","we would",text)
                            xmlValue(G) <- gsub(" won't ","will not",text)
                            xmlValue(G) <- gsub(" let's ","let us",text)
                            xmlValue(G) <- gsub(" cyo ","see you online",text)
                            xmlValue(G) <- gsub(" m8 ","mate",text)
                            xmlValue(G) <- gsub(" bff ","best friends forever",text)
                          })
    }
  }
  return(doc)
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
mehrals5<-function(liste,doc){
  if(length(liste)> 5){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


#F?r eigenen corpus
#schauen ob Conversation 2 oder mehr Autoren hat
mehrals2<-function(doc,liste){
  if(length(liste)> 2){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


#trainingscorpus orginal
for (c in 1:length(xpathApply(tc, "//conversation",xmlValue))){
   if (xmlSize(xpathApply(tc, paste0("//conversation[position()='",c,"']/message[not(author = following-sibling::message/author)]"))) > 5 ){
    removeNodes(xpathApply(tc, paste0("//conversation[position()='",c,"']")), free = TRUE)
     c <- c-1
  }
  else if(xmlSize(xpathApply(tc, paste0("//conversation[position()='",c,"']/message[not(author = following-sibling::message/author)]"))) < 2 ){
    removeNodes(xpathApply(tc, paste0("//conversation[position()='",c,"']")), free = TRUE)
     c <- c-1
  }
  else if(wenigerals5Nachrichten(c,autorenListe(c,tc), tc)){
    removeNodes(xpathApply(tc, paste0("//conversation[position()='",c,"']")), free = TRUE)
     c <- c-1
  }
  print(c)
}
tc <- Symbolbilder(tc)
tc <- toLowerCase(tc)
tc <- Abkuerzungen(tc)
rootnode_tc <- xmlRoot(tc)
rootsize_tc <- xmlSize(rootnode_tc)
print(rootsize_tc)



