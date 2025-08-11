%======================================================================
%
% Les variables suivantes seront pré-définies lorsque ce code  
% sera appelé 
%
%======================================================================
% patm	:	La pression atmosphérique vaut

% Tcels	:	Le thermomètre sec d’une centrale météorologique indique une température
% psipercent	:	Le capteur d'humidité indique une humidité relative




%======================================================================
%
% Vous devez modifier les lignes suivantes
%
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

