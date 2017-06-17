function info2 ana0getinfo_v04(fhs_list,chem_list,data_florolog);
% % FLOW
% read info sheets -> get sample names in replicatre form ->  make info for
% ana1
% % INPTS
% fhs_list : cell with paths
% fhs_list : cell with	col1: chemical no.; 
% 						col2: chem name; 
% 						col3: concemtration mM
% info=cell(100,50);
% data_florolog : struct	:	labels=
%							:	screen1=

% CHANGES	:	4	ana0getinfo_v04: include florolog
% CHANGES	:	3	: use info_old for older ones
% CHANGES	:	2	: if not mentioned use 250mM

info={};
max_fhs=50; %STITCH

for filei=1:length(fhs_list(:,1))-1;
	fprintf('>>>STATUS %s \n',fhs_list{filei+1,2})
	if isempty(findstr('floromax',fhs_list{filei+1,2}))==1; % no floromax
	[A,B] = xlsfinfo(fhs_list{filei+1,2});
		if any(strcmp(B, 'info'))==1; % new	
			[~, ~, file_smps] = xlsread(fhs_list{filei+1,2},'info');
			file_smps = file_smps(2:9,2:13);	
			file_smps(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),file_smps)) = {''};
			file_smps=makeonecolumn(file_smps);
			file_smps=file_smps(~cellfun('isempty',file_smps));
		% 	file_smps_unique=unique(file_smps);
			file_smps_names={};
			for file_smpi=1:length(file_smps);
				file_smp_num=file_smps{file_smpi};
				for chemi=1:length(chem_list(:,1));
					if strcmp('PBS',file_smp_num)==0;
						if strmatch(num2str(chem_list{chemi,1}),num2str(file_smp_num))==1;
							if isempty(findstr('mM',num2str(file_smp_num)))==1;	 % get conc bit													
								file_smps_names{file_smpi,1}=strcat(chem_list{chemi,2},'_250mM');					
							else % if not mentioned make it to 250mM
								file_smps_names{file_smpi,1}=strcat(chem_list{chemi,2},file_smp_num(findstr('_',file_smp_num):end));											
							end
						end
					elseif strcmp('PBS',file_smp_num)==1;
							file_smps_names{file_smpi,1}='PBS';
					else
							file_smps_names{file_smpi,1}='ERROR';
					end
				end
			end
		% 	size(file_smps_names)
		elseif any(strcmp(B, 'info_old'))==1; % old
			[~, ~, file_smps] = xlsread(fhs_list{filei+1,2},'info_old');
			file_smps = file_smps(1:end,1);					
			file_smps_names=file_smps(~cellfun('isempty',file_smps));
		end
	elseif isempty(findstr('floromax',fhs_list{filei+1,2}))==0; % floromax
		file_smps_names={''};
	end
	info(1:length(file_smps_names),filei)=file_smps_names;
	clearvars file_smps*
end
%	add replicate number
info_unique=makeonecolumn(info);
info_unique=info_unique(~cellfun('isempty',info_unique));
info_unique=unique(info_unique);
info_unique(:,2)={0}; % counter

for info_uniquei=1:length(info_unique(:,1));
	info_unique_name=info_unique{info_uniquei};
	for infocoli=1:length(info(1,:)); 
		for inforowi=1:length(info(:,1));
			if strcmp(info_unique_name,info{inforowi,infocoli})==1;
				info_unique{info_uniquei,2}=info_unique{info_uniquei,2}+1;
				info_rep_name=sprintf('%s_%02d',info_unique_name,info_unique{info_uniquei,2});
				info2{inforowi+max_fhs,infocoli}=info_rep_name;			
			end
		end	
	end
	clearvars info_unique_*;	
end

info2(1:length(fhs_list(:,1)),1:length(fhs_list(1,:)))=fhs_list;
end