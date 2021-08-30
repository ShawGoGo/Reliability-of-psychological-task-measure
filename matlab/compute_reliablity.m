clear all
clc

% for computing cronbach's alpha with sample data
load('sample_data_internalconsistency.mat');
parti_no=40;
item_no=20;
item_score=sample_data.score;
item_score=reshape(item_score,item_no,parti_no)';
alpha=cronbach(item_score);

%% for computing Monte carlo with 5000 replications
replication=5000;
total_corr=[];
participants=sample_data.participants;
item_score=sample_data.score;
for i_rep=1:replication
    temp_twosets_m=[];
for i_parti = 1:parti_no
    temp_parti_scores=item_score(participants==i_parti);
    temp_twosets=[];
    for i_item=1:item_no
        rand_ind1=randperm(item_no);
        temp_twosets(i_item,1)=temp_parti_scores(rand_ind1(1));
        rand_ind2=randperm(item_no);
        temp_twosets(i_item,2)=temp_parti_scores(rand_ind2(1));
    end
    temp_twosets_m(i_parti,:)=mean(temp_twosets);
end
[r p]=corr(temp_twosets_m(:,1),temp_twosets_m(:,2));
total_corr(i_rep,1)=r;
end
Monte_carlo_coef = mean(total_corr);

%% for compute ICC with two sessions' data for test-retest reliablity
clear all
clc
load('sample_data_test_retest.mat')
session1=sample_data.session1;
session2=sample_data.session2;
%'A-1' type is corresponding to the two-way random, absolute consistency,and single rater/measurement in R script with icc function
[r, LB, UB, F, df1, df2, p] = ICC([session1,session2], 'A-1');
%% for compute SEM with two sessions' data for measurement error
sem = SEM([session1,session2]);