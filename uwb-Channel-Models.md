# Introduction
Ce code montre comment implémenter des modèles de canal Ultra Large Bande (UWB) pour divers environnements de propagation, en se basant sur les recommandations du sous-groupe de modélisation de canal de la norme IEEE 802.15.4a.

# Table of Contents
0. [Résumé détaillé](#résumé-détaillé-du-code-des-modèles-de-canal-uwb)
1. [Vue d'ensemble]()
2. [Structure de la classe uwbChannelConfig]()	
  3. [Classe uwbChannelConfig]()	
  4. [Fonction HelpApplyChannel]()	
  5. [Fonction helperClusterization]()
  6. [Fonction helperUWBFadingRealization]()	
  7. [Fonction helperdistancePathLoss]()	
  8. [Fonction helperFreauencyPathLoss]()	
  9. [Fonction helperGammaRV]()	
  10. [Fonction helperNakagamiParameters]()
  11. [Fonction helperPathModeling]()	
 
# Résumé détaillé du code des modèles de canal UWB

Ce code présente l'implémentation de modèles de canal Ultra Large Bande (UWB) basés sur les recommandations du sous-groupe de modélisation de canal de la norme IEEE 802.15.4a. Il permet de simuler des environnements de propagation variés en intégrant des pertes de chemin, des effets d'évanouissement et des caractéristiques spécifiques aux environnements.
### Configuration des Paramètres de Canal : uwbChannelConfig
La classe uwbChannelConfig configure les paramètres nécessaires pour modéliser différents types d'environnements (e.g., bureau intérieur, industriel) avec ou sans ligne de vue (LOS). Elle définit des propriétés telles que le type d'environnement, la perte de chemin de référence, l'exposant de perte de chemin, l'ombrage, et les paramètres d'antenne. Les méthodes de cette classe ajustent les configurations spécifiques selon le type d'environnement et la présence de LOS, permettant de créer des scénarios de propagation personnalisés.
### Application du Modèle de Canal : helperApplyChannel
La fonction helperApplyChannel applique le modèle de canal UWB au signal d'entrée. Elle convertit les temps d'arrivée des chemins en temps absolus, crée un filtre de canal pour modéliser les retards de trajet, et simule les effets d'évanouissement Nakagami. Les gains des trajets sont calculés en fonction des puissances moyennes et des phases des trajets, en prenant en compte les décalages Doppler et la densité d'échantillons.
### Caractéristiques des Clusters : helperClusterization
Cette fonction génère les caractéristiques des clusters pour le modèle de canal UWB. Elle détermine le nombre de clusters, les temps d'arrivée et les énergies des clusters en utilisant des processus de Poisson. Pour certains environnements spécifiques, elle utilise un profil de délai de puissance alternatif avec un seul cluster.
### Réalisation de l'Évanouissement Nakagami : helperUWBFadingRealization
La fonction helperUWBFadingRealization génère une nouvelle réalisation de l'évanouissement Nakagami pour chaque trajet. Elle calcule les gains des trajets en utilisant la distribution Gamma et applique les paramètres Nakagami m spécifiques à chaque chemin.
### Perte de Chemin Dépendante de la Distance : helperDistancePathLoss
Cette fonction applique une perte de chemin dépendante de la distance au signal d'entrée. Elle calcule la perte de chemin en fonction de la distance entre l'émetteur et le récepteur, en tenant compte de l'exposant de perte de chemin et de l'ombrage. La perte de chemin est ensuite appliquée au signal d'entrée.
### Perte de Chemin Dépendante de la Fréquence : helperFrequencyPathLoss
La fonction helperFrequencyPathLoss modélise la perte de chemin en fonction de la fréquence. Elle applique un filtre FIR au signal d'entrée pour ajuster les amplitudes en fonction de la fréquence centrale et de la largeur de bande, en utilisant un exposant spécifique à l'environnement.
### Génération de Variables aléatoires Gamma : helperGammaRV
Cette fonction génère des variables aléatoires distribuées selon une loi Gamma en utilisant les paramètres de forme et d'échelle. Elle combine des réalisations Gamma pour produire la variable finale.
### Calcul des Paramètres Nakagami : helperNakagamiParameters
La fonction helperNakagamiParameters détermine les paramètres de distribution Nakagami m pour chaque trajet. Elle utilise des distributions log-normales pour calculer les paramètres en fonction des temps d'arrivée des chemins et des caractéristiques spécifiques de l'environnement.
### Modélisation des Chemins : helperPathModeling
Cette fonction génère les temps d'arrivée, les puissances moyennes et les phases des trajets. Elle utilise des processus de Poisson mixtes pour modéliser les temps d'arrivée et calcule les puissances moyennes en fonction des facteurs de décroissance intra-cluster. Les phases des trajets sont générées uniformément pour représenter les variations complexes du canal.
### Génération de Variables aléatoires de Poisson : helperPoissonRV
La fonction helperPoissonRV génère des variables aléatoires selon une distribution de Poisson en utilisant un algorithme basé sur les sommes logarithmiques. Elle continue d'accumuler des valeurs logarithmiques jusqu'à atteindre le paramètre de la distribution, produisant ainsi une variable de Poisson.
### Conclusion
Ce code fournit un cadre complet pour la simulation de canaux UWB, permettant de modéliser précisément les environnements de propagation, les pertes de chemin, et les effets d'évanouissement pour des scénarios variés.
 

# Vue d'ensemble
1.	Perte de chemin dépendante de la distance et de la fréquence :
  - Le signal reçu subit une perte de chemin, qui dépend de la distance ddd entre l'émetteur et le récepteur, ainsi que de la fréquence fff du signal reçu.
2.	Modèle Saleh-Valenzuela modifié :
  - Ce modèle contient des composants multipath (trajets multiples) regroupés en clusters distincts.
3.	Détermination des amplitudes de chemin avec des distributions de Nakagami distinctes (évanouissement à petite échelle) :
  - Les amplitudes des chemins sont modélisées en utilisant des distributions de Nakagami spécifiques à chaque environnement.
4.	Paramétrage spécifique à l'environnement :
  - Les paramètres du modèle sont ajustés en fonction de l'environnement de propagation (ex : bureau intérieur, extérieur, etc.).

### Paramétrage de l'environnement
Les modèles de canal UWB recommandés couvrent différentes plages de fréquence (2 à 10 GHz) et types d'environnements, avec ou sans ligne de vue (LOS). L'exemple implémente neuf combinaisons d'environnements.
Perte de chemin et propagation
1.	Dépendance de la distance :
  -	La perte de chemin dépend de la distance ddd et est modélisée par un modèle classique de propagation à distance logarithmique. Un facteur d'exponentiation de la perte de chemin (PathLossExponentPathLossExponentPathLossExponent) détermine la rapidité avec laquelle la puissance se dissipe.
2.	Dépendance de la fréquence :
  - La perte de chemin dépend aussi de la fréquence, où les fréquences plus basses sont amplifiées et les plus hautes réduites. Un facteur d'exponentiation de la fréquence (FrequencyExponentFrequencyExponentFrequencyExponent) détermine la rapidité avec laquelle la puissance est perdue en fonction de la fréquence.
### Effets de l'antenne
Les effets de l'antenne incluent une atténuation due à la présence de personnes près des antennes et une perte d'antenne spécifique à l'environnement.
### Profil de délai de puissance (Power Delay Profile)
1.	Clusterisation :
-	Le modèle de canal UWB basé sur Saleh-Valenzuela groupe les composants multipath en clusters. Les temps d'arrivée des clusters suivent une distribution de Poisson, et l'énergie moyenne de chaque cluster décroit exponentiellement avec le temps d'arrivée.
2.	Modélisation des chemins :
-	Les chemins arrivent au sein de chaque cluster selon un mélange de deux processus de Poisson. La puissance moyenne des chemins décroit exponentiellement en fonction du délai des chemins. Pour certains environnements spécifiques, le profil de délai de puissance augmente jusqu'à un maximum avant de décroitre.
3.	Évanouissement à petite échelle (small-scale fading) :
-	Une distribution de Nakagami est utilisée pour modéliser l'évanouissement à petite échelle, où le paramètre de forme mmm de la distribution de Nakagami est une variable aléatoire log-normale.
### Simulation
Les signaux transmis sont affectés par l'évanouissement à petite échelle selon les paramètres de Nakagami et la densité d'échantillons.
### Comparaison des environnements
Les gains de canal pour différents environnements peuvent être générés pour illustrer les différences dans leurs profils de délai de puissance. Le uwbChannel encapsule tous les composants du modèle de canal UWB dans une seule utilité pour faciliter la comparaison des environnements.
 
# Structure de la classe uwbChannelConfig
## Propriétés
Les propriétés de cette classe définissent les paramètres du modèle de canal UWB :
1.	Type : Type d'environnement (par exemple, 'Indoor office' ou 'Industrial').
2.	HasLOS : Indicateur booléen de la présence d'une ligne de vue (LOS) entre l'émetteur et le récepteur.
3.	ReferencePathLoss : Perte de chemin de référence à une distance de 1 m, en dB.
4.	PathLossExponent : Exposant de perte de chemin, déterminant la rapidité de décroissance de la puissance reçue en fonction de la distance.
5.	ShadowingDeviation : Écart type de l'ombrage (grande échelle), en dB.
6.	AntennaLoss : Perte de puissance due aux antennes, en dB.
7.	FrequencyExponent : Exposant de dépendance de la fréquence pour la perte de chemin, en dB/octave.
8.	AverageNumClusters : Nombre moyen de clusters de rayons.
9.	ClusterArrivalRate : Taux d'arrivée des clusters suivant un processus de Poisson, en ns^-1.
10.	PathArrivalRate1 et PathArrivalRate2 : Taux d'arrivée des rayons pour le modèle de Poisson mixte.
11.	MixtureProbability : Probabilité de mélange pour le modèle de Poisson mixte.
12.	ClusterEnergyDecayConstant : Constante de décroissance exponentielle de l'énergie des clusters.
13.	PathDecaySlope et PathDecayOffset : Pente et décalage de la constante de décroissance intra-cluster.
14.	ClusterShadowingDeviation : Écart type de l'ombrage du cluster.
15.	PDPIncreaseFactor et PDPDecayFactor : Facteurs d'augmentation et de décroissance du profil de délai de puissance (PDP) alternatif.
16.	FirstPathAttenuation : Atténuation du premier composant dans le profil de délai de puissance alternatif.
17.	NakagamiMeanOffset et NakagamiMeanSlope : Décalage et pente de la moyenne du facteur Nakagami m.
18.	NakagamiDeviationOffset et NakagamiDeviationSlope : Décalage et pente de la variance du facteur Nakagami m.
19.	FirstPathNakagami : Facteur Nakagami m du premier composant fort.
## Méthodes
Les méthodes définissent comment configurer et mettre à jour les paramètres de l'environnement :
1.	Constructeur (uwbChannelConfig) : Crée un objet de configuration pour un modèle de canal UWB en fonction du type d'environnement et de la présence d'une LOS.
2.	updateModelParameters : Met à jour les paramètres du modèle en fonction du type d'environnement et de la présence d'une LOS.
3.	setupIndoorOfficeEnvironment et setupIndustrialEnvironment : Configurent les paramètres spécifiques pour les environnements 'Indoor office' et 'Industrial'.
4.	set.Type et set.HasLOS : Met à jour les paramètres du modèle lorsque le type d'environnement ou la présence d'une LOS sont modifiés.
5.	isInactiveProperty : Contrôle l'affichage conditionnel des propriétés, déterminant si certaines propriétés doivent être actives ou inactives en fonction des paramètres actuels de l'objet.
 
# Classe uwbChannelConfig
## Description
La classe uwbChannelConfig permet de configurer un modèle de canal UWB pour différents types d'environnements, en tenant compte de la présence ou non d'une ligne de vue (LOS) entre l'émetteur et le récepteur.
## Propriétés
1.	Type : Type d'environnement ('Residential', 'Indoor office', 'Outdoor', 'Open outdoor', 'Industrial'). Cette propriété détermine les paramètres et le mode de fonctionnement du canal UWB.
2.	HasLOS : Indicateur booléen (true/false) indiquant la présence d'une ligne de vue.
3.	ReferencePathLoss : Perte de chemin à une distance de 1 m, en dB.
4.	PathLossExponent : Exposant de perte de chemin, déterminant la rapidité de décroissance de la puissance reçue en fonction de la distance.
5.	ShadowingDeviation : Écart type de l'ombrage (fading à grande échelle), en dB.
6.	AntennaLoss : Perte de puissance due aux antennes, en dB.
7.	FrequencyExponent : Exposant de dépendance de la fréquence pour la perte de chemin, en dB/octave.
8.	AverageNumClusters : Nombre moyen de clusters de rayons.
9.	ClusterArrivalRate : Taux d'arrivée des clusters suivant un processus de Poisson, en ns^-1.
10.	PathArrivalRate1 et PathArrivalRate2 : Taux d'arrivée des rayons pour le modèle de Poisson mixte.
11.	MixtureProbability : Probabilité de mélange pour le modèle de Poisson mixte.
12.	ClusterEnergyDecayConstant : Constante de décroissance exponentielle de l'énergie des clusters.
13.	PathDecaySlope : Pente de la constante de décroissance intra-cluster.
14.	PathDecayOffset : Décalage de la constante de décroissance intra-cluster.
15.	ClusterShadowingDeviation : Écart type de l'ombrage du cluster.
16.	PDPIncreaseFactor et PDPDecayFactor : Facteurs d'augmentation et de décroissance du profil de délai de puissance (PDP) alternatif.
17.	FirstPathAttenuation : Atténuation du premier composant dans le profil de délai de puissance alternatif.
18.	NakagamiMeanOffset et NakagamiMeanSlope : Décalage et pente de la moyenne du facteur Nakagami m.
19.	NakagamiDeviationOffset et NakagamiDeviationSlope : Décalage et pente de la variance du facteur Nakagami m.
20.	FirstPathNakagami : Facteur Nakagami m du premier composant fort.
## Méthodes
1.	Constructeur (uwbChannelConfig) : Crée un objet de configuration pour un modèle de canal UWB en fonction du type d'environnement et de la présence d'une LOS.
2.	updateModelParameters : Met à jour les paramètres du modèle en fonction du type d'environnement et de la présence d'une LOS. 
3.	setupIndoorOfficeEnvironment et setupIndustrialEnvironment : Configurent les paramètres spécifiques pour les environnements 'Indoor office' et 'Industrial'.
4.	set.Type et set.HasLOS : Met à jour les paramètres du modèle lorsque le type d'environnement ou la présence d'une LOS sont modifiés.
5.	isInactiveProperty : Contrôle l'affichage conditionnel des propriétés, déterminant si certaines propriétés doivent être actives ou inactives en fonction des paramètres actuels de l'objet.
 
# Fonction HelpApplyChannel
Ce code MATLAB définit une fonction helperApplyChannel qui applique une simulation de canal de type Nakagami pour un signal UWB (Ultra Wide Band). Voici une explication détaillée du fonctionnement de cette fonction :
## Description de la fonction
### Inputs
1.	signalIn : Le signal d'entrée à transmettre à travers le canal UWB.
2.	clusterArrivalTimes : Les temps d'arrivée des clusters de trajets multiples.
3.	pathArrivalTimes : Les temps d'arrivée des trajets à l'intérieur des clusters.
4.	pathAveragePowers : Les puissances moyennes des trajets.
5.	pathPhases : Les phases des trajets.
6.	nakagamiM : Les paramètres de distribution de Nakagami pour l'évanouissement des trajets.
7.	Fs : La fréquence d'échantillonnage.
8.	sampleDensity : La densité d'échantillons pour la simulation.
9.	maxDopplerShift : Le décalage Doppler maximal.
### Outputs
1.	signalOut : Le signal de sortie après passage par le canal UWB.
2.	pathGains : Les gains des trajets obtenus par la réalisation de l'évanouissement Nakagami.
## Détails de la fonction
1.	Calcul des temps d'arrivée absolus
o	La fonction commence par convertir les temps d'arrivée relatifs des trajets en temps absolus, en ajoutant les temps d'arrivée des clusters.
2.	Création de l'objet de filtre de canal
Un objet comm.ChannelFilter est créé pour modéliser les retards de trajets en fonction des temps d'arrivée absolus.
chanObj = comm.ChannelFilter(SampleRate=Fs, PathDelays=cell2mat(absoluteArrivalTimes)/1e9); % Convertir les retards en secondes
3.	Calcul de la fréquence des nouvelles réalisations de canal
o	La fréquence des nouvelles réalisations de canal est calculée à partir du décalage Doppler maximal et de la densité d'échantillons.
4.	Simulation des gains de trajets
o	Un tableau pour stocker les gains de trajets (pathGains) est initialisé.
o	Pour chaque réalisation de canal, les gains de trajets sont calculés en appliquant les distributions de Nakagami et les phases.
### Fonctions associées
•	helperUWBFadingRealization : Fonction qui génère une réalisation de l'évanouissement Nakagami.
•	comm.ChannelFilter : Objet de filtrage de canal pour modéliser les retards de trajets.
Cette fonction applique un modèle de canal UWB avec évanouissement Nakagami au signal d'entrée en simulant les effets de trajets multiples et de l'évanouissement sur le signal, en prenant en compte les paramètres de fréquence d'échantillonnage et de décalage Doppler.
 
# Fonction helperClusterization
Ce code MATLAB définit une fonction helperClusterization qui génère les caractéristiques des clusters pour un modèle de canal Ultra Wide Band (UWB). Voici une explication détaillée de la fonction :
## Description de la fonction
### Inputs
1.	type : Type d'environnement (par exemple, 'Residential', 'Indoor office', 'Industrial').
2.	LOS : Indicateur booléen de la présence d'une ligne de vue (Line-Of-Sight).
3.	Lbar : Nombre moyen de clusters.
4.	Lambda : Taux d'arrivée des clusters suivant un processus de Poisson, en ns^-1.
5.	sigma_cluster : Écart type de l'ombrage des clusters, en dB.
6.	Gamma : Constante de décroissance exponentielle de l'énergie des clusters, en ns.
### Outputs
1.	L : Nombre de clusters.
2.	clusterArrivals : Vecteur 1xL contenant les temps d'arrivée des clusters, en ns.
3.	clusterEnergies : Vecteur 1xL contenant les énergies des clusters.
### Détails de la fonction
1.	Détermination du nombre de clusters
o	Si l'environnement est de type 'Indoor office' ou 'Industrial' sans LOS, un profil de délai de puissance alternatif est utilisé avec un seul cluster.
o	Sinon, le nombre de clusters LLL est déterminé par une variable aléatoire de Poisson avec une moyenne LbarLbarLbar.
singleAlternatePDP = ~LOS && any(strcmp(type, {'Indoor office', 'Industrial'}));
if ~singleAlternatePDP
    L = max(1, helperPoissonRV(Lbar));
else
    L = 1; % profil PDP unique
end
2.	Temps d'arrivée des clusters
o	Si un profil de délai de puissance alternatif n'est pas utilisé, les temps d'arrivée des clusters sont générés en utilisant des inter-arrivées exponentielles, suivies d'une sommation cumulative pour obtenir les temps d'arrivée absolus.
o	Sinon, le temps d'arrivée du seul cluster est fixé à 0.
if ~singleAlternatePDP
    interarrivals = log(rand(1, L)) * (-1 / Lambda);  % en ns
    clusterArrivals = cumsum(interarrivals);          % en ns
else
    clusterArrivals = 0; % cas d'un seul cluster
end
3.	Énergies des clusters
o	Si l'environnement est 'Residential' ou 'Industrial' avec LOS, une variable aléatoire normale est utilisée pour représenter l'ombrage des clusters, convertie ensuite dB en échelle linéaire.
o	Sinon, l'ombrage des clusters est fixé à 1.
o	Les énergies des clusters sont calculées en utilisant une décroissance exponentielle en fonction des temps d'arrivée des clusters et multipliées par l'ombrage des clusters.
if strcmp(type, 'Residential') || (LOS && strcmp(type, 'Industrial'))
    Mcluster = randn * sigma_cluster;             % ombrage des clusters
    Mcluster = 10^(Mcluster / 10);                % convertir dB en échelle linéaire
else
    Mcluster = 1; % pas d'opération
end

if ~singleAlternatePDP
    clusterEnergies = exp(-clusterArrivals / Gamma) * Mcluster;
else
    clusterEnergies = 1;
end
### Fonction associée
•	helperPoissonRV : Fonction (non fournie ici) qui génère une variable aléatoire de Poisson.
Exemple d'utilisation
Supposons que vous ayez les paramètres suivants pour un environnement 'Residential' avec LOS :
type = 'Residential';
LOS = true;
Lbar = 3;           % Nombre moyen de clusters
Lambda = 0.1;       % Taux d'arrivée des clusters
sigma_cluster = 2;  % Écart type de l'ombrage des clusters, en dB
Gamma = 20;         % Constante de décroissance exponentielle de l'énergie des clusters, en ns
Cette fonction génère les caractéristiques des clusters, y compris le nombre de clusters, les temps d'arrivée et les énergies des clusters pour un canal UWB, en fonction des paramètres d'environnement spécifiés.


 
# Fonction helperUWBFadingRealization
Ce code MATLAB définit une fonction helperUWBFadingRealization qui génère une nouvelle réalisation de l'évanouissement Nakagami pour un canal Ultra Large Bande (UWB). Voici une explication détaillée de cette fonction :
Description de la fonction
Inputs
1.	pathAveragePowers : Cellule 1xL contenant les puissances moyennes des trajets pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les puissances moyennes des trajets à l'intérieur du cluster.
2.	nakagamiM : Cellule 1xL contenant les paramètres de distribution de Nakagami pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les paramètres Nakagami m pour les trajets à l'intérieur du cluster.
Outputs
1.	pathGains : Cellule 1xL contenant les gains des trajets pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les gains des trajets à l'intérieur du cluster.
Détails de la fonction
1.	Initialisation
o	La fonction commence par déterminer le nombre de clusters LLL à partir de la taille de pathAveragePowers.
L = numel(pathAveragePowers);  % Nombre de clusters
pathGains = cell(1, L);        % Initialisation de la cellule de gains de trajets
2.	Boucle sur les clusters
o	Pour chaque cluster, le nombre de trajets KLK_LKL est déterminé à partir de la taille de l'élément correspondant dans pathAveragePowers.
o	Un vecteur de gains de trajets est initialisé pour chaque cluster.
for clusterIdx = 1:L  % Pour chaque cluster
    K_L = numel(pathAveragePowers{clusterIdx});  % Nombre de trajets par cluster
    pathGains{clusterIdx} = zeros(1, K_L);       % Initialisation des gains de trajets pour le cluster
3.	Boucle sur les trajets
o	Pour chaque trajet dans un cluster, le paramètre Nakagami m est récupéré.
o	Une nouvelle réalisation de variable aléatoire Gamma est générée à partir du paramètre m et de la puissance moyenne du trajet, en utilisant la fonction helperGammaRV.
o	Le gain du trajet est calculé en prenant la racine carrée de la réalisation de Gamma, ce qui permet de passer de la distribution Gamma à la distribution Nakagami.
    for pathIdx = 1:K_L  % Pour chaque trajet dans le cluster
        thisM = nakagamiM{clusterIdx}(pathIdx);  % Paramètre Nakagami m pour le trajet
        newGamma = helperGammaRV(thisM, pathAveragePowers{clusterIdx}(pathIdx) / thisM);
        pathGains{clusterIdx}(pathIdx) = sqrt(newGamma);  % Gamma -> Nakagami
    end
end
Fonction associée
•	helperGammaRV : Cette fonction génère une réalisation de variable aléatoire Gamma à partir du paramètre Nakagami m et de la puissance moyenne divisée par m.
Exemple d'utilisation
Supposons que pathAveragePowers et nakagamiM soient définis comme suit :
pathAveragePowers = { [1, 0.5, 0.2], [0.8, 0.3] };
nakagamiM = { [2, 1.5, 1], [2, 1] };
Vous pouvez appeler helperUWBFadingRealization comme suit :
pathGains = helperUWBFadingRealization(pathAveragePowers, nakagamiM);
disp(pathGains);
Cette fonction simule une réalisation de l'évanouissement Nakagami pour un canal UWB en générant des gains de trajets basés sur les puissances moyennes des trajets et les paramètres Nakagami.
 
Fonction helperdistancePathLoss
Ce code MATLAB définit une fonction helperDistancePathLoss qui applique une perte de chemin dépendante de la distance à un signal d'entrée. Voici une explication détaillée de cette fonction :
Description de la fonction
Inputs
1.	signalIn : Le signal d'entrée à transmettre à travers le canal UWB.
2.	PL0 : La perte de chemin à une distance de référence de 1 mètre, en dB.
3.	d : La distance entre les deux points de la liaison, en mètres.
4.	n : L'exposant de perte de chemin.
5.	sigma : L'écart type de l'ombrage (fading à grande échelle), en dB.
Outputs
1.	signalOut : Le signal de sortie après application de la perte de chemin dépendante de la distance.
2.	PLd : La perte de chemin causée par la distance, en dB.
Détails de la fonction
1.	Distance de référence
o	La distance de référence d0d_0d0 est fixée à 1 mètre.
d0 = 1;  % Distance de référence en mètres
2.	Évanouissement dû à l'ombrage
o	L'évanouissement dû à l'ombrage est simulé en générant une variable aléatoire normale (distribuée de manière gaussienne) avec un écart type σ\sigmaσ.
S = randn * sigma;  % Ombrage, évanouissement à grande échelle
3.	Calcul de la perte de chemin due à la distance
o	La perte de chemin PLdPL_dPLd est calculée en utilisant la formule logarithmique suivante : PLd=PL0+10nlog⁡10(dd0)+SPL_d = PL_0 + 10n\log_{10}\left(\frac{d}{d_0}\right) + SPLd=PL0+10nlog10(d0d)+S
o	Cette formule inclut la perte de chemin à la distance de référence PL0PL_0PL0, le terme logarithmique en fonction de la distance ddd et l'exposant de perte de chemin nnn, ainsi que l'ombrage SSS.
PLd = PL0 + 10 * n * log10(d / d0) + S;  % Perte de chemin causée par la distance, en dB
4.	Application de la perte de chemin au signal
o	La perte de chemin en dB est convertie en échelle linéaire et appliquée au signal d'entrée. La conversion de dB à linéaire se fait en utilisant 10(−PLd/20)10^{\left(-PL_d / 20\right)}10(−PLd/20).
signalOut = signalIn * 10^(-PLd / 20);  % Appliquer la perte de chemin (en dB) à l'échelle linéaire
Exemple d'utilisation
Supposons que vous ayez un signal d'entrée signalIn, une perte de chemin de référence PL0 de 40 dB, une distance d de 10 mètres, un exposant de perte de chemin n de 2, et un écart type de l'ombrage sigma de 3 dB. Vous pouvez appeler helperDistancePathLoss comme suit :
signalIn = randn(1000, 1);  % Signal d'entrée aléatoire
PL0 = 40;  % Perte de chemin de référence, en dB
d = 10;  % Distance entre les points de la liaison, en mètres
n = 2;  % Exposant de perte de chemin
sigma = 3;  % Écart type de l'ombrage, en dB

[signalOut, PLd] = helperDistancePathLoss(signalIn, PL0, d, n, sigma);
disp(PLd);  % Afficher la perte de chemin causée par la distance
Cette fonction simule l'effet de la perte de chemin dépendante de la distance sur un signal UWB, en tenant compte de l'ombrage et de la décroissance de la puissance avec la distance.
 
Fonction helperFreauencyPathLoss
Ce code MATLAB définit une fonction helperFrequencyPathLoss qui applique une perte de chemin dépendante de la fréquence à un signal d'entrée. Voici une explication détaillée de cette fonction :
Description de la fonction
Inputs
1.	signalIn : Le signal d'entrée à transmettre à travers le canal UWB.
2.	Fc : La fréquence centrale du signal, en Hz.
3.	bw : La largeur de bande du signal, en Hz.
4.	kappa : L'exposant spécifique à l'environnement pour la perte de chemin en fonction de la fréquence.
Outputs
1.	signalOut : Le signal de sortie après application de la perte de chemin dépendante de la fréquence.
2.	PLf : La perte de chemin causée par la fréquence, en dB.
Détails de la fonction
1.	Définition des fréquences et des amplitudes du filtre
o	La gamme de fréquences est définie comme un vecteur allant de -bw/2 à bw/2 avec une résolution de bw/2000.
o	Les amplitudes correspondantes sont calculées selon l'équation donnée, en tenant compte de la fréquence centrale FcFcFc et de l'exposant kappakappakappa.
freq = (-bw/2:bw/2000:bw/2);                  % Filtre pour le signal à bande de base
ampl = 1./((freq+Fc)/Fc).^(2*kappa + 2);      % Amplitudes selon l'équation de la bande passante
2.	Création et visualisation du filtre
o	Un filtre FIR est conçu en utilisant les fréquences et les amplitudes définies précédemment, sauf si la fréquence centrale est la valeur par défaut de 499.2 MHz.
o	Si la fréquence centrale est la valeur par défaut, le numérateur du filtre est chargé à partir d'un fichier pour accélérer l'exécution.
if Fc ~= 499.2e6  % Canal 0 (valeur par défaut)
    filterOrder = 50;
    dLP = fdesign.arbmag(filterOrder, freq/(bw/2), ampl);
    filterFIR = design(dLP, 'firls', 'systemobject', true);
else  % Canal 0, par défaut
    % Charger les coefficients du filtre à partir d'un fichier pour accélérer l'exécution
    load('defaultNumerator', 'numerator');
    filterFIR = dsp.FIRFilter(numerator);
end
3.	Application du filtre au signal d'entrée
o	Le filtre FIR conçu est appliqué au signal d'entrée pour obtenir le signal de sortie.
o	La perte de chemin dépendante de la fréquence PLfPLfPLf est calculée en comparant les amplitudes du signal d'entrée et du signal de sortie, et convertie en dB.
signalOut = filterFIR(signalIn);               % Appliquer les amplitudes par fréquence
PLf = 20 * log10(signalIn ./ signalOut);       % Calculer la perte de chemin en dB
Exemple d'utilisation
Supposons que vous ayez un signal d'entrée signalIn, une fréquence centrale Fc de 5 GHz, une largeur de bande bw de 500 MHz, et un exposant de perte de chemin kappa de 0.5. Vous pouvez appeler helperFrequencyPathLoss comme suit :
signalIn = randn(1000, 1);  % Signal d'entrée aléatoire
Fc = 5e9;  % Fréquence centrale, en Hz
bw = 500e6;  % Largeur de bande, en Hz
kappa = 0.5;  % Exposant de perte de chemin spécifique à l'environnement

[signalOut, PLf] = helperFrequencyPathLoss(signalIn, Fc, bw, kappa);
disp(PLf);  % Afficher la perte de chemin causée par la fréquence
Cette fonction simule l'effet de la perte de chemin dépendante de la fréquence sur un signal UWB, en tenant compte de la fréquence centrale et de la largeur de bande du signal. Elle applique un filtre FIR au signal d'entrée pour modéliser les pertes en fonction de la fréquence.
 
Fonction helperGammaRV
Ce code MATLAB définit une fonction helperGammaRV qui génère une variable aléatoire distribuée selon une loi Gamma en utilisant les paramètres de forme kkk et d'échelle θ\thetaθ. Voici une explication détaillée de la fonction :
Description de la fonction
Inputs
1.	k : Paramètre de forme de la distribution Gamma.
2.	theta : Paramètre d'échelle de la distribution Gamma.
Outputs
1.	g : Variable aléatoire distribuée selon une loi Gamma avec les paramètres spécifiés.
Détails de la fonction
La génération de la variable aléatoire Gamma suit les étapes suivantes :
1.	Génération d'une variable aléatoire Gamma(1, 1)
o	La distribution Gamma(1, 1) est une distribution exponentielle avec un taux de 1.
o	Utilisation de la méthode de l'inverse de la transformée pour générer des variables exponentielles.
g11 = -log(rand(1, floor(k)));
2.	Création d'une variable aléatoire Gamma(floor(k), 1)
o	La somme de floor(k) variables exponentielles donne une variable aléatoire distribuée selon Gamma(floor(k), 1).
gN1 = sum(g11);
3.	Génération d'une variable aléatoire Gamma(mod(k, 1), 1)
o	La partie fractionnaire de kkk est utilisée pour générer une variable aléatoire Gamma.
o	Une méthode de rejet est utilisée pour générer cette variable.
delta = mod(k, 1);
eta = inf;  % Initialisation des valeurs pour garantir que la boucle WHILE démarre
ksi = 0;
while eta > ksi^(delta-1)*exp(-ksi)
  U = rand;
  V = rand;
  W = rand;
  if U < exp(1)/(exp(1)+delta)
    ksi = V^(1/delta);
    eta = W*ksi^(delta-1);
  else
    ksi = 1 - log(V);
    eta = W*exp(-ksi);
  end
end
% ksi est maintenant distribué selon Gamma(delta, 1).
4.	Combinaison des résultats pour obtenir Gamma(k, theta)
o	Les résultats obtenus sont combinés et multipliés par θ\thetaθ pour obtenir la variable aléatoire Gamma finale.
g = theta * (ksi + gN1);
Exemple d'utilisation
Supposons que vous vouliez générer une variable aléatoire Gamma avec un paramètre de forme k=2.5k = 2.5k=2.5 et un paramètre d'échelle θ=1.0\theta = 1.0θ=1.0. Vous pouvez appeler helperGammaRV comme suit :
k = 2.5;
theta = 1.0;
g = helperGammaRV(k, theta);
disp(g);  % Afficher la variable aléatoire Gamma générée
Explication des étapes
1.	Gamma(1, 1) :
o	La première étape génère floor(k) variables exponentielles (Gamma(1, 1)) et les somme pour obtenir une variable aléatoire Gamma(floor(k), 1).
2.	Gamma(mod(k, 1), 1) :
o	La seconde étape utilise la méthode de rejet pour générer une variable aléatoire Gamma pour la partie fractionnaire de kkk.
3.	Combinaison :
o	La dernière étape combine les deux résultats et les ajuste avec le paramètre d'échelle θ\thetaθ pour obtenir la variable aléatoire Gamma(k, theta).
Cette fonction utilise des techniques de simulation aléatoire pour générer des variables aléatoires selon une distribution Gamma, en suivant des méthodes bien établies de génération de variables aléatoires.
 
Fonction helperNakagamiParameters
Ce code MATLAB définit une fonction helperNakagamiParameters qui calcule le paramètre de distribution de Nakagami mmm pour chaque trajet dans un modèle de canal Ultra Wide Band (UWB). Voici une explication détaillée de cette fonction :
Description de la fonction
Inputs
1.	env : Objet de configuration de l'environnement de type uwbChannelConfig contenant les paramètres du modèle de canal.
2.	pathArrivalTimes : Cellule 1xL contenant les temps d'arrivée des trajets pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les temps d'arrivée des trajets à l'intérieur du cluster.
Outputs
1.	nakagamiM : Cellule 1xL contenant les paramètres de distribution de Nakagami mmm pour chaque trajet. Chaque cellule contient un vecteur 1xK représentant les paramètres Nakagami mmm pour les trajets à l'intérieur du cluster.
Détails de la fonction
1.	Initialisation
o	La fonction commence par déterminer le nombre de clusters LLL à partir de la taille de pathArrivalTimes.
o	Un tableau nakagamiM est initialisé pour stocker les paramètres Nakagami mmm.
L = numel(pathArrivalTimes);  % 1xL cellule, chaque élément contient tous les trajets pour un cluster
nakagamiM = cell(1, L);  % Initialisation de la cellule de paramètres Nakagami m
2.	Boucle sur les clusters
o	Pour chaque cluster, le nombre de trajets KLK_LKL est déterminé à partir de la taille de l'élément correspondant dans pathArrivalTimes.
o	Un vecteur de paramètres Nakagami mmm est initialisé pour chaque cluster.
for clusterIdx = 1:L  % Pour chaque cluster
    K_L = numel(pathArrivalTimes{clusterIdx});  % Nombre de trajets par cluster
    nakagamiM{clusterIdx} = zeros(1, K_L);  % Initialisation des paramètres Nakagami m pour le cluster
3.	Boucle sur les trajets
o	Pour chaque trajet dans un cluster, les paramètres Nakagami mmm sont calculés :
	Si le trajet est le premier et que l'environnement a une ligne de vue (LOS) et est de type 'Industrial', le paramètre Nakagami mmm est défini comme env.FirstPathNakagami.
	Sinon, le paramètre Nakagami mmm est calculé en utilisant une distribution log-normale avec des paramètres de moyenne et d'écart type spécifiques à l'environnement et dépendant des temps d'arrivée des trajets.
    for pathIdx = 1:K_L  % Pour chaque trajet dans le cluster
        if pathIdx == 1 && env.HasLOS && strcmp(env.Type, 'Industrial')
            % Le premier composant est modélisé différemment, indépendant du délai de trajet
            nakagamiM{clusterIdx}(pathIdx) = env.FirstPathNakagami;
        else	
            mu_m = env.NakagamiMeanOffset - env.NakagamiMeanSlope * pathArrivalTimes{clusterIdx}(pathIdx);  % Eq. (27) in [1]
            sigma_m = env.NakagamiDeviationOffset - env.NakagamiDeviationSlope * pathArrivalTimes{clusterIdx}(pathIdx);  % Eq. (28) in [1]
            nakagamiM{clusterIdx}(pathIdx) = exp(mu_m + randn * sigma_m);  % Variable aléatoire log-normale
        end
    end
end
Références
•	[1] A. F. Molisch et al., "IEEE 802.15.4a Channel Model-Final Report," Tech. Rep., Document IEEE 802.1504-0062-02-004a, 2005
Exemple d'utilisation
Supposons que vous ayez un objet de configuration env et des temps d'arrivée des trajets pathArrivalTimes définis comme suit :
env.Type = 'Industrial';
env.HasLOS = true;
env.FirstPathNakagami = 2;
env.NakagamiMeanOffset = 1;
env.NakagamiMeanSlope = 0.1;
env.NakagamiDeviationOffset = 0.5;
env.NakagamiDeviationSlope = 0.05;

pathArrivalTimes = { [0, 10, 20], [0, 15, 30] };

nakagamiM = helperNakagamiParameters(env, pathArrivalTimes);
disp(nakagamiM);
Cette fonction calcule les paramètres de distribution de Nakagami mmm pour chaque trajet dans un modèle de canal UWB, en tenant compte des caractéristiques spécifiques de l'environnement et des temps d'arrivée des trajets.
 
Fonction helperPathModeling
Ce code MATLAB définit une fonction helperPathModeling qui génère les temps d'arrivée, les puissances moyennes et les phases des trajets pour un modèle de canal Ultra Wide Band (UWB). Voici une explication détaillée de cette fonction :
Description de la fonction
Inputs
1.	env : Objet de configuration de l'environnement de type uwbChannelConfig contenant les paramètres du modèle de canal.
2.	clusterArrivalTimes : Vecteur 1xL contenant les temps d'arrivée des clusters, en ns.
3.	clusterEnergies : Vecteur 1xL contenant les énergies des clusters.
4.	T_end : Seuil de ratio de puissance entre le dernier et le premier trajet.
5.	Fs : Fréquence d'échantillonnage du canal, en Hz.
Outputs
1.	pathArrivalTimes : Cellule 1xL contenant les temps d'arrivée des trajets pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les temps d'arrivée des trajets à l'intérieur du cluster.
2.	pathAveragePowers : Cellule 1xL contenant les puissances moyennes des trajets pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les puissances moyennes des trajets à l'intérieur du cluster.
3.	pathPhases : Cellule 1xL contenant les phases des trajets pour chaque cluster. Chaque cellule contient un vecteur 1xK représentant les phases des trajets à l'intérieur du cluster.
Détails de la fonction
1.	Initialisation
o	La fonction commence par déterminer le nombre de clusters LLL à partir de la taille de clusterArrivalTimes.
o	Deux variables booléennes sont définies pour déterminer le type de profil de délai de puissance (PDP).
L = numel(clusterArrivalTimes);
continuousPDP = strcmp(env.Type, 'Industrial') || (~env.HasLOS && strcmp(env.Type, 'Indoor office')); 
singleAlternatePDP = ~env.HasLOS && any(strcmp(env.Type, {'Indoor office', 'Industrial'}));
2.	Boucle sur les clusters
o	Pour chaque cluster, les temps d'arrivée et les puissances moyennes des trajets sont initialisés comme des tableaux vides.
for cluster = 1:L 
  pathArrivalTimes{cluster} = [];
  pathAveragePowers{cluster} = [];
3.	Boucle interne pour les trajets
o	La boucle interne génère les temps d'arrivée et les puissances moyennes des trajets jusqu'à ce que la puissance du trajet actuel soit inférieure au seuil TendT_{\text{end}}Tend par rapport à la puissance maximale des trajets précédents.
4.	Temps d'arrivée des trajets
o	Si continuousPDP est vrai, les trajets sont espacés régulièrement.
o	Sinon, les temps d'arrivée sont générés en utilisant un processus de Poisson mixte avec deux taux d'arrivée différents.
  while true
    if ~continuousPDP
      u = rand();
      if u < env.MixtureProbability
        lambda = env.PathArrivalRate1;
      else
        lambda = env.PathArrivalRate2;
      end
      u2 = rand();
      if isempty(pathArrivalTimes{cluster})
        thisInterArrival = 0;
      else
        thisInterArrival = log(u2) * (-1 / lambda); % Temps inter-arrivée exponentiel
      end
      if ~isempty(pathArrivalTimes{cluster})
        thisPathDelay = sum([pathArrivalTimes{cluster}(end) thisInterArrival]);
      else
        thisPathDelay = thisInterArrival;
      end
    else
      stepSize = 1e9; % Un second. Prendre chaque échantillon serait trop coûteux en calcul
      thisPathDelay = stepSize * numel(pathArrivalTimes{cluster}) / Fs;
    end
5.	Puissance moyenne des trajets
o	Si singleAlternatePDP est vrai, une formule alternative est utilisée pour calculer la puissance moyenne des trajets.
o	Sinon, la puissance moyenne est calculée en utilisant une décroissance exponentielle en fonction des temps d'arrivée des trajets.
    if ~singleAlternatePDP
      gamma = env.PathDecaySlope * clusterArrivalTimes(cluster) + env.PathDecayOffset; % Facteur de décroissance intra-cluster
      denominator = gamma * ((1 - env.MixtureProbability) * env.PathArrivalRate1 + env.MixtureProbability * env.PathArrivalRate2 + 1);
      thisAveragePower = clusterEnergies(cluster) * exp(-thisPathDelay / gamma) / denominator;
    else
      thisAveragePower = clusterEnergies(cluster) * (1 - env.FirstPathAttenuation * exp(-thisPathDelay / env.PDPIncreaseFactor)) * ...
        (exp(-thisPathDelay / env.PDPDecayFactor)) * ((env.PDPDecayFactor + env.PDPIncreaseFactor) / env.PDPDecayFactor) / (env.PDPDecayFactor + env.PDPIncreaseFactor * (1 - env.FirstPathAttenuation));
    end
6.	Vérification de la puissance du trajet
o	Si la puissance du trajet actuel est inférieure au seuil, la boucle interne se termine.
o	Sinon, les temps d'arrivée et les puissances moyennes des trajets sont mis à jour.
    if ~isempty(pathAveragePowers{cluster}) && thisAveragePower < T_end * max(pathAveragePowers{cluster})
      break;
    else
      pathArrivalTimes{cluster} = [pathArrivalTimes{cluster} thisPathDelay]; % en ns
      pathAveragePowers{cluster} = [pathAveragePowers{cluster} thisAveragePower];
    end
  end

  % Appliquer une phase uniformément distribuée (dans [0, 2*pi]) -> bande de base complexe
  K_L = numel(pathArrivalTimes{cluster});
  pathPhases{cluster} = 2 * pi * rand(1, K_L);
end
Références
•	[1] A. F. Molisch et al., "IEEE 802.15.4a Channel Model-Final Report," Tech. Rep., Document IEEE 802.1504-0062-02-004a, 2005
Exemple d'utilisation
Supposons que vous ayez un objet de configuration env, des temps d'arrivée des clusters clusterArrivalTimes, des énergies des clusters clusterEnergies, un seuil T_end de 0.01 et une fréquence d'échantillonnage Fs de 1 GHz. Vous pouvez appeler helperPathModeling comme suit :
env.Type = 'Industrial';
env.HasLOS = true;
env.MixtureProbability = 0.5;
env.PathArrivalRate1 = 0.1;
env.PathArrivalRate2 = 0.2;
env.PathDecaySlope = 0.5;
env.PathDecayOffset = 1.0;
env.FirstPathAttenuation = 0.3;
env.PDPIncreaseFactor = 0.7;
env.PDPDecayFactor = 0.9;

clusterArrivalTimes = [0, 50, 100]; % en ns
clusterEnergies = [1, 0.8, 0.6];
T_end = 0.01;
Fs = 1e9; % en Hz

[pathArrivalTimes, pathAveragePowers, pathPhases] = helperPathModeling(env, clusterArrivalTimes, clusterEnergies, T_end, Fs);
disp(pathArrivalTimes);
disp(pathAveragePowers);
disp(pathPhases);
Cette fonction génère les temps d'arrivée, les puissances moyennes et les phases des trajets pour un modèle de canal UWB, en tenant compte des caractéristiques spécifiques de l'environnement et des clusters.
Fonctione helperPoissonRV
Ce code MATLAB définit une fonction helperPoissonRV qui génère une variable aléatoire selon une distribution de Poisson en utilisant le paramètre λ\lambdaλ. Voici une explication détaillée de cette fonction :
Description de la fonction
Inputs
1.	lambda : Paramètre de la distribution de Poisson (taux moyen d'occurrence d'un événement).
Outputs
1.	x : Variable aléatoire générée selon la distribution de Poisson avec le paramètre λ\lambdaλ.
Détails de la fonction
1.	Initialisation
o	La fonction initialise la variable de sortie x à 0.
o	Une variable p est initialisée à 0 pour accumuler les valeurs logarithmiques.
o	Une variable booléenne whileFlag est initialisée à true pour contrôler la boucle while.
x = 0;
p = 0;
whileFlag = true;
2.	Boucle pour générer la variable de Poisson
o	La boucle while continue jusqu'à ce que la condition soit remplie.
o	À chaque itération, un nombre aléatoire uniforme est généré, et son logarithme est ajouté à p.
o	Si p dépasse λ\lambdaλ, la boucle se termine.
o	Sinon, x est incrémenté de 1.
while (whileFlag)
  p = p - log(rand());
  if (p > lambda)
    whileFlag = false;
  else
    x = x + 1;
  end
end
Explication du processus
La méthode utilisée pour générer la variable de Poisson est basée sur l'algorithme des sommes logarithmiques, qui est une méthode courante pour générer des variables aléatoires de Poisson. Voici les étapes de cet algorithme :
1.	Initialisation : Commencez avec x=0x = 0x=0 et p=0p = 0p=0.
2.	Génération et accumulation : À chaque itération, générez un nombre aléatoire uniforme UUU dans l'intervalle [0, 1], calculez son logarithme naturel log⁡(U)\log(U)log(U), et ajoutez-le à ppp.
3.	Vérification de la condition : Si ppp dépasse λ\lambdaλ, la boucle se termine et la valeur de xxx est renvoyée.
4.	Incrémentation de xxx : Si ppp ne dépasse pas λ\lambdaλ, incrémentez xxx de 1 et continuez la boucle.
Exemple d'utilisation
Supposons que vous vouliez générer une variable de Poisson avec un paramètre λ=5\lambda = 5λ=5. Vous pouvez appeler helperPoissonRV comme suit :
lambda = 5;
poissonRV = helperPoissonRV(lambda);
disp(poissonRV);  % Affiche la variable aléatoire de Poisson générée
Cette fonction utilise des techniques de simulation aléatoire pour générer des variables aléatoires selon une distribution de Poisson, en suivant un algorithme basé sur les sommes logarithmiques.







