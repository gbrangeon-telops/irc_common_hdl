
  MODULE:  PatGen_32_WB
---------------------------------------------------------------------------------------------------------
sous-modules et auteurs
--------------------------------------------------------------------------------------------------------
Pattern_gen_32      => Olivier Bourgois
PatGen_WB_interface => Edem Nofodjie
--------------------------------------------------------------------------------------------------------
NB: Les fichiers sources des sous-modules sont deja documentés

Date:  27 juin, 2007
Outil de Design/simulation:   Active-HDL  7.1
Outil de synthese:  Xilinx ISE/WebPack 8.2 XST VHDL/Verilog

1) Simulation RTL:
    Pour rouler la simulation RTL:
 -s'assurer d'avoir telechargé sur SVN, les fichiers du projet Pattern_gen
 -s'assurer d'avoir telechargé egalement ceux du sous-projet Header_Extractor
 -aller dans le sous repertoire "Fichiers_do"  du   repertoire   "src"
 - executer "PatGen_32_WB_rtl_simul.do" et le waveforme "PatGen_32_WB_RTL_TB.awf" s'affichera
 

2) Synthese:

  - aller dans le sous repertoire "build"  du   repertoire   "src" et lancer make_ngc
  - verifier la creation des fichiers PatGen_32_WB.ngc puis PatGen_32_WB.vhm  dans le repertoire   Pattern_gen\build  du projet.
  - verifier dans le fichier log se trouvant tjrs dans ledit repertoire, l'absence de black-box inhabituel.

3) Simulation Post_synthese
  idem à l'extracteur 

