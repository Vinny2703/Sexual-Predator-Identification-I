############################################################################################
Allgemein

Packages, die für die Ausführung des Programms benötigt werden, werden mit dem library 
Befehl am Anfang des Programms geladen.

Codestellen, die mit orginal bezeichnet sind, beziehen sich auf den bereinigten Corpus, 
der in dem  Paper, das als Grundlage der Arbeit dient, beschrieben wird.

Codestellen, die mit eigen/eigener bezeichnet sind beziehen sich auf den bereinigten
Corpus, der nach unseren Vorgaben bereinigt wurde.

txt_Dateien, auf die verwiesen wird, werden mit geschickt.

Die Abspeicherung der einzelnen xml-Dateien sind nicht zwingend erfordelich, wurden 
aber Aufgrund der technischen Probleme als Absicherung eingebaut.
 
Als Datengrundlage dient der Trainingscorpus der Competition PAN-2012.
############################################################################################
############################################################################################
Reihenfolge für die Ausführung der Programme:

1. Vorverarbeitung.R
(an dieser Stelle kann AuswertungTrainingsCorpus.R ausgeführt werden)
2. CNNInput
	2.1 CNNInputEigene.R
	2.2 CNNInputOrginal.R
3. FeaturExtractor.R
4. Modelle 1-4
	Modell1 (orginal Korpus und Conversationstart Featur aus Paper)
	Modell2 (eigener Korpus und Conversationstart Featur aus Paper)
	Modell3 (eigener Korpus und Spam Featur)
	Modell4 (eigener Korpus und Spam Featur und Conversationstart Featur aus Paper)

############################################################################################