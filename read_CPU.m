function data = read_CPU(pj,filename)
% This function read data after the command:
%  grep "CPU" *.output

% Input
%  pj: name of the project, should be a folder under /data
%  filename: name of the CPU file

% Output
%  data(n,14,2)
%     1: #iter
%     2: ?
%     3: deg
%     4: ?
%     5: tt
%     6: dt
%     7: err_cN
%     8: err_cP
%     9: x
%    10: err_potent
%    11: x
%    12: x
%    13: run time
%    14: x
%   str: L2/linf

dir = 'data/';
in_pwd = [dir pj '/' filename];


% get # lines
[~,result] = system( ['wc -l ', in_pwd] );
n_line = sscanf(result,'%d');

% check err case
fid = fopen(in_pwd,'r');
if fid < 0
   error('There is no corresponding file in this project, read_CPU \n');
elseif mod(n_line,2) == 1
   error('The number of lines in file is odd')
end


% Read
data = zeros(n_line/2,14,2);
tline = fgets(fid);
for i = 1:(n_line/2)
   % Linf
   vec = sscanf(tline,'%f',[1,14]);
   data(i,:,1) = vec;
   % L2
   tline = fgets(fid);
   vec = sscanf(tline,'%f',[1,14]);
   data(i,:,2) = vec;

   % NEXT
   tline = fgets(fid);
end

fclose(fid);
end

