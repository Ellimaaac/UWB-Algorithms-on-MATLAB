### V1:
1. Lire les valeurs d'un CIR (Channel Impulse Response) à partir des valeurs brutes (cpy/past).
  Il lit 1 block.
2. Calculer la magnitude du CIR.
3. Affichage du CIR
	
### V2:
1. Lire les valeurs de CIR (Channel Impulse Response) à partir des fichiers et les stocker dans des matrices appropriées.
  Il lit tous les blocks d'un CIR.
2. Calculer la magnitude de la CIR pour chaque signal.
3. Affichage du CIR

### V3:
1. Lire les valeurs de CIR (Channel Impulse Response) à partir des fichiers et les stocker dans des matrices appropriées.
2. Calculer la magnitude de la CIR pour chaque signal.
3. Normaliser la magnitude de la CIR.
4. Détecter la première trajectoire (First Path) à l'aide d'une méthode appropriée (en utilisant la variance dans ce cas).
5. Calculer les indices et les distances à partir des résultats obtenus.	

### V4: Optimisation de V3
1. Lire les valeurs de CIR (Channel Impulse Response) à partir des fichiers et les stocker dans des matrices appropriées.
2. Calculer la magnitude de la CIR pour chaque signal.
3. Normaliser la magnitude de la CIR.
4. Détecter la première trajectoire (First Path) à l'aide d'une méthode appropriée (en utilisant la variance dans ce cas).
5. Calculer les indices et les distances à partir des résultats obtenus.	

### V5:
- nouveaux parametres ip_f: Calcul des valeurs de la première trajectoire (First Path Amplitude) :
Les valeurs de la première trajectoire (ip_f1, ip_f2, ip_f3) sont récupérées et ajustées en fonction de leur représentation en bits fractionnaires.
1. Lire les valeurs de CIR à partir des fichiers et les stocker.
2. Calculer la magnitude de la CIR pour chaque signal.
3. Normaliser la magnitude de la CIR.
4. Détecter la première trajectoire (First Path).
5. Calculer et ajuster les valeurs de la première trajectoire en fonction de leur représentation en bits fractionnaires.




