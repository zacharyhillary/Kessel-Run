%% Zachary Hillary
%% 12/1/2022
%% ECE 3340
%% Programming Assignment 3: Kessel Run
%%find longest and shortest path from spaceship to success(Y=10) by
%%starting with random X posistion and Velocity by brute force iteration
clc;
clear;
%%%%%%%%%%%%%%%%%%%%%%THINGS YOU CAN CHANGE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numiterations=100000; %number of iterations
dt = 0.1; %time between each time step
T = 100;  %Maximum number of time steps per calculation
G=1;%Gravitation Constant
X=[-7,-2,4,7,-4];  %%black hole location and mass
Y=[-4,-3,3,2,6];
M = [100, 50, 50, 100, 30];
ms=1;%mass of ship
MaxAcceleration=4;  %%increase this number for different paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numsuccess=0;
totallength= zeros(numiterations,1);
clf
hold on

for iteration=1:numiterations   %for 100,000 iterations
   
%%%%%%%%%%%%%%%%%%%%%%Generate X posistion and Velocity%%%%%%%%%%%%%%%%                   
pox=rand*10-5; %uniform distrubution between -5 and 5
poy=-10;
vomag = 3*rand+2;  %% uniform distribution between 2 and 5

while 1
voangle = 0.785*randn()+1.57;   %%normal distrubtion mean pi/2 std=pi/4
if voangle>0 & voangle<pi  %%make sure initial velocity angle is pointing up towards angle
    break
end 
end

p(1,1,iteration) = pox;   
p(1,2,iteration) = poy;

vx=vomag*cos(voangle);
vy=vomag*sin(voangle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 2:T+1  % for T time steps
Ax=0;
Ay=0;
for a=1:5 %for all 5 black holes
    
    distance=sqrt((p(t-1,1,iteration)-X(a))^2+(p(t-1,2,iteration)-Y(a))^2); %distance from space ship to black hole
    if p(t-1,1,iteration)>X(a)
    angle = atan((p(t-1,2,iteration)-Y(a))/(p(t-1,1,iteration)-X(a)))+3.14; %angle from blackhole
    else
        angle = atan((p(t-1,2,iteration)-Y(a))/(p(t-1,1,iteration)-X(a))); %angle form blackhole
    end
    A= (G*ms*M(a))/(distance^2);%Acceleration 
    Ax=Ax+A*cos(angle);%sum of acceleration in x direction
    Ay=Ay+A*sin(angle);%sum of acceleration in y direction
    
end

if sqrt(Ax^2+Ay^2)>MaxAcceleration
        break
    end
vx=vx+Ax*dt;%%update spaceship velocity
vy=vy+Ay*dt;
p(t,1,iteration)=p(t-1,1,iteration)+vx*dt;%%uodate spaceship posistion
p(t,2,iteration)=p(t-1,2,iteration)+vy*dt;
totallength(iteration)=totallength(iteration) + sqrt((p(t-1,1,iteration)-p(t,1,iteration))^2+(p(t-1,2,iteration)-p(t,2,iteration))^2);%sum of distance robot has traveled
if(p(t,2,iteration)>10)   %successfuly hit Y=10!!!!!
   % scatter(p(:,1,iteration),p(:,2,iteration),[],'black')%% use for
   % debugging.. prints every successful path
    numsuccess=numsuccess+1;%%increment for success counter
  if numsuccess==1 %%the very first success is both the longest and shortest path
      shortest(1)=iteration;
      longest(1)=iteration;
  end

    if totallength(iteration)<=totallength(shortest(1)) %%if current iteration's total length is < total length of shortest it then becomes the shortest
        shortest(1)=iteration; %% store information about the new shortest 
        shortest(2)=t;
        shortest(3)=pox;
        shortest(4)=vomag;
        shortest(5)=voangle*180/3.14;
        shortest(6)=totallength(iteration);
    end
    if totallength(iteration)>=totallength(longest(1))%% if current iterations total length is > the total length of the longest path it then becomes the longest path
        longest(1)=iteration;%% store information about new longest
        longest(2)=t;
        longest(3) =pox;
        longest(4)=vomag;
        longest(5)=voangle*180/3.14;
        longest(6)=totallength(iteration);
        
    end
    break
end
end
iteration  %%print iteration so you can see the progress

%scatter(p(:,1,iteration),p(:,2,iteration))%% use for debugging... prints a
%scatter for every single iteration
end
%%%%%%%%%%%%%%%%%%%%%%%%%END OF SIMULATIONS%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%make posistion [x,y] array of shortest and longest path%%%%%%%%%%
for a=1:shortest(2) %%we have to do this so it doesnt plot a bunch of (0,0)
    shortestp(a,1)=p(a,1,shortest(1));
    shortestp(a,2)=p(a,2,shortest(1));
    
end


for a=1:longest(2)
    longestp(a,1)=p(a,1,longest(1));
    longestp(a,2)=p(a,2,longest(1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format default


scatter(shortestp(:,1),shortestp(:,2),[],linspace(1,2,shortest(2)),'d','filled')
scatter(longestp(:,1),longestp(:,2),[],linspace(1,2,longest(2)),'filled')
scatter(X,Y,M*8,'black','filled')
y=10;
fplot(y,'--g')
legend('shortest','longest','black hole','success')

txt = ' \leftarrow total length is ' + string(shortest(6));
text(shortestp(10,1),shortestp(10,2),txt,'FontSize',14)

txt = ' \leftarrow total length is ' + string(longest(6));
text(longestp(20,1),longestp(20,2),txt,'FontSize',14)

txt = 'For Shortest Path  Xo= ' + string(shortest(3))+' |Vo|= '+string(shortest(4))+' Vo-Angle =  '+string(shortest(5));
text(-19,4,txt,'FontSize',14)

txt = 'Number Of Iterations: '+string(numiterations)+'  Number of Successful Iterations: '+string(numsuccess);
text(-19,-2,txt,'FontSize',14)

%end
ylim([-11 11]);
xlim([-20 20]);
numsuccess
