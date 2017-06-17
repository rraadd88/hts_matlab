function data_ana1=ana1_getdata_v01(info_ana1,data_x); %fh_lblsall,
% % INPTS:
% info_ana1	: {1,1}			: expt general name
%			: row2: row50	: col1:	expt name
%							: col2:	expt file
%							: col3: sheet name if csv
% data_x		: eg. 60:60:3600

% CHANGES	:	6	:	negative slope for first half of the rf : kf=0 
%											2nd  half of the rf : calculate
%											kf assuming the signal
%											saturates after max
% CHANGES	:	5	ana1fromRaw6.m:	ana with single column
% CHANGES	:	4	:	get fitted data
% CHANGES	:	3	:	info file = files+labels
% CHANGES	:	2	:	use fitrfexp instead of fitexponen

% info_ana1=sigma_chem_screen_info;
% cycles=70;
% fluoromax=0;
% info_fhs,
% locations,row1: plate1 columns from (col1) to (col2) plate rows from (col3) to (col4)
% cycles, 70for 4000
% fh_lblsall

% data_ana1.inpt.info_fhs=info_fhs;
% data_ana1.inpt.cycles=cycles;
% data_ana1.inpt.fh_lblsall=fh_lblsall;

% info_ana1=info_struct.ana1;
fhs_max=400;
% data_x=60:60:5000;
% data_x=data_x(2:cycles)';
data_x=data_x';
cycles=data_x(end)/(data_x(2)-data_x(1))';

for infocoli=1:length(info_ana1(1,:));
	if isempty(info_ana1{1,infocoli})==0;
		
% 		EXTRACT INFO
		for fhi=1:fhs_max; %stitch max fhs =50 
            if isempty(info_ana1{fhi,infocoli})==1;         
				break
            end
		end
        info_fhs=info_ana1(2:fhi-1,infocoli:infocoli+2);
        info_fhs_lbls=info_ana1(fhs_max+1:end,infocoli:infocoli+fhi-3);
        lbls_count=0;

% 		ITERATE ON FILES
	for fhi=1:length(info_fhs(:,1));
		% Truncate
		fh_lbls=info_fhs_lbls(:,fhi);
		fh_lbls=fh_lbls(~cellfun('isempty',fh_lbls));
% 		fh_exptname=info_fhs{fhi,1};
		fh_fh=info_fhs{fhi,2};
		fh_sheet=info_fhs{fhi,3};
% 		isempty(info_fhs{fhi,3})
		if isempty(fh_sheet)==0;
			data_ana1.nonTrunc=tecan2workspace(fh_fh,fh_sheet);
		else
			fprintf('>>>ERROR : sheet info do not exist %s;',fh_fh);	
		end
		lbls_count(fhi)=length(data_ana1.nonTrunc(1,:));
		data_ana1.Trunc=data_ana1.nonTrunc(1:cycles,:); %STITCH
		if length(fh_lbls)==length(data_ana1.Trunc(1,:));
			for yi=1:length(data_ana1.Trunc(1,:));
				% fh_lbls{yi}
				% % status
				disp(sprintf('file no. :%d rf no. :%d chem name :%s',fhi, yi,fh_lbls{yi}));
					eval(sprintf('data_ana1.Trunc.%s=data_ana1.Trunc(:,yi);',fh_lbls{yi}));
% 					eval(sprintf('data_ana1.Trunc.%s=norm2min(data_ana1.Trunclbld.%s)./1000;',fh_lbls{yi},fh_lbls{yi}));

				eval(sprintf('y_fitted=ana1_debader_v01(data_x,data_ana1.Trunc.%s);',fh_lbls{yi},fh_lbls{yi}));
				eval(sprintf('data_ana1.Truncfitparams.%s=y_fitted.fitparams);',fh_lbls{yi}));
				eval(sprintf('data_ana1.Truncfiteddata.%s=y_fitted.fiteddata);',fh_lbls{yi}));

				clearvars y_*;
			end
			clearvars fh_lbls
		else
			disp(sprintf('>>>STATUS : labels and the samples are not equal chems = %d and rfs = %d',length(fh_lbls),length(data_ana1.Trunc(1,:))));
		end
	end
	data_ana1.lbls_count=lbls_count;
	if length(fieldnames(data_ana1.Trunclbld))~= lbls_count;
		disp(sprintf('>>>STATUS : %d rf %d labels',length(fieldnames(data_ana1.Trunclbld)),sum(lbls_count)));
		save(strcat(inputname(1),'.mat'));
	end
	end
end

% GET data_ana1S
data_ana1.data_x=data_x;

end