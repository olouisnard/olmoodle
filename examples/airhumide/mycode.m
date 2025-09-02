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
% patm	:	Atmospheric pressure is

%----------------------------------------------------------------------
% Données variables (différentes d'un élève à l'autre)
% Ce sont les donnnées correspondant au code 'V' de votre fichier Excel
%----------------------------------------------------------------------
% Tcels	:	The dry thermometer of a meteorological station indicates a temperature
% psipercent	:	The moist sensor indicates a relative humidity



%======================================================================
% Vous devez modifier les lignes suivantes (en remplaçant zzz par vos
% propres calculs)
%
% C'est ici que vous devez :
%
%  . calculer les données secondaires découlant du jeu de données en
%     entrée (code 'C' dans votre fichier Excel) à partir des données
%     d'entrées (listées ci-dessus)
%
%  . calculer les bonnes réponses aux questions (code 'Q' dans votre
%     fichier Excel) à partir des données d'entrées (listées
%     ci-dessus)
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
Rgp = 8.314 ;
Ma = 28.965e-3 ;
Mv = 18.01528e-3 ;
muv = Mv /Ma ;

cpa = 1005 ;
cpv = 1820 ;
Lv = 2.5013e6 ;

%----------------------------------------------------------------------
% Conversions
%----------------------------------------------------------------------
T = 273.15 + Tcels ;
psi = psipercent / 100 ;

%----------------------------------------------------------------------
% Humidité absolue
%----------------------------------------------------------------------
w = muv * psi ./ (patm./psath2o(T, 1) - psi) ;
wgperkg = w * 1000 ;

%----------------------------------------------------------------------
% Volume massique par unité de masse AS
%----------------------------------------------------------------------
v = Rgp * T ./ (patm * Ma) .* (muv + w) / muv ;

%----------------------------------------------------------------------
% Enthalpie par unité de masse AS
%----------------------------------------------------------------------
h = cpa*Tcels + w .* (Lv + cpv *Tcels) ;
hkJperkg = h / 1000 ;

