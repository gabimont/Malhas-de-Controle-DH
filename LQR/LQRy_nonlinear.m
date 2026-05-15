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

%% EScolher voo em modo control theta ou control altitude
% att_alt = 1; attitude theta
% att_alt = 0; altitude

load('DH.mat')
att_alt = 0;

%% Modelo nao linear
open('Close_loop_nao_linear.slx')
sim('Close_loop_nao_linear.slx')
