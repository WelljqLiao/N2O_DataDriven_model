% -*- coding: GBK -*-
% Created on Sat May 14 2022 by Jiaqiang Liao
% ����Ԥ����ɸѡģ�ͣ�ΪN2O_04_Final_anlysis��׼��
%% 1.���ݵ���
clc,clear all
% Ctrl+R ����ע��
% Ctrl+T ȥ��ע��

% N2O data read  
datapath = 'D:\�о���ѧϰ\��ѭ��\N map\data\';
input = strcat(datapath,'Field nitrous oxide emission_by Lizhaolei.csv');

N2O_u = xlsread(input);  %��ȡN2Oԭʼ���ݿ�
N2O_u = fillmissing(N2O_u,'movmean',6016);%ȡ��ֵ���ȱʧֵ

MAT = N2O_u(:,8); 
MAP = N2O_u(:,9);
% sand = N2O_u(:,12);
% silt = N2O_u(:,13);
% clay = N2O_u(:,14);
BD = N2O_u(:,15);
pH = N2O_u(:,16);
SOC = log(N2O_u(:,17));
TN = log(N2O_u(:,19));
TP = log(N2O_u(:,21));
MBC = log(N2O_u(:,22));
MBN = log(N2O_u(:,23));
NO3 = log(N2O_u(:,25));
NH4 = log(N2O_u(:,26));
SM = N2O_u(:,30);

N2O_x = [MAT,MAP,BD,pH,SOC,TN,TP,SM,MBC,MBN,NO3,NH4];
N2O_y = N2O_u(:,28);

% ȡ����
N2O_y = log(N2O_y);

% ȥȱʧֵ
% N2O_X = fillmissing(N2O_x,"constant",0); 
% N2O_Y = fillmissing(N2O_y,'constant',0);

% ���ݱ�׼��
% N2O_X = mapminmax(N2O_X);
% N2O_Y = mapminmax(N2O_Y);

N2O = [N2O_X,N2O_Y];

%% 2.��ѵ�����Ͳ��Լ�Ч�����ӻ���observe vs predict��

% ����ѵ�����Ͳ��Լ�
[ndata, D] = size(N2O_X);          %ndata��������Dά��
R = randperm(ndata,round(0.2*ndata));                    %1��n��Щ��������ҵõ���һ���������������Ϊ����
N2O_X_test = N2O_X(R,:);    %��������ǰ20%�����ݵ���Ϊ��������Xtest
N2O_Y_test = N2O_Y(R,:);
N2O_X(R,:) = [];
N2O_Y(R,:) = [];
N2O_X_train = N2O_X;           %ʣ�µ�������Ϊѵ������Xtraining
N2O_Y_train = N2O_Y;

%% 2.1 Random Forest
[trainedModel,validationRMSE,validationR2] = trainRegressionModel_RF(N2O_X_train,N2O_Y_train);
% ѵ��������
prdeict_N2O_RF = trainedModel.predictFcn(N2O_X_train);
plotregression(N2O_Y_train,prdeict_N2O_RF)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Random Forest','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\RF-1.jpg')

plot(N2O_Y_train,'r')
hold on
plot(prdeict_N2O_RF,'b')
legend('Observerd N2O','Predict N2O')   
title('Random Forest','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\RF-2.jpg')

% ���Լ�����
prdeict_N2O_RF_test = trainedModel.predictFcn(N2O_X_test);
plotregression(N2O_Y_test,prdeict_N2O_RF_test)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Random Forest','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\RF-3.jpg')

plot(N2O_Y_test,'r')
hold on
plot(prdeict_N2O_RF_test,'b')
legend('Observerd N2O','Predict N2O')
title('Random Forest','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\RF-4.jpg')


%% 2.2 Artificial Neural Network
[trainedModel,validationRMSE,validationR2] = trainRegressionModel_ANN(N2O_X_train,N2O_Y_train);
% ѵ��������
prdeict_N2O_ANN = trainedModel.predictFcn(N2O_X_train);
plotregression(N2O_Y_train,prdeict_N2O_ANN)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Artificial Neural Network','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\ANN-1.jpg')

plot(N2O_Y_train,'r')
hold on
plot(prdeict_N2O_ANN,'b')
legend('Observerd N2O','Predict N2O')
title('Artificial Neural Network','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\ANN-2.jpg')

% ���Լ�����
prdeict_N2O_ANN_test = trainedModel.predictFcn(N2O_X_test);
plotregression(N2O_Y_test,prdeict_N2O_ANN_test)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Artificial Neural Network','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\ANN-3.jpg')

plot(N2O_Y_test,'r')
hold on
plot(prdeict_N2O_ANN_test,'b')
legend('Observerd N2O','Predict N2O')
title('Artificial Neural Network','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\ANN-4.jpg')

%% 2.3 Gaussian Process Regression
[trainedModel,validationRMSE,validationR2] = trainRegressionModel_GRP(N2O_X_train,N2O_Y_train);
% ѵ��������
prdeict_N2O_GRP = trainedModel.predictFcn(N2O_X_train);
plotregression(N2O_Y_train,prdeict_N2O_GRP)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Gaussian Process Regression','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\GRP-1.jpg')

plot(N2O_Y_train,'r')
hold on
plot(prdeict_N2O_GRP,'b')
legend('Observerd N2O','Predict N2O')
title('Gaussian Process Regression','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\GRP-2.jpg')

% ���Լ�����
prdeict_N2O_GRP_test = trainedModel.predictFcn(N2O_X_test);
plotregression(N2O_Y_test,prdeict_N2O_GRP_test)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Gaussian Process Regression','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\GRP-3.jpg')

