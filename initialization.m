
% The folow parameter settings are suggested to reproduct most of the 
% experimental results of CDMM, and a better performance will be obtained 
% by tuning the parameters.
% -------------------------------------------------------------------------
% Parameters : alpha, lambda, C, kernel_para, eta, epsilon
% -------------------------------------------------------------------------
% emotions       : 10^-5, 10^4, 10^2, 10^-2, 0.8, 10^-2
% yeast          : 10^-4, 10^5, 10^0, 0.5, 0.8, 10^-2
% -------------------------------------------------------------------------
% =======================================================================================
function [optmParameter,modelparameter] =  initialization
    optmParameter.alpha   = 10^-4;  
    optmParameter.lambda  = 10^5;  
    optmParameter.C       = 1.0;
    optmParameter.kernel_para     =0.5;
    optmParameter.eta=0.8;
    optmParameter.epsilon=1e-2;
    %%search para
    optmParameter.updateTheta       = 1;
    optmParameter.outputthetaQ      = 1;
    %% Model Parameters
    modelparameter.normliza           = 1; %
    modelparameter.tuneThresholdType  = 1; % 1:Hloss, 2:Acc, 3:F1, 4:LabelBasedAccuracy, 5:LabelBasedFmeasure, 6:SubACC 
    modelparameter.crossvalidation    = 1; % {0,1}
    modelparameter.cv_num             = 5;
    modelparameter.L2Norm             = 1; % {0,1}
    modelparameter.splitpercentage    = 0.8; %[0,1]
end