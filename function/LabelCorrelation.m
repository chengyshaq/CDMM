function T = LabelCorrelation( X,Y,para )

eta=para.eta;
epsilon=para.epsilon;
num_views=length(X);
%% Construct affinity matrix
num_label=size(Y,1);
% Label similarity
A1 = 1-pdist2( Y+eps, Y+eps, 'jaccard' );
A2=zeros(num_label);

B=cell(length(X),1);
for i=1:num_views
    B{i} = 1-pdist2( Y*X{i}+eps, Y*X{i}+eps, 'seuclidean' );    
    if abs(B{i})<epsilon
       B{i}= 0;
    end
    A2=A2+B{i};
end

A2=A2/num_views;
A = eta.*A1 + (1-eta).*A2;

A(A<epsilon) = 0;
A(isnan(A)) = 0;

% Affinity matrix
D = sum(A, 2) + (1e-10);
D = sqrt(1./D); % D^(-1/2)
D = spdiags(D, 0, num_label, num_label);
T = D*A*D;

end

