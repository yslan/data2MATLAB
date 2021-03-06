clear all
close all
format shorte


out_file = 'PNP_dt_d_tconv'

pj = 'result_dt_d_sc4';
prefix = 'dt';

ind_case = [0.01 0.02 0.04 0.08 0.16];
n_iter = 100; % reach steady state
tol    = 1e-4; 
cut    = [3 3.5 4];

%plot_que = [11 12 13 14 15 16 17 18 21 22];
%plot_que = [21 22];
plot_que = [];

n_cut = length(cut);
n_case = length(ind_case);

Dir = ['data/' pj '/'];

L2 = 'L2';
linf = 'linf';

err_cN = zeros(n_case,2);
err_cP = zeros(n_case,2);
err_pot= zeros(n_case,2);

for i = 1:n_case
   CPU = read_CPU(pj,[prefix num2str(i)]);
%   if i==5
%      tmp = zeros(111,14,2);
%      tmp(:,:) = nan;
%      [a,b,c] = size(CPU);
%      tmp(1:a,1:b,1:c) = CPU;
%      tmp(:,1,:) = data(1).CPU(:,1,:);
%      CPU = tmp;
%   end
   data(i).CPU = CPU;   

   err_cN(i,:) = CPU(n_iter,7,:);
   err_cP(i,:) = CPU(n_iter,8,:);
   err_pot(i,:)= CPU(n_iter,10,:);
  

   if i > 1 
   d_logiter = log(abs(ind_case(i)-ind_case(i-1)));
   conv_cN(i,:) = abs(log(abs(err_cN(i,:) -err_cN(i-1,:))) / d_logiter);
   conv_cP(i,:) = abs(log(abs(err_cP(i,:) -err_cP(i-1,:))) / d_logiter);
   conv_pot(i,:)= abs(log(abs(err_pot(i,:)-err_pot(i-1,:)))/ d_logiter);
   end

%   data(n_iter,,1)% 7 8 10
end

conv_cN_r = log2(abs(err_cN(1,:) -err_cN(2,:)) ...
          ./     abs(err_cN(2,:) -err_cN(4,:)));
conv_cP_r = log2(abs(err_cP(1,:) -err_cP(2,:)) ...
          ./     abs(err_cP(2,:) -err_cP(4,:)));
conv_pot_r= log2(abs(err_pot(1,:)-err_pot(2,:)) ...
          ./     abs(err_pot(2,:)-err_pot(4,:)));

% t error
errcut_cN = zeros(n_cut,n_case,2);
errcut_cP = zeros(n_cut,n_case,2);
errcut_pot= zeros(n_cut,n_case,2);

for i0 = 1: length(cut)
   for i=1:n_case
      for j=1:2
         xx = data(i).CPU(:,1,j)*ind_case(i);
         n_cut = floor(interp1( xx(2:end),2:length(xx),cut(i0)));
         errcut_cN(i0,i,j) = data(i).CPU(n_cut,7,j); 
         errcut_cP(i0,i,j) = data(i).CPU(n_cut,8,j); 
         errcut_pot(i0,i,j)=data(i).CPU(n_cut,10,j); 
      end
   end
end



colorSet = [            % Setting color of plot, ref: MATLAB
 0.00 0.00 0.00 % Data 0 - black
 0.00 0.00 1.00 % Data 1 - blue
%0.00 1.00 0.00 % Data 2 - green
 1.00 0.00 0.00 % Data 3 - red
%0.00 1.00 1.00 % Data 4 - cyan
 1.00 0.00 1.00 % Data 5 - magenta
 0.75 0.75 0.00 % Data 6 - RGB
 0.25 0.25 0.25 % Data 7
 0.75 0.25 0.25 % Data 8
 0.95 0.95 0.00 % Data 9
 0.25 0.25 0.75 % Data 10
 0.75 0.75 0.75 % Data 11
 0.00 0.50 0.00 % Data 12
 0.76 0.57 0.17 % Data 13
 0.54 0.63 0.22 % Data 14
 0.34 0.57 0.92 % Data 15
 1.00 0.10 0.60 % Data 16
 0.88 0.75 0.73 % Data 17
 0.10 0.49 0.47 % Data 18
 0.66 0.34 0.65 % Data 19
 0.99 0.41 0.23 % Data 20
];

