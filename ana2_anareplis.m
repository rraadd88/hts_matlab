function data_ana2=ana2_anareplis_v01(data_ana1,info_ana2);

% % inpts 
% data_ana1	:	struct with fields of data_ana1 otpt called 'expts'
% CHANGES	:	6	data_ana2replicateana7:	debug for dm pbs
% CHANGES	:	5	:	set aggregated trimd also
% CHANGES	:	4	:	get the replicate names
% CHANGES	:	3	:	get averages of the fitdata 
% CHANGES	:		:	data_ana1 is made of a combined expts
% CHANGES	:	2	:	if kf > 0.001 -> make 0

% GET INPTS

data_x=data_ana1.data_x;%=data_x';
cycles=data_x(end)/(data_x(2)-data_x(1))';

if isfield(info_ana2,'debad')==1;
	info_ana2_debad=info_ana2.debad;
else
	disp('>>> STATUS : debad not present.. puuting in {}');
	info_ana2_debad={};
end

% if isfield(data_ana1,'PBS')==1;
% 	data_ana2.Trunc=data_ana1.PBS.Trunc;
% 	data_ana2.Truncana=data_ana1.PBS.Truncana;
% else
% 	data_ana2.Trunc.tmp=0;
% 	data_ana2.Truncana.tmp=0;
% end

data_ana2.Trunc				=data_ana1.Trunc;
data_ana2.Truncfitparams	=data_ana1.Truncfitparams;
data_ana2.Truncfiteddata	=data_ana1.Truncfiteddata;

% REMOVE BAD DATA
if iscell(info_ana2_debad)==1 && isempty(info_ana2_debad)==0;
% debad
	for i=1:length(info_ana2_debad(:,1));
		data_ana2.Trunc				=rmfield(data_ana2.Trunc,info_ana2_debad{Unqsmpi,1});
		data_ana2.Truncfitparams	=rmfield(data_ana2.Truncfit,info_ana2_debad{Unqsmpi,1});
		data_ana2.Truncfiteddata	=rmfield(data_ana2.Truncana,info_ana2_debad{Unqsmpi,1});
	end
end

data_ana2.Allsmps=fieldnames(data_ana2.Trunc);
data_ana2.Allsmps=sort(data_ana2.Allsmps);

% ASSIGN REPLICATES
for Allsmpi=1:length(data_ana2.Allsmps);
	str=data_ana2.Allsmps{Allsmpi,1};
	tmp=strfind(str,'_');
	if isempty(tmp);
		data_ana2.Unqsmps{Allsmpi,1}=str;
	else	
		data_ana2.Unqsmps{Allsmpi,1}=str(1:tmp(end)-1);
	% data_ana2.Unqsmps{Unqsmpi,1}=str(1:end-2);
	end
	clearvars str tmp;
end
data_ana2.Unqsmps=unique(data_ana2.Unqsmps);

for Unqsmpi=1:length(data_ana2.Unqsmps);

% GET LOCATIONS
	Unqsmp_repsi=1; Unqsmp_reps_locs=0;Unqsmp_reps={};    
	for Allsmpi=1:length(data_ana2.Allsmps(:,1));
		if strmatch(strcat(data_ana2.Unqsmps{Unqsmpi,1},'_'),data_ana2.Allsmps{Allsmpi,1})>0;
			if length(data_ana2.Allsmps{Allsmpi,1})<length(data_ana2.Unqsmps{Unqsmpi,1})+5;
				Unqsmp_reps_locs(Unqsmp_repsi)=Allsmpi;
				Unqsmp_reps{Unqsmp_repsi}=data_ana2.Allsmps{Allsmpi,1};
				Unqsmp_repsi=Unqsmp_repsi+1;
			end
		end
	end

