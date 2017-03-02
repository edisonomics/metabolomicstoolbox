function plot_spec(X,ppm,T,sel,varargin)

% Author: Rahil Taujale
% Version: 0.2
% Date: 01/30/2017

% Description:
%       plot_spec plots a set of chemical shift values on a set of 1D
%       spectra. It has added functionalities for display selection,
%       coloring and displaying labels.
%
% Input: 
%       X: stack of 1D spectra
%       ppm: chemical shift vector
%       T: Table with the sample information.
%           5 columns with following exact headers:
%                Run_ID,Sample_ID,Sample_desc,Sample_grp,Yvec
%       sel: 3 options.
%           1) A cell array with a list of Sample_grp names to be plotted
%               Eg: sel={'L1','L2'}
%           2) A numeric vector with a list of Yvec to be plotted
%               Eg: sel=[5 6 7]
%           3) 'all' If want to plot all samples
%       Optional:
%           'Yvec'  : 'Yes' if sel input above is a list of Yvec as in option
%                      2
%                   : 'No' (Default) if sel input is a cell array with
%                      Sample_grp names
%           'show'  : 'all' (Default) to show all the plots
%                   : 'sample' to show only the sample plots
%                   : 'mean' to show only the mean plots
%           'color' : 'mean' (Default) Label and color plots based on means
%                   : 'all' Label each sample with separate color
%           'xlabel': Cell array with additional labels to add to peaks
%                     from joined data
%
% Output: 
%       A plot of the 1D spectra.
%
% Log:
%       Ver 0.2: Added secondary labels to label added peaks.
%
% Example run: plot_spec(XALN,ppmR,T,selected_sets,'Yvec','n','show','mean','color','mean')


    opt = struct('Yvec','No','show','all','color','mean','xlabel',0);
    optNames = fieldnames(opt);
    nArgs = length(varargin);
    if round(nArgs/2)~=nArgs/2
        error('Input Argument-Value in pairs')
    end
    for pairs = reshape(varargin,2,[])
        inpName = pairs{1}; 
        if any(strcmp(inpName,optNames))
            opt.(inpName) = pairs{2};
        else
            error('%s not a valid parameter',inpName)
        end
    end
    
    if strcmpi(sel,'all')
        sel=unique(T.Yvec)';
        opt.Yvec='yes';
    end
    [M,N]=size(sel);
    CM = distinguishable_colors(N);
    fig=[];
    ax=[];
    sample_name=cell(0);
    figure;
    hold on;
    for f=1:N
        if strncmpi(opt.Yvec, 'yes',1)
            Xsel=X(T.Run_ID(T.Yvec==sel(f)),:);
            [D,E]=size(Xsel);
            sample_name(end+1:end+D)=T.Sample_ID(T.Yvec==sel(f));
            for i=1:N
                sel2{i}=char(unique(T.Sample_grp(T.Yvec==sel(i))));
            end
        else
            Xsel=X(T.Run_ID(strcmp(T.Sample_grp, sel(f))),:);
            [D,E]=size(Xsel);
            sample_name(end+1:end+D)=T.Sample_ID(strcmp(T.Sample_grp, sel(f)));
            sel2=sel;
        end
        [fig(end+1:end+D),ax(end+1:end+D)]=plotr(ppm,Xsel,'color',CM(f,:),'linewidth',0.5,'linestyle','--');
        if (D>1)
            [fig(end+1),ax(end+1)]=plotr(ppm,mean(Xsel),'color',CM(f,:),'linewidth',2);
        elseif (D==1)
            [fig(end+1),ax(end+1)]=plotr(ppm,Xsel,'color',CM(f,:),'linewidth',2);
        end
        m(f)=length(fig);
        sample_name(end+1)=sel2(f);
    end
    
    if strcmpi(opt.show, 'sample')
        set(ax(m),'Visible','off');    
    elseif strcmpi(opt.show, 'mean')
        set(ax,'Visible','off');
        set(ax(m),'Visible','on');
        opt.label='mean';
    end
    
    if strcmpi(opt.color, 'all')
        CM = distinguishable_colors(length(ax)+length(m));
        for i=1:length(ax)
            j=i+length(m);
            set(ax(i),'color',CM(j,:));
        end
        for i=1:length(m)
            set(ax(m(i)),'color',CM(i,:));
        end
        legend(ax,sample_name);
    elseif strcmpi(opt.color, 'mean')
        legend(ax(m),sample_name(m));
    end
    
    if isa(opt.xlabel,'cell')
        [M,N]=size(opt.xlabel);
        [A,B]=size(ppm);
        xT=double.empty(0,N);
        addPt=B-(50*N);
        for i=N:-1:1
            st=addPt+(50*i);
            en=addPt+(50*(i-1));
            tick=(ppm(st)+ppm(en))/2;
            xT(i)=tick;
        end
        new_ax(1)=gca;
        a=get(gca,'Position');
        new_ax(2) = axes('Position',a,'XAxisLocation','top','YAxisLocation','right','Color','none','XColor','k','YColor','k','XDir','reverse');
        set(gca,'box','off','ytick',[],'ycolor','w');
        linkaxes(new_ax,'xy');
        xA={'L1' 'L2' 'L3' 'L4' 'Ad'};
        set(gca,'xtick',xT,'xticklabel',opt.xlabel);
    end
    hold off;
end

   