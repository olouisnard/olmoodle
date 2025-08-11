%======================================================================
%
% Les variables suivantes seront pré-définies lorsque ce code  
% sera appelé 
%
%======================================================================
% efilm_mm	:	Épaisseur film

% Dcm	:	Diamètre
% Tcels	:	Température
% psipercent	:	Humidité relative
% Uinf	:	Vitesse




%======================================================================
%
% Vous devez modifier les lignes suivantes
%
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
