
function [model_CDMM] = CDMM( X_set, Y, optmParameter, num_views)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% optimization parameters
    alpha          = optmParameter.alpha;
    lambda          = optmParameter.lambda;
    C                     =optmParameter.C;

    kernel_para     =optmParameter.kernel_para;
   %% Initialization
    theta = ones(num_views,1)/num_views;
    OutputWeight=cell(num_views,1);
    PreY=cell(num_views,1);
    prediction_Loss       = zeros(num_views,1);
    Omega_train=cell(num_views,1);  
    n=size(Y,1);
    H = -ones(n,n)/n + eye(n); 
    K = zeros(n,n);
   %% Optimization

            for v = 1: num_views
                Omega_train{v} = kernel_matrix(X_set{v}, kernel_para);
            end 
            for uu=1:num_views
                j = 1 : num_views;
                index = setdiff(j,uu);
                for ii = 1: length(index)
                    Ktemp = H * Omega_train{index(ii)} * H;
                    K = K + Ktemp;
                end

                [OutputWeight{uu},PreY{uu}] = kSLFNtrain(Omega_train{uu}, Y, C, alpha,K);
      
                prediction_Loss(uu)=trace((PreY{uu}-Y)'*(PreY{uu}-Y));
            end
              %% update theta: Coordinate descent
               if optmParameter.updateTheta == 1
                   theta  = updateTheta(theta, lambda, prediction_Loss);
               end

               if optmParameter.outputthetaQ == 1
                   fprintf(' - prediction loss: ');
                   for mm=1:num_views
                        fprintf('%e, ', prediction_Loss(mm));
                   end
                   fprintf('\n - theta: ');
                   for mm=1:num_views
                        fprintf('%.3f, ', theta(mm));
                   end
                   fprintf('\n');
               end
            % return values
            model_CDMM.W = OutputWeight;
            model_CDMM.PreY = PreY;
            model_CDMM.theta = theta;
            model_CDMM.kernel_para = kernel_para;
end

function [theta_t ] = updateTheta(theta, lambda, q)
    m = length(theta);
    negative = 0;
    theta_t = zeros(m,1);
    
    for i =1:m
       theta_t(i,1) = (lambda+sum(q) - m*q(i))/(m*lambda);
       if theta_t(i,1) < 0
           negative = 1;
           theta_t(i,1) = 0.0000001;
       end
    end
    if negative == 1
       theta_t = theta_t./sum(theta_t);
    end
end

