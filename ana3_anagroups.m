function data_ana3=ana3_anagroups_v01(data_ana2,info_ana3,data_x);
% % INPTS
% info_ana3
% >grps
% >vars
% % expt_name
% % lbl_neg_ctrl	:''PBS''
% % plot_xlabel		:''time''
% % plot_ylabel		:''fl''
% % plot_xintrvals	: 500
% % plot_fitparamloci	: 3 
% % plot_fitparamslabel	: kf (/s)
% % dh_plots		: ''/d/d/d/d''

% % CHANGES	:	11	ana3groupana_v12:	plot aggre 
% % CHANGES	:	10	:	dm or gfp
% %						plot aggregatings' rfs
% % CHANGES	:	09	:	get rf xmax from cycles
% %						date in plotname
% % CHANGES	:	08	:	add structures, reduce width of rf plot
% %						rule out rfs with amplitude less than 20%
% %						add dates in plots
% % CHANGES	:	07	:	use min max from the fiteddata

% GET INPTS
data_x=data_x';
cycles=data_x(end)/(data_x(2)-data_x(1))';

% SET VARS
for vari=length(info_ana3.vars(:,1));
	eval(sprintf('%s=%s;',info_ana3.vars{vari,1},info_ana3.vars{vari,1}));
end
plot_colors=jet(length(grp_smps(:,1)));

% SET PLOTS 
plot_types={'NoRsd','Rscld'};
plot_ORnot=input('plot_ORnot?');
if plot_ORnot==1;
	figdisp = input('figdisp?');
	figsave = input('figsave?');
end

% GET OTPTS
for plot_typei=1:length(plot_types(:));
	plot_type_lbl=plot_types{plot_typei};
	for grpi=1:length(info_ana3.grps(1,:));
		grp_lbl=info_ana3.grps{1,grpi};
		grp_lbl=strrep(grp_lbl,' ','_');
		grp_smps=info_ana3.grps(2:end,grpi);	
		grp_smps=grp_smps(~cellfun('isempty',grp_smps));
		%%% get data
		for grp_smpi=1:(length(grp_smps(:,1)));
			grp_smp_lbl=grp_smps{grp_smpi,1};
			% if the smp isn't present : use negative ctrl			
			if eval(sprintf('isfield(data_ana2.Trunc_avg_Y,''%s'')',grp_smp_lbl))==0;
				fprintf('>>> ERROR : %s DO NOT EXIST! : lbl_neg_ctrl %s INSTEAD! \n',grp_smp_lbl,lbl_neg_ctrl)
				grp_smp_lbl=lbl_neg_ctrl;
			end
			% get grp data sorted
			if strcmp(plot_type_lbl,'NoRsd')==1;
				% data_ana3.grpname.plot_type.data
				eval(sprintf('data_ana3.%s.%s.Trunc_avg_Y(:,%d)		=data_ana2.Trunc_avg_Y.%s;',grp_lbl,plot_type_lbl,grp_smpi,grp_smp_lbl));
				eval(sprintf('data_ana3.%s.%s.Trunc_avg_fiteddata(:,%d)	=data_ana2.Trunc_avg_fiteddata.%s;',grp_lbl,plot_type_lbl,grp_smpi,grp_smp_lbl));
			elseif strcmp(plot_type_lbl,'Rscld')==1;
				eval(sprintf('data_ana3.%s.%s.Trunc_avg_Y(:,%d)		=norm2minmax(data_ana2.Trunc_avg_Y.%s);',grp_lbl,plot_type_lbl,grp_smpi,grp_smp_lbl));
				eval(sprintf('data_ana3.%s.%s.Trunc_avg_fiteddata(:,%d)	=norm2minmax(data_ana2.Trunc_avg_fiteddata.%s);',grp_lbl,plot_type_lbl,grp_smpi,grp_smp_lbl));
			end
			eval(sprintf('data_ana3.%s.%s.Trunc_std_Y(:,%d)			=data_ana2.Trunc_std_Y.%s;',grp_lbl,plot_type_lbl,grp_smpi,grp_smp_lbl));
			eval(sprintf('data_ana3.%s.Trunc_avg_fitparams(:,%d)	=data_ana2.Trunc_avg_fitparams.%s;',grp_lbl,grp_smpi,grp_smp_lbl));
			eval(sprintf('data_ana3.%s.Trunc_std_fitparams(:,%d)	=data_ana2.Trunc_std_fitparams.%s;',grp_lbl,grp_smpi,grp_smp_lbl));
			eval(sprintf('data_ana3.%s.grp_smps{%d,1}	=''%s'';',grp_lbl,grp_smpi,grp_smp_lbl));
		end

if plot_ORnot==1;

