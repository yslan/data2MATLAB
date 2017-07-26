clear all
close all
format shorte


out_file = 'PNP_r_pconv'

pj = 'conv_PNP_r';
prefix = 'CPU_deg';

ind_case = [2 4 6 8 10];


n_iter = 1000; % reach steady state
n_case = length(ind_case);

Dir = ['data/' pj '/'];

L2 = 'L2';
linf = 'linf';

err_cN = zeros(n_case,2);
err_cP = zeros(n_case,2);
err_pot= zeros(n_case,2);

for i = 1:n_case
   CPU = read_CPU(pj,[prefix num2str(ind_case(i))]);
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
          ./      abs(err_cN(2,:) -err_cN(4,:)));
conv_cP_r = log2(abs(err_cP(1,:) -err_cP(2,:)) ...
          ./      abs(err_cP(2,:) -err_cP(4,:)));
conv_pot_r= log2(abs(err_pot(1,:)-err_pot(2,:)) ...
          ./      abs(err_pot(2,:)-err_pot(4,:)));


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
figure(11) % show conv. to steady state
ind = [1 2 4];
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
 

   str1=[str1, ['deg ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['deg ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['deg ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,9,1);

   str = [str1;str2;str3];
   str = reshape(str,9,1); 
   legend(ppp,str,'location','southwest');
   axis([1,1.7e4,1e-9,1e2]);
   xlabel('time step');
   ylabel('L2 error');

   % save
   fff = gcf;
   file_name = [Dir 'time_L2err_reach2steady'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(11)


figure(12) % linf of fig.11

ind = [1 2 4];
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


   str1=[str1, ['deg ' num2str(ind_case(ii)) ' cN']];
   str2=[str2, ['deg ' num2str(ind_case(ii)) ' cP']];
   str3=[str3, ['deg ' num2str(ind_case(ii)) ' \Phi']];
end
   ppp = [p1;p2;p3];
   ppp = reshape(ppp,9,1);

   str = [str1;str2;str3];
   str = reshape(str,9,1);
   legend(ppp,str,'location','southwest');
   axis([1,1.7e4,1e-9,1e2]);
   xlabel('time step');
   ylabel('linf error');

   % save
   fff = gcf;
   file_name = [Dir 'time_linferr_reach2steady'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(12)


figure(21) % p-conv (err_cN)

   p1 = loglog(ind_case',err_cN(:,1),...
            'LineWidth',1.5,'color',colorSet(1,:),'LineStyle','-');
   hold on
   p2 = loglog(ind_case',err_cP(:,1),...
            'LineWidth',1.5,'color',colorSet(2,:),'LineStyle','-');
   p3 = loglog(ind_case',err_pot(:,1),...
            'LineWidth',1.5,'color',colorSet(3,:),'LineStyle','-');
   legend([p1;p2;p3], 'cN','cP','\Phi','location','southwest');
   axis([1,12,1e-10,1]);
   xlabel('degree of polynomials')
   ylabel('L2 error after 10000 time steps')

   % save
   fff = gcf;
   file_name = [Dir 'deg_L2err_pconv'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(21)   



figure(22) % linf of fig.21

   p1 = loglog(ind_case',err_cN(:,2),...
            'LineWidth',1.5,'color',colorSet(1,:),'LineStyle','-');
   hold on
   p2 = loglog(ind_case',err_cP(:,2),...
            'LineWidth',1.5,'color',colorSet(2,:),'LineStyle','-');
   p3 = loglog(ind_case',err_pot(:,2),...
            'LineWidth',1.5,'color',colorSet(3,:),'LineStyle','-');
   legend([p1;p2;p3], 'cN','cP','\Phi','location','southwest');
   axis([1,12,1e-10,1]);
   xlabel('degree of polynomials')
   ylabel('linf error after 10000 time steps')

   % save
   fff = gcf;
   file_name = [Dir 'deg_linferr_pconv'];
   print(file_name,'-dpng','-r300'); % png
   saveas(fff,[file_name '.fig'])% fig
   close(22)

 
%figure(3)

%figure(4)
%figure(5)


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

% conv rate
   fprintf(fid,'rate\t');              
   fprintf(fid,['%.4E %.4E' sp2], conv_cN_r);
   fprintf(fid,['%.4E %.4E' sp2], conv_cP_r);
   fprintf(fid,['%.4E %.4E' sp2], conv_pot_r);
   fprintf(fid,'\n');


fclose(fid);






















