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
% patm	:	Pression atmosphérique
% efilm_mm	:	On donne l'épaisseur du film d'eau à la surface du fruit

%----------------------------------------------------------------------
% Données variables (différentes d'un élève à l'autre)
% Ce sont les donnnées correspondant au code 'V' de votre fichier Excel
%----------------------------------------------------------------------
% Dcm	:	Diamètre
% Tcels	:	Température
% psipercent	:	Humidité relative
% Uinf	:	Vitesse



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
load LennardJonesData


Rgp = 8.314 ;
patm = 101325 ;
T = Tcels + 273.15 ;
efilm = efilm_mm / 1e3 ;


psi = psipercent / 100 ;
D = Dcm / 100 ;
MH2O = 18e-3 ;
rhoeau = 1e3 ;

% ----------------------------------------------------------------------
% Pression de vapeur saturante
% ----------------------------------------------------------------------
psat = psath2o (T) ;

% ----------------------------------------------------------------------
% Calcul coefficients de diffusion, viscosités, densité
% ----------------------------------------------------------------------
p_in_atm = patm / 101325 ;
 
DAV = DABChapman_Enskog (T, p_in_atm, ...
			 LJdata.Air.M, LJdata.Water.M, ...
			 LJdata.Air.epssurk, LJdata.Water.epssurk, ...
			 LJdata.Air.sigma, LJdata.Water.sigma ) ;

mu = muChapman_Enskog (T, ...
		       LJdata.Air.M, ...
		       LJdata.Air.epssurk, ...
		       LJdata.Air.sigma) ;

rho = patm .* (LJdata.Air.M /1000) ./ (Rgp * T) ;
nu = mu ./ rho ;

% ----------------------------------------------------------------------
% Nombres adimensionnels
% ----------------------------------------------------------------------
Re = Uinf .* D ./ nu ;
Sc = nu ./ DAV ;
Sh = 2 + ( 0.4 * Re.^(1/2) + 0.06 * Re.^(2/3) ) .* Sc.^0.4 ;

% ----------------------------------------------------------------------
% Coefficient de transfert convectif
% ----------------------------------------------------------------------
km = Sh .* DAV ./ D ;

% ----------------------------------------------------------------------
% Concentrations en vapeur d'eau
% ----------------------------------------------------------------------
Csat = psat ./ (Rgp .* T) ;
Cvsurf = Csat ;
Cvinf  = Csat .* psi ;

% ----------------------------------------------------------------------
% Flux
% ----------------------------------------------------------------------
mpointv = km .* pi.*D.^2 .* (Cvsurf - Cvinf) * MH2O ;

% ----------------------------------------------------------------------
% Flux
% ----------------------------------------------------------------------
tau = rhoeau .* efilm ./ (km .* (Cvsurf - Cvinf) * MH2O) ;
