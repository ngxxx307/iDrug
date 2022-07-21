load DrugDisease

[positiveId, crossval_id] = train_test_split(DrugDisease, 5, '1');

PtrainID = positiveId(find(crossval_id~=1));
PtestID  = positiveId(find(crossval_id==1));

negativeID = find(DrugDisease==0);
num = numel(negativeID);
Nidx = randperm(num);
NtestID = negativeID(Nidx(1:length(PtestID)))

disp(numel(DrugDisease))
disp(size(negativeID))
disp(size(positiveId))