% GET AVG AND STD
	Unqsmp_sum_Y=0;Unqsmp_sum_fitparams=0;Unqsmp_sum_fiteddata=0;
	if Unqsmp_reps_locs~=0 ;
		for Unqsmp_reps_loci=1:length(Unqsmp_reps_locs);
			eval(sprintf('Unqsmp_sum_Y			=Unqsmp_sum_Y+data_ana2.Trunc.%s;',data_ana2.Allsmps{Unqsmp_reps_locs(Unqsmp_reps_loci)}));
			eval(sprintf('Unqsmp_sum_fiteddata	=Unqsmp_sum_fiteddata+data_ana2.Truncfiteddata.%s;',data_ana2.Allsmps{Unqsmp_reps_locs(Unqsmp_reps_loci)}));
			eval(sprintf('Unqsmp_sum_fitparams	=Unqsmp_sum_fitparams+data_ana2.Truncfitparams.%s;',data_ana2.Allsmps{Unqsmp_reps_locs(Unqsmp_reps_loci)}));

			eval(sprintf('Unqsmp_reps_Y(:,%d)			=data_ana2.Trunc.%s;',Unqsmp_reps_loci,data_ana2.Allsmps{Unqsmp_reps_locs(Unqsmp_reps_loci)}));
			eval(sprintf('Unqsmp_reps_fiteddata(:,%d)	=data_ana2.Truncfiteddata.%s;',Unqsmp_reps_loci,data_ana2.Allsmps{Unqsmp_reps_locs(Unqsmp_reps_loci)}));
			eval(sprintf('Unqsmp_reps_fitparams(:,%d)	=data_ana2.Truncfiteddata.%s;',Unqsmp_reps_loci,data_ana2.Allsmps{Unqsmp_reps_locs(Unqsmp_reps_loci)}));
		end
		
		eval(sprintf('data_ana2.Trunc_avg_Y.%s			=Unqsmp_sum_Y./length(Unqsmp_reps_locs);',data_ana2.Unqsmps{Unqsmpi,1}));
		eval(sprintf('data_ana2.Trunc_avg_fiteddata.%s	=Unqsmp_sum_fiteddata./length(Unqsmp_reps_locs);',data_ana2.Unqsmps{Unqsmpi,1}));
		eval(sprintf('data_ana2.Trunc_avg_fitparams.%s	=Unqsmp_sum_fitparams./length(Unqsmp_reps_locs);',data_ana2.Unqsmps{Unqsmpi,1}));
		eval(sprintf('data_ana2.Trunc_reps_Y.%s			=Unqsmp_reps_Y;',data_ana2.Unqsmps{Unqsmpi,1}));
		eval(sprintf('data_ana2.Trunc_reps_fiteddata.%s	=Unqsmp_reps_fiteddata;',data_ana2.Unqsmps{Unqsmpi,1}));
		eval(sprintf('data_ana2.Trunc_reps_fitparams.%s =Unqsmp_reps_fitparams;',data_ana2.Unqsmps{Unqsmpi,1}));

		if length(Unqsmp_reps_fitparams(1,:))==1;
			eval(sprintf('data_ana2.Trunc_std_Y.%s(3,1)=0;',data_ana2.Unqsmps{Unqsmpi,1}));
			eval(sprintf('data_ana2.Trunc_std_fitparams.%s(3,1)=0;',data_ana2.Unqsmps{Unqsmpi,1}));
		else
			eval(sprintf('data_ana2.Trunc_std_Y.%s=std(Unqsmp_reps_Y'');',data_ana2.Unqsmps{Unqsmpi,1}));
			eval(sprintf('data_ana2.Trunc_std_fitparams.%s=std(Unqsmp_reps_fitparams'');',data_ana2.Unqsmps{Unqsmpi,1}));    
		end
		
		% get reps used
		eval(sprintf('data_ana2.Unqsmp_reps.%s=Unqsmp_reps'';',data_ana2.Unqsmps{Unqsmpi,1}));

		clearvars Unqsmp_*;
	end
end

% GET OTPTS
data_ana2.inpt.info_ana2_debad=info_ana2_debad;
end	