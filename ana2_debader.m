function [data_ana2,data_ana2_all,info_aan2_debader_otpt]=ana2_debader_v01(prog_ana2,data_ana1,info_ana2,data_x);
% % INPTS
% prog_ana2		: string for ana2_anareplis function

% CHANGES : ana2debader_v07

% APPEND debad auto generated
if isfield(info_ana2,'debad')==1;
	info_aan2_debader_otpt.debad=info_ana2.debad;
else
	disp('>>> STATUS : debad not present!');
	info_aan2_debader_otpt.debad={};
end
	info_aan2_debader_otpt.allrepsremoved={};
	eval(sprintf('data_ana2_all=%s(data_ana1,info_ana2,data_x);',prog_ana2))
	for uniquesamplei=1:length(data_ana2_all.uniquesamples);
		uniquesample_name=data_ana2_all.uniquesamples{uniquesamplei};
		disp(sprintf('>>>STATUS %s ',uniquesample_name));
		% remove OVER ones
		for  repi=1:eval(sprintf('length(ana2.all_truncnormrep.%s(1,:))',uniquesample_name));
			if eval(sprintf('length(unique(ana2.all_truncnormrep.%s(:,repi)))<0.5*length((ana2.all_truncnormrep.%s(:,repi)))',uniquesample_name,uniquesample_name));
				eval(sprintf('info_aan2_debader_otpt.debad=vertcat(info_aan2_debader_otpt.debad,ana2.rep_lbls.%s{%d,1});',uniquesample_name,repi));
			end
		end
		if eval(sprintf('length(ana2.all_truncnormrep.%s(1,:))>1',uniquesample_name));			
			% remove odd kfs
			eval(sprintf('uniquesample_badkfs_bool=(zscore(ana2.all_truncnormanarep.%s(3,:))>1.2  | zscore(ana2.all_truncnormanarep.%s(3,:))<-1.2);',uniquesample_name,uniquesample_name));
			%remove odd Amps
			eval(sprintf('uniquesample_badAmps_bool=(zscore(ana2.all_truncnormanarep.%s(2,:))>1.2 | zscore(ana2.all_truncnormanarep.%s(2,:))<-1.12);',uniquesample_name,uniquesample_name));
			% remove odd rfs
% 			if eval(sprintf('ana2.all_truncnormrep.%s(end,:)',uniquesample_name))>5;
				eval(sprintf('uniquesample_corrcoef=corrcoef(horzcat(transpose(mean(ana2.all_truncnormrep.%s'')),ana2.all_truncnormrep.%s));',uniquesample_name,uniquesample_name));
				uniquesample_badrfs_bool=(uniquesample_corrcoef(2:end,1)<0.8);
				uniquesample_badreps_bool=logical(uniquesample_badrfs_bool'+uniquesample_badkfs_bool+uniquesample_badAmps_bool);
% 			else
% 				uniquesample_badreps_bool=logical(uniquesample_badkfs_bool+uniquesample_badAmps_bool);
% 			end
			
			eval(sprintf('uniquesample_badreps_lbls=ana2.rep_lbls.%s(uniquesample_badreps_bool);',uniquesample_name));
			uniquesample_badreps_lbls=uniquesample_badreps_lbls(~cellfun('isempty',uniquesample_badreps_lbls));
			if length(uniquesample_badreps_lbls(:,1))==eval(sprintf('length(ana2.rep_lbls.%s)',uniquesample_name));
				info_aan2_debader_otpt.allrepsremoved=vertcat(info_aan2_debader_otpt.allrepsremoved,{uniquesample_name});
			end			
			info_aan2_debader_otpt.debad=vertcat(info_aan2_debader_otpt.debad,uniquesample_badreps_lbls);
		end
		clearvars uniquesample_*;
	end
	info_aan2_debader_otpt.debad=unique(info_aan2_debader_otpt.debad);
	disp(sprintf('>>>STATUS : trying coz length(debad(:,1))=%d',length(info_aan2_debader_otpt.debad(:,1))));
	eval(sprintf('data_ana2_all=%s(data_ana1,info_aan2_debader_otpt,data_x);',prog_ana2));

end	
