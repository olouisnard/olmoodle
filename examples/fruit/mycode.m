% -*- coding: utf-8 -*-

%######################################################################
%
% The following variables will be pre-defined when this code will be
% executed. They will be fed with the data you specified in your Excel
% source file
%
%######################################################################
%
%======================================================================
% Fixed input data (identical for all students)
% These are the data corresponding to 'F' code in your Excel file.
%======================================================================
% patm	:	Pression atmosphérique
% efilm_mm	:	On donne l'épaisseur du film d'eau à la surface du fruit

%======================================================================
% Variable input data (different from one student to the other)
% These are the data corresponding to 'V' code in your Excel file.
%======================================================================
% Dcm	:	Diamètre
% Tcels	:	Température
% psipercent	:	Humidité relative
% Uinf	:	Vitesse



%######################################################################
%
% You must modify the folllowing executable lines (replacing zzz by
% your own computations)
%
% Ti is here that you must
%
%  . compute the secondary input data ('C' code in your Excel
%     file) in function of the inputs (listed above).
%
%  . compute the correct answers to questions ('Q' code in your 
%     Excel file) in function of the inputs (listed above).
%
% Of course, generally, you will need other intermediate variables to
% manage your computations in a clean manner. You are free to write
% anything, within the limits of MATLAB syntax.
%
%
% IMPORTANT : since there are several datasets, all the variables
% manipulated below are vectors, each element of the vector
% corresponding to a single dataset If you are familiar with MATLAB,
% you are used to this. Otherwise, it's easy, all you have to know is
% that you should use systematically the following operators:
%   .* instead of * to multiply
%   ./ instead of / to divide
%   .^ instead of ^ to exponentiate
%
% To add or substract, use classically the operators + and -.
%
% Often, if you already have programmed your exercise solution in
% MATLAB before using this tool, you will just have to copy the lines
% of your existing MATLAB file, with some marginal adaptations.
%
%######################################################################
%
%======================================================================
% Calculated input data 
% These are the data corresponding to code 'C' in your Excel file.
%======================================================================
%----------------------------------------------------------------------
% Pression de valeur saturante de l’eau à la température donnée
%----------------------------------------------------------------------
psat = zzz ; 

%----------------------------------------------------------------------
% Coefficient de diffusion air/vapeur d’eau
%----------------------------------------------------------------------
DAV = zzz ; 

%----------------------------------------------------------------------
% Viscosité cinématique de l’air
%----------------------------------------------------------------------
nu = zzz ; 

%======================================================================
% Answers asked to student
% These are the data corresponding to code 'Q' in your Excel file.
%======================================================================
%----------------------------------------------------------------------
% Nombre de Reynolds
%----------------------------------------------------------------------
Re = zzz ; 

%----------------------------------------------------------------------
% Nombre de Schmidt
%----------------------------------------------------------------------
Sc = zzz ; 

%----------------------------------------------------------------------
% Nombre de Sherwood
%----------------------------------------------------------------------
Sh = zzz ; 

%----------------------------------------------------------------------
% Coefficient d'échange
%----------------------------------------------------------------------
km = zzz ; 

%----------------------------------------------------------------------
% Concentration en vapeur à la surface
%----------------------------------------------------------------------
Cvsurf = zzz ; 

%----------------------------------------------------------------------
% Concentration en vapeur incidente
%----------------------------------------------------------------------
Cvinf = zzz ; 

%----------------------------------------------------------------------
% Flux massique d'évaporation
%----------------------------------------------------------------------
mpointv = zzz ; 

%----------------------------------------------------------------------
% Calculez le temps total d'évaporation
%----------------------------------------------------------------------
tau = zzz ; 

