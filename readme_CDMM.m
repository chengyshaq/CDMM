%%%%%%%%%%%
% This is an examplar file on how the CDMM [1] program could be used.
%[1] Zhao D, Gao Q, Lu Y, et al. Consistency and diversity neural network multi-view multi-label learning[J]. Knowledge-Based Systems, 2021: 106841.
%- This package was developed by Mr. Da-Wei Zhao (zhaodwahu@163.com). For any
% problem concerning the code, please feel free to contact Mr. Zhao.
%%%%%%
clear;clc
addpath(genpath('.'));
load('yeast.mat')
starttime = datestr(now,0);
fprintf('Start Run CDMM at time:%s \n',starttime);
%% Initialization

[optmParameter,modelparameter] =  initialization;
time = zeros(1,modelparameter.cv_num);
num_views=length(dataMVML);
%% Procedures of Training and Test for CDMM
fprintf('Running CDMM\n');  

%% cross validation
num_data = size(dataMVML{1},1);
if modelparameter.normliza==1
    for i = 1:num_views
        dataMVML{i} = normalization(dataMVML{i}, 'l2', 1);
    end
end
randorder = randperm(num_data);
cvResult  = cell(modelparameter.cv_num,1);
models = cell(modelparameter.cv_num,1);
cv_num=modelparameter.cv_num;
for cv = 1:cv_num
    fprintf('Cross Validation - %d/%d\n', cv, cv_num);
    [cvTrainSet,cvTrain_target,cvTestSet,cvTest_target ] = generateMultiViewCVSet(dataMVML, target, randorder, cv, modelparameter.cv_num);
    tic
    T = LabelCorrelation( cvTrainSet,cvTrain_target',optmParameter );
    cvCDMM   = CDMM(cvTrainSet, double(cvTrain_target*T), optmParameter, num_views);
    fprintf('\nMulti-view multi-label classification results:\n---------------------------------------------\n');
    cvResult{cv} = CDMM_Predict(cvTestSet, cvTest_target', cvCDMM, modelparameter, cvTrainSet, cvTrain_target');
    models{cv} = cvCDMM;
    time(1,cv) = toc;
end

[Avg_Result, averagetime] = PrintCDMMAvgResult(cvResult, time, modelparameter.cv_num);

model_CDMM.randorder = randorder;
model_CDMM.optmParameter = optmParameter;
model_CDMM.modelparameter = modelparameter;
model_CDMM.models = models;
model_CDMM.cvResult = cvResult;
model_CDMM.avg_Result = Avg_Result;
model_CDMM.averagetime = averagetime;
endtime = datestr(now,0);
fprintf('End Run CDMM at time:%s \n',endtime);
rmpath(genpath('.'));
beep;
