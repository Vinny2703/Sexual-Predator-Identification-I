# Sexual-Predator-Identification-I
Aufgabe

Das Ziel dieser Aufgabe ist es, Klassen von Autoren, nämlich Online-Sexualstraftäter, zu identifizieren. Sie erhalten Chat-Protokolle, an denen zwei (oder mehr) Personen beteiligt sind, und müssen herausfinden, wer derjenige ist, der versucht, die andere zu einer sexuellen Gefälligkeit zu bewegen. Zusätzlich soll das spezielle Gespräch identifiziert werden, in dem sich die Absicht der Person zeigt.

Die Aufgabe kann daher in zwei Teile aufgeteilt werden:

    Identifikation der Online-Sexualstraftäter (innerhalb aller Benutzer)
    Identifikation des Teils (Zeilen) der Straftätergespräche, die das ausgeprägteste Verhalten in dieser Hinsicht repräsentieren.

Angesichts des öffentlichen Charakters des Datensatzes bitten wir die Teilnehmerinnen und Teilnehmer, zur Lösung dieser Aufgabe keine externen oder Online-Ressourcen (z.B. Suchmaschinen) zu nutzen, sondern nur Beweise aus den bereitgestellten Datensätzen zu extrahieren.
Eingabe

Für die Entwicklung Ihrer Software stellen wir Ihnen ein Trainingskorpus zur Verfügung, das aus Chat-Protokollen besteht, in denen Minderjährige und Erwachsene, die vorgeben, Minderjährige zu sein, chatten.
Ausgabe

Für jeden der beiden Teile benötigen wir ein anderes Format.

Identifikation der Online-Sexualstraftäter (innerhalb aller Benutzer)

Sie sollten eine Textdatei mit einer Benutzerkennung pro Zeile ausgeben, wobei nur die als Online-Sexualstraftäter identifizierten Benutzer enthalten sein sollten:

...
a7c5056a2c30e2dc637907f448934ca3
58f15bbb100bbeb6963b4b967ce04bdf
e040eb115e3f7ad3824e93141665fc2a
3d57ed3fac066fa4f8a52432db51c019
...

Identifikation des Teils (Zeilen) der Straftätergespräche, die das ausgeprägteste Verhalten in dieser Hinsicht repräsentieren.

Sie sollten eine xml-Datei ähnlich der Korpusdatei ausgeben, die Konversations-IDs und die Zeilennummern der als verdächtig erachtete Nachrichten enthält (Zeilennummern zusammen mit allen anderen Nachrichteninformationen: Autor, Zeit, Text):



Evaluation

Die Leistung Ihrer Straftäter-Identifikation wird nach durchschnittlicher Präzision, Sensitivität und F-Maß über alle beteiligten Personen und Gesprächszeilen beurteilt. Dabei ist F0.5 für die Straftäter-Identifikation und F3 für die Zeilenidentifikation zu verwenden.
