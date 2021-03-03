
function result = CDMM_Predict(Xtest_set, Ytest, model_CDMM, modelparameter, Xtrain_set, Ytrain)
    num_views = size(Xtest_set,1);
    [num_class,num_test] = size(Ytest);
    result = zeros(16,1);
    CDMM_funsion_outputs = zeros(num_class,num_test);
    kernel_para=model_CDMM.kernel_para;
    W=model_CDMM.W;
    theta=model_CDMM.theta;
    parfor i = 1:num_views

        Omega_test = kernel_matrix(Xtrain_set{i}, kernel_para, Xtest_set{i});
        Outputs=(Omega_test' * W{i});
        Outputs      = Outputs';
        CDMM_funsion_outputs    = CDMM_funsion_outputs + theta(i).*Outputs;
    end
   %% VLSF funsion
    threshold = tuneThresholdMVML(Xtrain_set, Ytrain, model_CDMM, modelparameter);

    Pre_Labels   = CDMM_funsion_outputs >= threshold(1,1); 
    Pre_Labels   = double(Pre_Labels);
    result(:,1)  = EvaluationAll(Pre_Labels,CDMM_funsion_outputs,Ytest);
end

function threshold = tuneThresholdMVML(Xtrain_set, Ytrain, model_CDMM, modelparameter)
    num_views = size(Xtrain_set,1);
    CDMM_funsion_outputs = zeros(size(Ytrain'));
    PreY=model_CDMM.PreY;
    theta=model_CDMM.theta;
    tuneThresholdType=modelparameter.tuneThresholdType;
    parfor i = 1:num_views    
        Outputs= PreY{i};

        CDMM_funsion_outputs  = CDMM_funsion_outputs + Outputs*theta(i);
    end
    [ threshold,  ~] = TuneThreshold( CDMM_funsion_outputs', Ytrain, 1, tuneThresholdType);
end