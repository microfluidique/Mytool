function [ track ] = convertTrack
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



results_analysis= [];
[ file_name,folder_name ] = uigetfile({'*.*'},'Select your file ');
path_file = [folder_name,file_name];
class(path_file)
csv= xlsread(path_file);
matrix = size(csv);
numberPosition = matrix(2);

Answers = inputdlg({'Dox addition image?', 'Comments?'},'informations');
[dox,   comments] = Answers{:};

dox = str2num(dox);
for i=1:numberPosition
    table = csv(:,[i]);
    str =  num2str(table);
    str = transpose(str);
    var = strfind(str, '111'); % cellule meurt
    table(var+1)=0;
    table(var+2)=0;
    ind=find(table==1);
   
    results_analysis(i).track=[ind(1:end-1) ind(2:end) zeros(length(ind)-1,1) zeros(length(ind)-1,1)];
    results_analysis(i).area=zeros(length(ind(2:end)),1);
    
    if (isempty(var)==0)
        results_analysis(i).endlineage=1;
    else
        results_analysis(i).endlineage=0;
    end
    results_analysis(i).DOXaddition=dox;
    results_analysis(i).Comments=comments;

end 
% 
% save()
% folder_name = uigetdir('./results','save mat file');
% path_file = [folder_name,'results'];

save('results_analysis', 'results_analysis') ;
plotTraj(results_analysis,'generation',5,2);


