function plotTraj( trajectories,modein,cellwidthin,gapin )
%Plot multiple lineages using trajectories struct arrays
%trajectories is a struct array containing track and area fields, generated
%from using phy_plotPedigreeCavityMultiple_zx.m or
%phy_plotPedigreeCavity_zx.m
%cellwidthin and gapin specify the width of the plot and the gap between
%plots.

%modein is 'time' or 'generation', depending on the x-axis display.

if nargin==1
    cellwidth=5;
    gap=5;
    mode='time';

elseif nargin==2 
    cellwidth=5; %5 is good
    gap=5; %2 is good
    mode=modein;
    
else
    mode=modein;
    cellwidth=cellwidthin;
    gap=gapin;

end

Ntraj=numel(trajectories);

xmin=0;
xmax=10;
ymin=-30;
ymax=50;

%cellwidth=10;
col=[0.9 0.2 0.2];% ? (zx)
sep=0;

h=figure;

coltraj=flipud(colormap(cool(256))); % timings trajectories
coltraj(:,3)=0;
% coltraj1=jet(512);
% coltraj=flipud(colormap(coltraj1(257:512,:)));



cyclemax=240;
cyclemin=60;
blackcycle=1000;%very long cycle
coeff1=255/(cyclemin-cyclemax);
coeff2=(256*cyclemax-cyclemin)/(cyclemax-cyclemin);

coltraj(257,:)=[0.5 0.5 0.5];
coltraj(258,:)=[0 0 0];

framerate=10;%time between each frame (min) (zx)





for i=1:Ntraj
    
    if numel(trajectories(i).track)==0
        continue
    end
    rec=trajectories(i).track;
    
    if trajectories(i).DOXaddition<1000
        rec(:,1:2)=rec(:,1:2)-trajectories(i).DOXaddition;
        startindex=find(rec(:,2)>0,1,'first');%or startindex=find(rec(:,2)>0,1,'first')
    else
        startindex=1;
    end
        
    cindex=zeros(length(rec(:,1)));
    
    recgen=zeros(length(rec(:,1)),2);%build a mirror rec where length of cell cycle is uniform.
    for p=1:length(rec(:,1))
        recgen(p,:)=[(p-1)*2*cellwidth p*2*cellwidth];
    end
    
    if ~isempty(startindex)
    recgen=recgen-(startindex-1)*2*cellwidth;
    end
    
    for j=1:length(rec(:,1))
        %normal color, gradual
        cindex(j)=min(256,max(1,floor((coeff1*(rec(j,2)-rec(j,1))*framerate)+coeff2)));
        
%         if rec(j,2)-rec(j,1)>blackcycle/framerate %very long cycle
%             cindex(j)=258;
%         end
        
        %red/green on off color taking into account the differences between
        %mother and daughter cell cycle length
%         if rec(j,3)==1 %new daughter
%             if rec(j,2)-rec(j,1)<16%14%17%14
%                 cindex(j)=256;
%             else cindex(j)=1;
%             end
%         else %mother
%             if rec(j,2)-rec(j,1)<16%11%12%11
%                 cindex(j)=256;
%             else cindex(j)=1;
%             end
%         end
        
    end
    
    if trajectories(i).endlineage==0 && rec(end,2)-rec(end,1)<cyclemax/framerate %color in gray the last division if the movie is stopped
        cindex(length(rec(:,1)))=257;
    end
    
    switch mode
        
        case 'time'
            
            if rec(length(rec(:,1)),2)>xmax
                xmax=rec(length(rec(:,1)),2)+500/framerate;
            end
            
            if rec(1,1)<xmin
                xmin=rec(1,1)-300/framerate;
            end
    
        case 'generation'
    
    %if strcmp(mode,'generation')==1 %only color accounts for cell cycle duration.
            rec(:,1:2)=recgen;

            if rec(1,1)<xmin+500/framerate
                xmin=rec(1,1)-500/framerate;
            end

            if rec(end,2)>xmax-500/framerate
                xmax=rec(end,2)+500/framerate;
            end
    end
    
    

    %rec

    startX=1;
    startY=gap*cellwidth*(i-1);
    
    Traj(rec(:,1:2),'Color',coltraj,'colorindex',cindex,h,'width',2*cellwidth,'startX',startX,'startY',startY,'sepwidth',sep,'sepColor',[0.9 0.9 0.9],'gradientWidth',0);

    
    
    if trajectories(i).endlineage==1
        %drawSkull(rec(end,2)+10,startY+cellwidth/2,3,0);%for skull
        drawSkull(rec(end,2)+5,startY,1,1);
    else
        %drawSkull(rec(end,2)+10,startY+cellwidth/2,3,2);%ellipses for skull
        drawSkull(rec(end,2)+5,startY+cellwidth/2,1,2);
    end
    
%Draw black lines for the switch to a daughter cell    
%     for k=1:length(rec(:,1))
%         if rec(k,3)==1
%             Traj(-[-cellwidth cellwidth],'Color',[0.1 0.1 0.1],h,'width',1,'startX',rec(k,1)+1,'startY',startY,'sepwidth',0,'orientation','vertical','gradientwidth',0);
%         end
%     end
    
    
    
    
    
end

ymax=startY+5*gap;

%xlabel('Time (hours) ','FontSize',24);

switch mode
    
    case 'generation'
        xlabel('Generations','FontSize',24);
        xtick=2*cellwidth*[-10 0 10 20 30 40 50 60 70];
%         xtick=2*cellwidth*[-50 -40 -30 -20 -10 0 10];
%         xtick=2*cellwidth*[-48 -38 -28 -18 -8 2 12];
        xticklabel={};
        
        for j=1:length(xtick)
            xticklabel{j}=num2str(xtick(j)/(2*cellwidth));
%             xticklabel{j}=num2str((xtick(j)-2*2*cellwidth)/(2*cellwidth));
        end
    
    case 'time'
        xlabel('Time (hours) ','FontSize',24);
        
        xtick=[-120 0 120 240 360 480 600 720 840];
        xticklabel={};

        for j=1:length(xtick)
            xticklabel{j}=num2str(xtick(j)*framerate/60);
        end
    
end


set(gcf,'Color',[1 1 1]); %,'Position',[100 100 1200 500]);



set(gca,'YTick',[],'XTick',xtick,'XTickLabel',xticklabel,'FontSize',20,'Color',[1 1 1]);
xlim([xmin xmax]);
ylim([ymin ymax]);


%drawing the colorbar
val=cyclemin:10:cyclemax;
val2=zeros(1,length(val));

for i=1:length(val)
    val2(length(val)-i+1)=coeff1*val(i)+coeff2;
end

val2=val2/256;
yticklabel={};


for j=1:length(val)
    yticklabel{j} = num2str(val(j));
end

%coeff1
%coeff2
%val
%val2
%yticklabel

c=colorbar;
colormap(c,flipud(coltraj));
set(c,'YTickMode','manual','YTick',val2,'YTickLabelMode','manual','YTickLabel',yticklabel,'FontSize',20);
set(c,'CLim', [min(val2),max(val2)]);






end

