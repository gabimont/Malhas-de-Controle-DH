%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
%             Project DH mode Plane                %
% Author: Huascar Mirko Montecinos Cortez          %
% Data init: 24/April/2026                         %
% Data end:  --/-------/----                       %
% Technological Institute of Aeronautics - ITA     %
% Electronic Devices and Systems (EEC-D)           %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Technological Institute of Aeronautics
% Electronic Devices and Systems (EEC-D)
% Copyright 2026 Regents of the Technological Institute of Aeronautics.
% All rights reserved.

clear
clc
bdclose all
close all

load('DH.mat')

%% Modelo nao linear (sempre rodado em modo step de theta)
open('Close_loop_nao_linear.slx')
sim('Close_loop_nao_linear.slx')
