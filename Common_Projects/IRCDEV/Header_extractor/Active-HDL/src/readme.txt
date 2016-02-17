
  MODULE:  Header_Extractor_32_WB
---------------------------------------------------------------------------------------------------------
sous-modules et auteurs
--------------------------------------------------------------------------------------------------------
header_extractor32  => Olivier Bourgois
HX_WB_Interface     => Edem Nofodjie
--------------------------------------------------------------------------------------------------------
NB: Les fichiers sources des sous-modules sont deja documentés

Date:  27 juin, 2007
Outil de Design/simulation:   Active-HDL  7.1
Outil de synthese:  Xilinx ISE/WebPack 8.2 XST VHDL/Verilog

1) Simulation RTL:
    Pour rouler la simulation RTL:\par
 -s'assurer d'avoir telechargé sur SVN, les fichiers du projet Header_extractor
 -s'assurer d'avoir telechargé egalement ceux du sous-projet Pattern_gen  
 -aller dans le sous repertoire "Fichiers_do"  du   repertoire   "src"
 - executer "Run_RTL_PG_HX_sim.do" et le waveforme "PG_HX_RTL_simul.awf" s'affichera
   (il s'agit d'une simulation avec des DREM vallant toujours 3)
 -pour un DREM aleatoire, utiliser "Run_RTL_PG_HX_Random_DREM.do"  

2) Synthese:

  - aller dans le sous repertoire "build"  du   repertoire   "src" et lancer make_ngc
  - verifier la creation des fichiers Header_Extractor_32_WB.ngc puis Header_Extractor_32_WB.vhm  dans le repertoire   Header_extractor\\build du projet.
  - verifier dans le fichier log se trouvant tjrs dans ledit repertoire, l'absence de black-box inhabituel.

3) Simulation Post_synthese
- faire d'abord la synthese (étape 2 precedente)
- aller dans le sous repertoire "Fichiers_do"  du   repertoire   "src"
- executer "Post_Synth_Sim.do" et le waveforme "Simul_post_synth.awf" s'affichera

