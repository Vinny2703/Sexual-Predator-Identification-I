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


#Woerterlisten Init
wordlist <- list()
gef_emot <- list()


#Emot_dict_input 
dic <- file("C:/Users/marle/Documents/softwareprojekt1/EmoticonIDfinal_Input.txt", open = "r")
line <- read_lines("EmoticonIDfinal_Input.txt", skip = 0, n_max = -1L)
line
lines <- unlist(strsplit(line, split = '\t'))
emot_val_Input <- lines[seq(1,length(lines), 2)]
emot_id_Input <- lines[seq(2, length(lines), 2)]
close(dic)
emot_dict_Input <- data.frame(emot_val_Input, emot_id_Input)


#Emoticons in Wortliste und gefundenenListe
#Emoticons ersetzen
e <- 1
f <- 1
emotcount <- 0

while(f < length(xpathApply(tc, ("//conversation"), xmlAttrs))+1){
  text <- toString(xpathApply(tc, paste0("//conversation[position()='",f,"']/message/text"), xmlValue))
  while(e < length(emot_id_Input)+1){
    if(grepl(toString(emot_val_Input[e]),text)){
      emotcount <- emotcount+1
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


#Wörter in Wortliste
while(f < length(xpathApply(tc, ("//conversation"), xmlAttrs))+1){
  text <- toString(xpathApply(tc, paste0("//conversation[position()='",f,"']/message/text"), xmlValue))
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
write_lines(wordlist, "Woerterdict.txt")