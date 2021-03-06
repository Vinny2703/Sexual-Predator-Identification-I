#packages
install.packages("wordnet")
library("keras")
library("tensorflow")
library("rJava")
library("wordnet")
library("tokenizers")
library("textstem")
library("rlang")
library("stringi")


#Emot_dict_input 
line <- readLines("EmoticonIDfinal_Input.txt", skip = 0, n_max = -1L)
line
lines <- unlist(strsplit(line, split = '\t'))
emot_val_Input <- lines[seq(1,length(lines), 2)]
emot_id_Input <- lines[seq(2, length(lines), 2)]
emot_dict_Input <- data.frame(emot_val_Input, emot_id_Input)

#Beginn Erstellung Woerterbuch
worddict <- function(dictionarypath, korpus){
  
  #Woerterlisten Init
  wordlist <- list()
  gef_emot <- list()
  
  #Emoticons in Wortliste und gefundenenListe
  #Emoticons ersetzen
  e <- 1
  f <- 1
  emotcount <- 0
  
  while(f <= xmlSize(xpathApply(korpus, ("/conversations/conversation"), xmlAttrs))){
    text <- xpathApply(korpus, paste0("/conversations/conversation[position()='",f,"']/message/text"), xmlValue)
    while(e <= length(emot_id_Input)){
      if(grepl(toString(emot_val_Input[e]),text)){
        emotcount <- emotcount+1
        gsub(emot_val_Input[e],emot_id_Input[e],text)
        if((as_string(emot_id_Input[e])%in%gef_emot) == FALSE){
          length(gef_emot) <- length(gef_emot)+1
          gef_emot[length(gef_emot)] <- emot_id_Input[e]
          length(wordlist) <- length(wordlist)+1
          wordlist[length(wordlist)] <- emot_id_Input[e]
        }
      }
      print(e)
      e <- e+1
    }
    e <- 1
    print(f)
    f <- f+1
  }
  
  #Woerter in Wortliste
  while(f < length(xpathApply(korpus, ("/conversations/conversation"), xmlAttrs))+1){
    text <- toString(xpathApply(korpus, paste0("/conversations/conversation[position()='",f,"']/message/text"), xmlValue))
    lem <- lemmatize_words(text)
    token <- tokenize_words(lem)
    length(wordlist) <- length(wordlist)+1
    wordlist[length(wordlist)] <- token
  }
  
  
  #id fuer woerter
  index <- 0
  for (w in wordlist) {
    if (grepl("[A-Za-z]", w)) {
      w <- index+1
    }
  }
  write_lines(wordlist, dictionarypath)
  #write(data frame to write to disk, path to write to)
}

texttoid <- function(dictionarypath, texttokenlist){
  dictionary <- read.table(dictionarypath)
  inputlist <- list()
  for(element in 1:length(texttokenlist)){
    textidlist <- list()
    for(wort in 1:element){
      if(wort %in% dictionary){
        length(textidlist) <- length(textidlist)+1
        textidlist[length(textidlist)] <- dictionary[wort]
      } else {
        length(textidlist) <- length(textidlist)+1
        textidlist[length(textidlist)] <- 0
      }
    }
  }
  return(inputlist)
}

#Funktion um Inputs auf die gleiche Laenge zu bringen (am Ende mit 0 fuellen)
paddinginput <- function(inputlist){
  inputlistpadded <- pad_sequences(inputlist, padding = "post")
  return(inputlistpadded)
}

inputtransformation <- function(korpus, inputpath){
  dokument <- xmlParse(file = korpus)
  inputliste <- list()
  autorenconversationsliste <- list()
  
  for(con in 1:length(xpathApply(korpus, "/conversations/conversation",xmlAttrs))) {
    con_id <- xpathApply(korpus, "/conversations/conversation",xmlAttrs) #### NUR DIE CONVERSATION ID SOLL HIER UEBERGEBEN WERDEN!!!!!
    if(con_id %in% inputliste){
      message = con_id(getElement("message"))
      conversation <-list()
    for(message in 1:length(xpathApply(korpus, "/conversations/conversation[position()='",con,"']/message",xmlAttrs))) {
        p = message(getElement("author"))
        autoreid = p(korpus, "/conversations/conversation[position()='",author,"']/message",xmlAttrs)
        if((autorenid %in% conversation)== FALSE){
        conversation(autorenid) = ""
        textelement = message(getElement("text"))
        try(inhalt = textelement(korpus, "/conversations/conversation[position()='",con,"']/message",xmlAttrs))
          conversation(autorenid) = conversation(autorenid) + "" + inhalt
          
          for (n in conversation){
            autorentext = conversation(n)
            autorenwortliste = emote_id_input(autorentext)
          }
          wordlist = tokenize_words(autorentext)
          for (wort in wordlist){
            for (token in wordlist){
              lemmatizedtoken = lemmatize_strings()
            }
          }
      
    }
  }
}
}}

#Ausfuehrungen der Funktionen
#Woerterbuch fuer Original-Korpus
worddict_o<- worddict("Worddict_o.txt", tc_o)
#Erzeugung des Inputs fuer Original-Korpus
input_o <- inputtransformation(tc_o, "Input_o.txt")

#Woerterbuch fuer eigenen Korpus
worddict_e <- worddict("Worddict_e.txt", tc_e)
#Erzeugung des Inputs fuer eigenen Korpus
input_e <- inputtransformation(tc_e, "Input_e.txt")

