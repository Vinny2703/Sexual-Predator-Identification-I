library("XML")
library("methods")
#Korpus einfügen (evtl. über Console, wenn nicht an korrekter Stelle)
corpus <- xmlParse(file = "pan12-sexual-predator-identification-training-corpus-2012-05-01.xml")
#path <- readline(prompt = "Input File: ")
#corpus <- xmlParse(file = path)

#Korpus bereinigen: entferne Konversationen unter 10 Nachrichten und mit !=2 Personen 
corpusclean <- xpathApply(corpus, "//conversation[./message[@line>='10'] and count(./message[not(author = following-sibling::message/author)])=2]")