plot(N2O_Y_test,'r')
hold on
plot(prdeict_N2O_GRP_test,'b')
legend('Observerd N2O','Predict N2O')
title('Gaussian Process Regression','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\GRP-4.jpg')

%% 2.4 Decision Tree
[trainedModel,validationRMSE,validationR2] = trainRegressionModel_DT(N2O_X_train,N2O_Y_train);
% ѵ��������
prdeict_N2O_DT = trainedModel.predictFcn(N2O_X_train);
plotregression(N2O_Y_train,prdeict_N2O_DT)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Decision Tree','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\DT-1.jpg')

plot(N2O_Y_train,'r')
hold on
plot(prdeict_N2O_DT,'b')
legend('Observerd N2O','Predict N2O')
title('Decision Tree','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\DT-2.jpg')

% ���Լ�����
prdeict_N2O_DT_test = trainedModel.predictFcn(N2O_X_test);
plotregression(N2O_Y_test,prdeict_N2O_DT_test)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Decision Tree','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\DT-3.jpg')

plot(N2O_Y_test,'r')
hold on
plot(prdeict_N2O_DT_test,'b')
legend('Observerd N2O','Predict N2O')
title('Decision Tree','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\DT-4.jpg')

%% 2.5 Support Vector Machine
[trainedModel,validationRMSE,validationR2] = trainRegressionModel_SVM(N2O_X_train,N2O_Y_train);
% ѵ��������
prdeict_N2O_SVM = trainedModel.predictFcn(N2O_X_train);
plotregression(N2O_Y_train,prdeict_N2O_SVM)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Support Vector Machine','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\SVM-1.jpg')


plot(N2O_Y_train,'r')
hold on
plot(prdeict_N2O_SVM,'b')
legend('Observerd N2O','Predict N2O')
title('Support Vector Machine','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\SVM-2.jpg')

% ���Լ�����
prdeict_N2O_SVM_test = trainedModel.predictFcn(N2O_X_test);
plotregression(N2O_Y_test,prdeict_N2O_SVM_test)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Support Vector Machine','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\SVM-3.jpg')

plot(N2O_Y_test,'r')
hold on
plot(prdeict_N2O_SVM_test,'b')
legend('Observerd N2O','Predict N2O')
title('Support Vector Machine','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\SVM-4.jpg')

%% 2.6 Stepwise Linear Regression
[trainedModel,validationRMSE,validationR2] = trainRegressionModel_stepwiselm(N2O_X_train,N2O_Y_train);
% ѵ��������
prdeict_N2O_step = trainedModel.predictFcn(N2O_X_train);
plotregression(N2O_Y_train,prdeict_N2O_step)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Stepwise Linear Regression','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\step-1.jpg')

plot(N2O_Y_train,'r')
hold on
plot(prdeict_N2O_step,'b')
legend('Observerd N2O','Predict N2O')
title('Stepwise Linear Regression','train data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\step-2.jpg')

% ���Լ�����
prdeict_N2O_step_test = trainedModel.predictFcn(N2O_X_test);
plotregression(N2O_Y_test,prdeict_N2O_step_test)
xlabel('Observerd N2O'),ylabel('Predict N2O')
legend('Stepwise Linear Regression','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\step-3.jpg')

plot(N2O_Y_test,'r')
hold on
plot(prdeict_N2O_step_test,'b')
legend('Observerd N2O','Predict N2O')
title('Stepwise Linear Regression','test data')
hold off
saveas(gcf,'D:\�о���ѧϰ\��ѭ��\N map\data\0-N20���ݷ���\step-4.jpg')

%% 3.�������ݽ���ѵ������ģ�Ͳ����н�����֤������Ч����Ԥ����

% ������(n = 6016)
% 10�۽�����֤

% Random Forest
for i = 1:10
[trainedModel,validationRMSE(i),validationR2(i)] = trainRegressionModel_RF(N2O_X,N2O_Y);
end
RF_RMSE = validationRMSE
RF_R2 = validationR2


% Artificial Neural Network
for i = 1:10
[trainedModel,validationRMSE(i),validationR2(i)] = trainRegressionModel_ANN(N2O_X,N2O_Y);
end
ANN_RMSE = validationRMSE
ANN_R2 = validationR2

% Gaussian Process Regression
for i = 1:10
[trainedModel,validationRMSE(i),validationR2(i)] = trainRegressionModel_GRP(N2O_X,N2O_Y);
end
GRP_RMSE = validationRMSE
GRP_R2 = validationR2

% Decision Tree
for i = 1:10
[trainedModel,validationRMSE(i),validationR2(i)] = trainRegressionModel_DT(N2O_X,N2O_Y);
end
DT_RMSE = validationRMSE
DT_R2 = validationR2

% Support Vector Machine
for i = 1:10
[trainedModel,validationRMSE(i),validationR2(i)] = trainRegressionModel_SVM(N2O_X,N2O_Y);
end
SVM_RMSE = validationRMSE
SVM_R2 = validationR2

% Stepwise Linear Regression
% for i = 1:10
% [trainedModel,validationRMSE(i),validationR2(i)] = trainRegressionModel_stepwiselm(N2O_X,N2O_Y);
% end
% Step_RMSE = validationRMSE
% Step_R2 = validationR2

model_result = [GRP_R2',GRP_RMSE',ANN_R2',ANN_RMSE',RF_R2',RF_RMSE',DT_R2',DT_RMSE',SVM_R2',SVM_RMSE',Step_R2',Step_RMSE'];

