function main(rank1, rank2, w, alpha, beta, gamma, DorT, scenario, k)

    if nargin < 9
        k = 20;
    end

    if nargin < 8
        scenario = '1';
    end

    if nargin < 7
        DorT = '1';
    end


    if nargin < 6
        gamma = 0.01;
    end
    
    if nargin < 5
        beta = 0.01;
    end
    
    if nargin < 4
        alpha = 0.01;
    end

    if nargin < 3
        w = 0.3;
    end

    if nargin < 2
        rank2 = 90;
    end

    if nargin < 1
        rank1 = 70;
    end

load DiseaseSimMat;
load DrugDisease;
load DrugSimMat1;
load DrugSimMat2;
load DrugTarget;
load SMat;
load TargetSimMat;


X = {}; % contain binary interaction of drug-disease and drug-target
Au = {};
Av = {};

if DorT == '2'
    X{2} = DrugDisease;
    X{1} = DrugTarget;
    Au{2} = DrugSimMat1;
    Au{1} = DrugSimMat2;
    Av{2} = DiseaseSimMat;
    Av{1} = TargetSimMat;
    S = SMat';
end

if DorT == '1'
    X{1} = DrugDisease;
    X{2} = DrugTarget;
    Au{1} = DrugSimMat1;
    Au{2} = DrugSimMat2;
    Av{1} = DiseaseSimMat;
    Av{2} = TargetSimMat;
    S = SMat; % mapping matrix for two domain.
end


yy = X{1};
nfolds = 5;
para = [alpha, beta, gamma];


[positiveId, crossval_id] = train_test_split(X{1}, nfolds, scenario);

AUPR = zeros(nfolds,1);
AUC = zeros(nfolds, 1);

[U, V, objs] = iDrug(X, w, Au, Av, S, rank1, rank2, para);
predX = U{1} * V{1}'
writematrix(predX, 'modelPrediction.csv')

% for fold = 1:nfolds
%     X{1} = yy;
%     PtrainID = positiveId(find(crossval_id~=fold));
%     PtestID  = positiveId(find(crossval_id==fold));
% 
%     % sample equal amount of negative sample
%     negativeID = find(X{1}==0);
%     num = numel(negativeID);
%     Nidx = randperm(num);
%     NtestID = negativeID(Nidx(1:length(PtestID)));
% 
%     X{1}(PtestID) = 0; % mask out the test data
%     
%     %nid = find(X{1}==0);
%     %X{1}(nid) = mean(mean(X{1}))+0.05; % initilzation for strategy 2 and 3 to avoild zero block
% 
%     tic
%     [U, V, objs] = iDrug(X, w, Au, Av, S, rank1, rank2, para);
%     time =toc;
%     
%     predX = U{1} * V{1}';
%     
%     testScore = [yy(PtestID); yy(NtestID)];
%     pred = [predX(PtestID); predX(NtestID)];
%     [auc1, aupr, rocx, rocy, prx, pry] = auc(testScore(:), pred(:), 1e-6);
% 
%     if scenario == '2' || scenario == '3'
%         [B,I] = sort(pred,'descend');
%         prec = sum(testScore(I(1:k)) == 1) / min(k, sum(testScore == 1));
%         fprintf('precision %f \n',prec);
%     end
% 
% 
%     fprintf('%d-Fold: the AUPR score  %d, the AUC score:  %d, running time %f \n', fold, aupr, auc1, time);
%     AUPR(fold,1) = aupr;
%     AUC(fold, 1) = auc1;
% 
%     
% 
% 
% end


% auprs = mean(AUPR);
% aucs = mean(AUC);
% fprintf('The averaqge of AUPdispR and AUC score: %d,  %d \n',  auprs, aucs);
% 
% figure(1)
% subplot(1,3,1);
% plot(rocx, rocy);
% xlabel('FPR');
% ylabel('TPR');
% title('(a) AUROC')
% 
% subplot(1,3,2);
% plot(prx, pry);
% xlabel('Recall');
% ylabel('Precision');
% title('(a) AUPR')
% 
% % check the convergence
% subplot(1,3,3)
% plot(objs);
% xlabel('Number of Iteration');
% ylabel('Objective value');
% title('Convergence')

end








