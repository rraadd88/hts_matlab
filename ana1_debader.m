function otpt=ana1_debader_v01(data_x,data_Y);

data_Y_1sthalf=fitl1(data_x(1:ceil(length(data_x)/2)),data_Y(1:ceil(length(data_x)/2)),0,[0 0 0]);	
data_Y_2ndhalf=fitl1(data_x(ceil(length(data_x)/2):end),data_Y(ceil(length(data_x)/2):end),0,[0 0 0]);	

	if max(data_Y)<0.2; % no rise
		otpt.fitparams=[0 0 0];
		otpt.fiteddata=zeros(length(data_x),1);						
	elseif (data_Y_1sthalf.fitparams(1,1)<0 && data_Y_1sthalf.gof.rsquare>0.45); % skip nagative effectors
		otpt.fitparams=[0 0 0];
		otpt.fiteddata=zeros(length(data_x),1);
	elseif data_Y_2ndhalf.fitparams(1,1)<0 && data_Y_2ndhalf.gof.rsquare>0.9;% aggregation
		tmp_truncnorm=data_Y(1:find(data_Y==max(data_Y)));
		otpt.truncnorm_aggretrimd=tmp_truncnorm;
		tmp_truncnorm(find(data_Y==max(data_Y)):length(data_x))=max(data_Y);
		otpt.truncnorm_aggre=tmp_truncnorm;
		otpt=fitrfexp1(data_x,tmp_truncnorm,0,[0 0 0]);
	else % normal
		otpt=fitrfexp1(data_x,data_Y,0,[0 0 0]);
	end
end