% % SCATTER + FIT
if figdisp==1;figure('name',strrep(grp_lbl,'_',' '));else figure('visible','off');end
	axes('position',[0.05, 0.15, 0.3, 0.80]);
	for grp_smpi=1:(length(grp_smps(:,1)));
		if grp_smpi==1;
			eval(sprintf('h=plot(data_x,data_ana3.%s.%s.Trunc_avg_Y(:,grp_smpi),''.'',''color'',[0 0 0]); hold on;',grp_lbl,plot_type_lbl));    
			eval(sprintf('h=plot(data_x,data_ana3.%s.%s.Trunc_avg_fiteddata(:,grp_smpi),''LineWidth'',2,''color'',[0 0 0]); hold on;',grp_lbl,plot_type_lbl));    
		else
			eval(sprintf('plot(data_x,data_ana3.%s.%s.Trunc_avg_Y(:,grp_smpi),''.'',''color'',plot_colors(grp_smpi,:)); hold on;',grp_lbl,plot_type_lbl));    
			eval(sprintf('plot(data_x,data_ana3.%s.%s.Trunc_avg_Y(:,grp_smpi),''LineWidth'',2,''color'',plot_colors(grp_smpi,:)); hold on;',grp_lbl,plot_type_lbl));    
		end
	hold on;
	end
	
	legend off;
	ylabel(plot_ylabel,'FontWeight','bold');
	xlabel(plot_xlabel,'FontWeight','bold');
	set(gca,'fontsize',10,'FontWeight','bold');
	set(gca,'Xtick',0:plot_xintrvals:data_x(end));box on; grid on;     

	if plot_typei==1;
	axis([0,max(data_x),0,eval(sprintf('max(data_ana3.%s.%s.Trunc_avg_Y(end,:))',grp_lbl))]);
	elseif plot_typei==2;
	axis([0,max(data_x),0,1.2]);
	end

% %  KF CUM LEGENDS 
	axes('position',[0.36, 0.15, 0.15, 0.8]);
	for grp_smpi=1:(length(grp_smps(:,1)));
		if grp_smpi==1;
			eval(sprintf('scatterError(data_ana3.%s.Trunc_avg_fitparams(plot_fitparamloci,grp_smpi),[length(grp_smps(:,1))-grp_smpi+1],data_ana3.%s.Trunc_std_fitparams(plot_fitparamloci,grp_smpi),[0],[0 0 0]);hold on;',grp_lbl,grp_lbl));
		else
			eval(sprintf('scatterError(data_ana3.%s.Trunc_avg_fitparams(plot_fitparamloci,grp_smpi),[length(grp_smps(:,1))-grp_smpi+1],data_ana3.%s.Trunc_std_fitparams(plot_fitparamloci,grp_smpi),[0],plot_colors(grp_smpi,:));hold on;',grp_lbl,grp_lbl));
		end
		hold on;
	end
	eval(sprintf('plot_fitparam_all=data_ana3.%s.Trunc_avg_fitparams(plot_fitparamloci,:)'';',grp_lbl));
	plot_fitparam_max=max(plot_fitparam_all(plot_fitparam_all~=0));
	plot_fitparam_min=min(plot_fitparam_all(plot_fitparam_all~=0));

	set(gca,'yaxislocation','right');
	set(gca,'Ytick',1:1:length(grp_smps(:,1)));
	set(gca,'YTickLabel',strrep(ylabels,'_',' '),'FontWeight','bold');
	xlabel(plot_fitparamslabel,'FontWeight','bold');
	axis([plot_fitparam_min-0.0005,0.0005+plot_fitparam_max,0.8,length(grp_smps(:,1))+0.2]);
	box on; grid on;
	set(gca,'fontsize',10,'FontWeight','bold');
	clearvars plot_fitparam_*;

% % STRUCTURES
	structures_dh_plots='/structures'; % STITCH
	tmp_labels_tot=length(grp_smps(:,1));
	for tmp_labeli=1:tmp_labels_tot;
		tmp_label=grp_smps{tmp_labeli,1};
		tmp=strfind(tmp_label,'_');
		% remove mM tags and add .pngs
		if length(tmp)~=0;
	% 			structure_fn=sprintf('%s.png',tmp_label(1:tmp(end)-1));
			structure_fn=tmp_label(1:tmp(end)-1);
		else	
			structure_fn='';
		end
		structure_fh=sprintf('%s/%s',structures_dh_plots,structure_fn);
		% plot the structure
		% if file exists
	% 		strcat(structure_fh,'.png')
		if exist(structure_fh, 'file') == 2;
			axes('position', [0.75, (tmp_labels_tot-tmp_labeli)/tmp_labels_tot, 0.25, 1/tmp_labels_tot]);
			subplot_data=imread(structure_fh,'png','BackgroundColor','none');
			subplot_dataresized=imresize(subplot_data,0.67);
			imshow(subplot_dataresized,'Border','tight');
		elseif exist(strcat(structure_fh,'.png'), 'file') == 2
			axes('position', [0.75, (tmp_labels_tot-tmp_labeli)/tmp_labels_tot, 0.25, 1/tmp_labels_tot]);
			subplot_data=imread(strcat(structure_fh,'.png'),'png','BackgroundColor','none');
			subplot_dataresized=imresize(subplot_data,0.67);
			imshow(subplot_dataresized,'Border','tight');
		end
		clearvars str tmp_*;
	end


% % SAVE FIGURE
	figuresize(14,4,'inches');
	date_form = 'yymmdd';date_now=datestr(now,date_form);
	filename=strcat(date_now,'_trajectories_',expt_name,'_',grp_lbl,plot_type_lbl,'.png');
% 	filename=sprintf('%s_trajectories_%s%s%s.png',date_now,grp_lbl,plot_type_lbl);
	set(gcf, 'PaperPositionMode', 'auto');
	if figsave==1; print('-dpng',strcat(dh_plots,'/',filename));hold off;clf;end
	% % status
	disp(sprintf('group :%d :%s filename=%s',grpi,grp_lbl,strcat(dh_plots,'/',filename)));
end

clearvars grp_*;
end
clearvars plot_type_*;
end
end