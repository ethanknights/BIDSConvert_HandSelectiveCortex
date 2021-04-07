% RUN INSTACALL FIRST, THEN OPEN MATLAB
%%%TOP CABLE OF MINILAB IS FOR FIXATION 
%%% BOTTOM CABLE OF MINILAB IS FOR ILLUMINATOR
ml = digitalio('mcc',0);

addline(ml,0:7,1,'Out'); %Port A
addline(ml,0:7,2,'Out'); %Port B
addline(ml,0:3,3,'Out'); %Port CL
addline(ml,0:3,4,'Out'); %Port CH

%putvalue(ml.line(1:8), [0 0 1 1 1 1 1 1]);

%switch on illuminator
%1
%ill_one = [0 0 0 0 0 0 0 1]; 
ill_one=[0 0 0 0 0 0 1 0];

%2
ill_two = [0 0 0 0 1 0 0 1];
%3
ill_three = [0 0 0 0 1 1 0 1];
%4
ill_four = [0 0 0 0 1 1 1 1];

% fixred
fixred = [0 0 0 1 0 0 0 0];
% fixblue
fixblue = [0 0 1 0 0 0 0 0];

%COPY PASTE ONE AT A TIME
putvalue(ml.line(1:8),fixblue);
putvalue(ml.line(1:8),fixred);

putvalue(ml.line(1:8),ill_one);
putvalue(ml.line(1:8),ill_two);
putvalue(ml.line(1:8),ill_three);
putvalue(ml.line(1:8),ill_four);

% this line v useful for initial set-up to make sure subject can see
% fixation
putvalue(ml.line(1:8),fixblue+fixred); 







