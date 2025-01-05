# Progetto Reti Logiche 2023/2024
Progetto (Prova Finale) Reti Logiche 2023/2024 Politecnico di Milano.

11 progetto consiste nello sviluppare un componente hardware nel linguaggio VHDL che ha il compito di scansionare una sequenza di misurazioni presenti in memoria ed associare ad ogni misurazione un relativo valore di confidenza.

Le misurazioni con valore 0 hanno il significato di "valore non specificato”, fanno quindi calare la confidenza della misurazione.
Voto Progetto: 30L/30

## Contenuto della Repository

- [Relazione.pdf](Relazione.pdf) - Relazione del progetto che spiega obiettivo e funzionamento
- [Comonent.vhd](Component.vhd) - Codice VHDL del componente, in un solo file per la consegna 
- `tb-generator` - cartella contenente uno script per generare casi di test 
- `VHDL` - cartella con il codice VHDL diviso in file diversi per maggiore ordine

## Schemi
![https://github.com/FrancescoCaracciolo/ProgettoRetiLogiche23-24/blob/main/LaTeX/schema.drawio.png?raw=true](https://github.com/FrancescoCaracciolo/ProgettoRetiLogiche23-24/blob/main/LaTeX/FSM.png?raw=true)

![https://github.com/FrancescoCaracciolo/ProgettoRetiLogiche23-24/blob/main/LaTeX/FSM.png?raw=true](https://github.com/FrancescoCaracciolo/ProgettoRetiLogiche23-24/blob/main/LaTeX/schema.drawio.png)
