function otpt=ana4_forcorrelator_v01(name_prt,data_rf_ana,data_props,list_chem);

% % INPTS
% name_prt : string
data_chem_phychemprops=data_props;
data_chem_list_short=list_chem; % dataset
data_screens_all_ana_v02=data_rf_ana;

% % MAKE COLS
data_combo_correlations=dataset;
vars=data_chem_phychemprops.Properties.VarNames;
for vari=1:length(vars(:));
	eval(sprintf('data_combo_correlations.%s={[]};',vars{vari}));
end

data_combo_correlations.Chemical=data_chem_list_short;

for chemi=1:length(data_chem_list_short(:,1));
	for propi=1:length(data_chem_phychemprops(:,1));
		if strcmp(data_chem_list_short{chemi,1},data_chem_phychemprops.Chemical{propi})==1;
			for vari=1:length(vars(:));					
				eval(sprintf('data_combo_correlations.%s(chemi)={data_chem_phychemprops.%s(propi)};',vars{vari},vars{vari}));
			end
		end
	end
end

% % % MAKE DATASET FOR CORRELATIONS
info_rf={name_prt,'data_screens_all_ana_v02';};
			
PBSloci=findincell(data_combo_correlations.Chemical,'PBS');
			
for info_rfi=1:length(info_rf(:,1));
	for chemi=1:length(data_chem_list_short(:,1));
		if eval(sprintf('length(%s.ana2.all_truncnormanaavg.%s)',info_rf{info_rfi,2},data_chem_list_short{chemi,1}))==1;
			eval(sprintf('data_combo_correlations.%s_kf(chemi)=NaN;',info_rf{info_rfi,1}));
		else
			eval(sprintf('data_combo_correlations.%s_kf(chemi)=%s.ana2.all_truncnormanaavg.%s(1,3);',info_rf{info_rfi,1},info_rf{info_rfi,2},data_chem_list_short{chemi,1}));
		end
	end
	%rkf
	for chemi=1:length(data_chem_list_short(:,1));
		eval(sprintf('data_combo_correlations.%s_rkf(chemi)={log2noinf(data_combo_correlations.%s_kf(chemi)/data_combo_correlations.%s_kf(PBSloci(1,1)))};',info_rf{info_rfi,1},info_rf{info_rfi,1},info_rf{info_rfi,1}));
	end	
end

% SET OTPTS
otpt=data_combo_correlations;

end