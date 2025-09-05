% -*- coding: utf-8 -*-

%======================================================================
% Les variables suivantes seront pré-définies lorsque ce code sera
% appelé. Elles seront remplies à partir des données que vous avez
% spécifiées dans votre fichier Excel
%======================================================================
%----------------------------------------------------------------------
% Données fixes (identiques pour tous les élèves)
% Ce sont les donnnées correspondant au code 'F' de votre fichier Excel
%----------------------------------------------------------------------
% h	:	Hauteur de liquide
% rho	:	Masse volumique du liquide
% mu	:	Viscosité du liquide

%----------------------------------------------------------------------
% Données variables (différentes d'un élève à l'autre)
% Ce sont les donnnées correspondant au code 'V' de votre fichier Excel
%----------------------------------------------------------------------
% L	:	Longueur :
% Dmm	:	Diamètre :
% Qlperh	:	Débit volumique :
% rugmicron	:	Rugosité :



%======================================================================
% Vous devez modifier les lignes suivantes (en remplaçant zzz par vos
% propres calculs)
%
% C'est ici que vous devez écrire :
%
%  . calculer les données découlant du jeu de données en entrée (code
%    'C' dans votre fichier Excel) et que vous voulez afficher dans
%    votre question
%
%  . calculer les bonnes réponses aux questions (code 'Q' dans votre
%    fichier Excel) à partir des données d'entrées (listées ci-dessus)
%
% Bien sûr, en général, vous aurez besoin d'autres variables
% intermédiaires pour conduire vos calcul proprement. Vous êtes libres
% de tout écrire, dans la limite de la syntaxe MATLAB.
%
%
% IMPORTANT : puisqu'il y a plusieurs jeux de données, toutes les
% variables ci-dessous doivent être des vecteurs de valeurs, chaque
% élément du vecteur correspondant à un jeu de donnée.  Si vous êtes
% familiers avec MATLAB, vous êtes habitués. Sinon, c'est facile il
% vous suffit d'utiliser systématiquement les symboles :
%   .* au lieu de * pour multiplier
%   ./ au lieu de / pour diviser
%   .^ au lieu de ^ pour exposant
%
% Pour l'addition et la soustraction c'est classiquement + et -.
%
% En général, si vous avez déjà traité l'exercice dans matlab, il
% vous suffira de recopier les lignes de votre fichier matlab
% existant, avec quelques adaptations.
%======================================================================
% Constantes
g = 9.81 ;

% Conversions 
Q = Qlperh / 3600 / 1e3 ;
D = Dmm / 1e3 ;
rug = rugmicron / 1e6 ;

S = pi * D.^2/4 ; % Section tube
v = Q ./ S ; % Vitesse


%----------------------------------------------------------------------
% Le nombre de Reynolds
%----------------------------------------------------------------------
Re = v .* D .* rho ./ mu ; % Reynolds

epset = rug ./ D ; % Rugosité relative

un_sur_racine_de_f = -1.8 * log10 ( 6.9./Re + (epset/3.7).^1.11);

f = 1 ./ un_sur_racine_de_f.^2; % Facteur de perte de charge


%----------------------------------------------------------------------
% La hauteur de pertes de charge
%----------------------------------------------------------------------
hv = f .* L ./ D .* v.^2 / (2*g) ; % Hauteur de perte de charge

%----------------------------------------------------------------------
% La puissance de la pompe
%----------------------------------------------------------------------
Wpu = rho .* g .* Q .* (hv + h) ; 