% figure

ind = [1 2 3 4 5]; % for fig.1*
rang=[0.7,1.2e3,1e-9,1e2];
n_ind=length(ind);

if sum(11==plot_que) >0 % if in, plot
figure(11) % show conv. to steady state
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,1);
   yy1 = data(ii).CPU(:,7,1);
   yy2 = data(ii).CPU(:,8,1);
   yy3 = data(ii).CPU(:,10,1);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');
 

   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1); 
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time step');
   ylabel('L2 error');

   % save
   fff = gcf;
   file_name = [Dir 'time_L2err_reach2steady'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(11)
end


if sum(12==plot_que)>0 % if in, plot
figure(12) % linf of fig.11
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,2);
   yy1 = data(ii).CPU(:,7,2);
   yy2 = data(ii).CPU(:,8,2);
   yy3 = data(ii).CPU(:,10,2);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');


   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1);
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time step');
   ylabel('linf error');

   % save
   fff = gcf;
   file_name = [Dir 'time_linferr_reach2steady'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(12)
end


   rang = [1.7e-3,1.1e2,1e-9,1e2];
if sum(13==plot_que)>0 % if in, plot
figure(13) % show conv. to steady state, real time
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,1)*ind_case(i);
   yy1 = data(ii).CPU(:,7,1);
   yy2 = data(ii).CPU(:,8,1);
   yy3 = data(ii).CPU(:,10,1);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');
 

   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1); 
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time');
   ylabel('L2 error');

   % save
   fff = gcf;
   file_name = [Dir 'realtime_L2err_reach2steady'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(13)
end


if sum(14==plot_que)>0 % if in, plot
figure(14) % linf of fig.11
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,2)*ind_case(i);
   yy1 = data(ii).CPU(:,7,2);
   yy2 = data(ii).CPU(:,8,2);
   yy3 = data(ii).CPU(:,10,2);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');


   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1);
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time');
   ylabel('linf error');

   % save
   fff = gcf;
   file_name = [Dir 'realtime_linferr_reach2steady'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(14)
end



   rang = [1.8e0,1.85e0,1e-4,1e-1];
if sum(15==plot_que)>0 % if in, plot
figure(15) % show conv. to steady state, real time
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,1)*ind_case(i);
   yy1 = data(ii).CPU(:,7,1);
   yy2 = data(ii).CPU(:,8,1);
   yy3 = data(ii).CPU(:,10,1);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');
 

   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1); 
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time');
   ylabel('L2 error');

   % save
   fff = gcf;
   file_name = [Dir 'realtime_L2err_reach2steady_slice'];
   print(file_name,'-dpng','-r600'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(15)
end

if sum(16==plot_que)>0 % if in, plot
figure(16) % linf of fig.11
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,2)*ind_case(i);
   yy1 = data(ii).CPU(:,7,2);
   yy2 = data(ii).CPU(:,8,2);
   yy3 = data(ii).CPU(:,10,2);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');


   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1);
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time');
   ylabel('linf error');

   % save
   fff = gcf;
   file_name = [Dir 'realtime_L2inf_reach2steady_slice'];
   print(file_name,'-dpng','-r600'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(16)
end


   rang = [1.8e0,1.85e0,4e-4,2e-3];
if sum(17==plot_que)>0 % if in, plot
figure(17) % show conv. to steady state, real time
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,1)*ind_case(i);
   yy1 = data(ii).CPU(:,7,1);
   yy2 = data(ii).CPU(:,8,1);
   yy3 = data(ii).CPU(:,10,1);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');
 

   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1); 
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time');
   ylabel('L2 error');

   % save
   fff = gcf;
   file_name = [Dir 'realtime_L2err_poisson_slice'];
   print(file_name,'-dpng','-r600'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(17)
end


if sum(18==plot_que)>0 % if in, plot
figure(18) % linf of fig.11
str1={};
str2={};
str3={};
for i=1:length(ind) % deg 2 6 10
   ii = ind(i);
   xx = data(ii).CPU(:,1,2)*ind_case(i);
   yy1 = data(ii).CPU(:,7,2);
   yy2 = data(ii).CPU(:,8,2);
   yy3 = data(ii).CPU(:,10,2);
   p1(i)=loglog(xx,yy1,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-');
 hold on
   p2(i)=loglog(xx,yy2,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','--');
   p3(i)=loglog(xx,yy3,'LineWidth',1.5,'color',colorSet(i,:),'LineStyle','-.');


   str1=[str1, ['dt ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['dt ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['dt ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,3*n_ind,1);

   str = [str1;str2;str3];
   str = reshape(str,3*n_ind,1);
   legend(ppp,str,'location','southwest');
   axis(rang);
   xlabel('time');
   ylabel('linf error');


   % save
   fff = gcf;
   file_name = [Dir 'realtime_linferr_poisson_slice'];
   print(file_name,'-dpng','-r600'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(18)
end



   p_ind = 1:4;
   i_cut = 1; % plot the i-th cut
%   rang = [7e-3,0.2,1e-4,1e1];
%   rang = [7e-3,0.1,1e-4,1e-2];
   rang = [7e-3,0.1,1e-5,1e-2]; % BDF1R D, time=3
%   rang = [7e-3,0.1,1e-3,1e-1]; % BDF1R N R
if sum(21==plot_que)>0 % if in, plot
figure(21) % t-conv (errcut_cN)

   p1 = semilogy(ind_case(p_ind)',errcut_cN(i_cut,p_ind,1),...
               'Marker','o','MarkerFaceColor',colorSet(1,:),...
            'LineWidth',1.5,'color',colorSet(1,:),'LineStyle','-');
   hold on
   p2 = semilogy(ind_case(p_ind)',errcut_cP(i_cut,p_ind,1),...
            'Marker','o','MarkerFaceColor',colorSet(2,:),...
            'LineWidth',1.5,'color',colorSet(2,:),'LineStyle','-');
   p3 = semilogy(ind_case(p_ind)',errcut_pot(i_cut,p_ind,1),...
            'Marker','o','MarkerFaceColor',colorSet(3,:),...
            'LineWidth',1.5,'color',colorSet(3,:),'LineStyle','-');
   legend([p1;p2;p3], 'cN','cP','\Phi','location','northwest');
   axis(rang);
   xlabel('dt')
   ylabel(['L2 error at time = ' num2str(cut(i_cut))])

   % save
   fff = gcf;
   file_name = [Dir 'deg_L2err_cut' num2str(cut(i_cut)) '_tconv'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(21)   
end


if sum(22==plot_que) >0 % if in, plot
figure(22) % linf of fig.21

   p1 = loglog(ind_case(p_ind)',errcut_cN(i_cut,p_ind,2),...
            'Marker','o','MarkerFaceColor',colorSet(1,:),...
            'LineWidth',1.5,'color',colorSet(1,:),'LineStyle','-');
   hold on
   p2 = loglog(ind_case(p_ind)',errcut_cP(i_cut,p_ind,2),...
            'Marker','o','MarkerFaceColor',colorSet(2,:),...
            'LineWidth',1.5,'color',colorSet(2,:),'LineStyle','-');
   p3 = loglog(ind_case(p_ind)',errcut_pot(i_cut,p_ind,2),...
            'Marker','o','MarkerFaceColor',colorSet(3,:),...
            'LineWidth',1.5,'color',colorSet(3,:),'LineStyle','-');
   legend([p1;p2;p3], 'cN','cP','\Phi','location','northwest');
   axis(rang);
   xlabel('dt')
   ylabel(['linf error at time = ' num2str(cut(i_cut))])

   % save
   fff = gcf;
   file_name = [Dir 'deg_linferr_cut' num2str(cut(i_cut)) '_tconv'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(22)
end


% output

sp2='  ';
sp6='      ';
sp7='       ';
sp9='         ';
sp11='           ';
sp12=[sp6 sp6];
sp13=[sp6 sp7];
sss=['L2 error   linf error  conv' sp9 '\t '];

fid = fopen([Dir 'out_' out_file],'w');

fprintf(fid,['project: \t' pj '\n']);
fprintf(fid,['#case:   \t' num2str(n_case) '\n']);
fprintf(fid,['prefix:  \t' prefix '\t' num2str(ind_case) '\n']);

fprintf(fid,'\n');

fprintf(fid,[sp6 'cN' sp12 sp9 sp13 '\t cP' sp12 sp9 sp13 '\t potent \n']);
fprintf(fid,[' Deg  ' sss sss sss '\n']);
for i=1:n_case
   if i > 1
   fprintf(fid,['%4d' sp2], ind_case(i));                   % Deg
   fprintf(fid,['%.4E %.4E' sp2], data(i).CPU(n_iter,7,:)); % cN
   fprintf(fid,['%2.2f %2.2f' sp2 '\t\t '], conv_cN(i,:)); % cN
   fprintf(fid,['%.4E %.4E' sp2], data(i).CPU(n_iter,8,:)); % cP
   fprintf(fid,['%2.2f %2.2f' sp2 '\t\t '], conv_cP(i,:)); % cP
   fprintf(fid,['%.4E %.4E' sp2], data(i).CPU(n_iter,10,:));% potent
   fprintf(fid,['%2.2f %2.2f' sp2], conv_pot(i,:));% potent
   fprintf(fid,'\n');
   else
   fprintf(fid,['%4d' sp2], ind_case(i));                   % Deg
   fprintf(fid,['%.4E %.4E' sp2], data(i).CPU(n_iter,7,:)); % cN
   fprintf(fid,[sp13 '\t ']); 
   fprintf(fid,['%.4E %.4E' sp2], data(i).CPU(n_iter,8,:)); % cP
   fprintf(fid,[sp13 '\t ']); 
   fprintf(fid,['%.4E %.4E' sp2], data(i).CPU(n_iter,10,:));% potent
   fprintf(fid,[sp13]); 
   fprintf(fid,'\n');
   end
end

% p  conv rate
   fprintf(fid,'rate\t');              
   fprintf(fid,['%.4E %.4E' sp2], conv_cN_r);
   fprintf(fid,['%.4E %.4E' sp2], conv_cP_r);
   fprintf(fid,['%.4E %.4E' sp2], conv_pot_r);
   fprintf(fid,'\n');


% t error
   fprintf(fid,'\n\n');
   fprintf(fid,['cut L2  cut = ' num2str(cut) '      dt\n']);
   for i=1:n_case
      fprintf(fid,'cN:  ');              
      fprintf(fid,['%.4E' sp2], errcut_cN(:,i,1));
      fprintf(fid,' %.2E',ind_case(i));
      fprintf(fid,'\n');
   end
   for i=1:n_case
      fprintf(fid,'cP:  ');              
      fprintf(fid,['%.4E' sp2], errcut_cP(:,i,1));
      fprintf(fid,' %.2E',ind_case(i));
      fprintf(fid,'\n');
   end
   for i=1:n_case
      fprintf(fid,'pot: ');              
      fprintf(fid,['%.4E' sp2], errcut_pot(:,i,1));
      fprintf(fid,' %.2E',ind_case(i));
      fprintf(fid,'\n');
   end
   fprintf(fid,'\n\n');
   fprintf(fid,['cut linf cut= ' num2str(cut) '      dt\n']);
   for i=1:n_case
      fprintf(fid,'cN:  ');              
      fprintf(fid,['%.4E' sp2], errcut_cN(:,i,2));
      fprintf(fid,' %.2E',ind_case(i));
      fprintf(fid,'\n');
   end
   for i=1:n_case
      fprintf(fid,'cP:  ');              
      fprintf(fid,['%.4E' sp2], errcut_cP(:,i,2));
      fprintf(fid,' %.2E',ind_case(i));
      fprintf(fid,'\n');
   end
   for i=1:n_case
      fprintf(fid,'pot: ');              
      fprintf(fid,['%.4E' sp2], errcut_pot(:,i,2));
      fprintf(fid,' %.2E',ind_case(i));
      fprintf(fid,'\n');
   end


fclose(fid);
