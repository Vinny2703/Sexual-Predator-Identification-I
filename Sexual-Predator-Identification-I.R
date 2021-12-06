library("XML")
library("methods")
#Korpus einfügen (evtl. über Console, wenn nicht an korrekter Stelle)
corpus <- xmlParse(file = "pan12-sexual-predator-identification-training-corpus-2012-05-01.xml")
#path <- readline(prompt = "Input File: ")
#corpus <- xmlParse(file = path)

#Korpus bereinigen: entferne Konversationen unter 10 Nachrichten und mit einzelnen Personen (noch unvollständig)
corpusclean <- xpathApply(corpus, "//conversation[./message[@line>='10'] and ./message/author!=./message/author]")

#Korpus fromatieren?


#xpathApply(corpus, "//conversation[count(child::*/child::author)=2]")

#xpathApply(corpus, "//conversation[count(./message/author[not(./message/author)])=10]")
#xpathApply(corpus, "//conversation[count(./message/author[not(. = ../following-sibling::/message/author)])=10]")
