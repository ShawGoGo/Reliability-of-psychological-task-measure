% this function is for caculating the measurement error by taking both
% between session and residual variance into consideration
% created by xz Aug 16 2021
function sem =SEM(x)
m_b=mean(x,1);
SSb=sum((m_b-mean(x(:))).^2)*size(x,1);
SSwg=sum((x(:,1)-mean(x(:,1))).^2)+sum((x(:,2)-mean(x(:,2))).^2);
% SStotal-SSb-SSwg
% SStotal-SSsubject-SSb
m_p = mean(x,2)
SSsubject=sum((m_p-mean(x(:))).^2)*size(x,2);
SSe= SSwg-SSsubject;
% SEM=(SSe+SSb)^0.5;
sem=(SSe/((size(x,1)-1)*(size(x,2)-1))+SSb/(size(x,2)-1))^0.5;