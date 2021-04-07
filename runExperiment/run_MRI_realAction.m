%The experiment code that was used in: 
%Knights, E., Mansfield, C., Tonin, D., Saada, J., Smith, F., & Rossit, S. (2020).
%Hand-selective visual regions represent how to grasp 3D tools for use: brain decoding during real actions. bioRxiv. 
%doi: 10.1101/2020.10.14.339606
%
%The code was created by Fraser W. Smith and Ethan Knights.
%
%function MRI_turntable_FS_sds()


%%% RUN INSTACALL FIRST, THEN OPEN MATLAB
%%% TOP CABLE OF MINILAB IS FOR FIXATION 
%%% BOTTOM CABLE OF MINILAB IS FOR ILLUMINATOR


% trial starts with audio cue 
% after 2s from audio cue onset
% 250ms object shown, 

GetSecs;
WaitSecs;
KbCheck;

KbName('UnifyKeyNames');
realConfig=1;  %% should=1 if connected to I/O card
escKeyCode=KbName('ESCAPE');

%ask the experimenter to input the order
 subject = input('Enter id: ','s');
% curOrder=input('Pick your order:   ')
 run=input('Run Number: ')

[inpfile,inpPathName] = uigetfile('*.xlsx','Select the input trial file')
[num,txt,raw] = xlsread([inpPathName '\' inpfile]);
curOrder=str2double(inpfile(end-5)); %% will only work for 1-9

direction={'left','right'};
obs={'knife','whisk','pizzaC','spoon','barK','barW','barP','barS'};
 
nTrials=size(num,1);
inpdata=num(:,[1 2]);

escKeyCode=KbName('ESCAPE');
 
dateString = datestr(now, 'YYYY-mm-dd HH:MM PM');

    
%Choose Trigger Key
trigKey = KbName('S')
conds={'look','reach','grasp'};


% set-up the parallel port for lights
if(realConfig)
    ml = digitalio('mcc',0);
    addline(ml,0:7,1,'Out'); %Port A
    addline(ml,0:7,2,'Out'); %Port B
    addline(ml,0:3,3,'Out'); %Port CL
    addline(ml,0:3,4,'Out'); %Port CH
    putvalue(ml,0);
end
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

ill_one_fixred=[0 0 0 1 0 0 1 0];

% % put all lights low
% putvalue(dio,0);
%         
% % put on Fixation
% putvalue(ml.line(1:8),fixred);

fx = 44100;
 
try

% load audio files
    for sf = 1:nTrials
        sfile = [num2str(inpdata(sf,2)) '.wav']; 
        [sn{sf},fs(sf)]=wavread(sfile);
    end
    [ss{1},fl]=wavread('left.wav');
    [ss{2},fr]=wavread('right.wav');
    
    length(sn{1})
    nosound = zeros(length(sn{1}),1);
    length(nosound)
    
%     [y{1},fs(1)]=audioread('1.wav');
%     [y{2},fs(2)]=audioread('2.wav');
%     [y{3},fs(3)]=audioread('3.wav');
%     [y{4},fs(4)]=audioread('4.wav');
%     [y{5},fs(5)]=audioread('5.wav');
%     [y{6},fs(6)]=audioread('6.wav');
%     [y{7},fs(7)]=audioread('7.wav');
%     [y{8},fs(8)]=audioread('8.wav');
%     [y{9},fs(9)]=audioread('9.wav');
%     [y{10},fs(10)]=audioread('10.wav');
%     [y{11},fs(11)]=audioread('11.wav');
%     [y{12},fs(12)]=audioread('12.wav');
%     [y{13},fs(13)]=audioread('13.wav');
%     [y{14},fs(14)]=audioread('14.wav');
%     [y{15},fs(15)]=audioread('15.wav');
%     [y{16},fs(16)]=audioread('16.wav');
   

    % Perform basic initialization of the sound driver:
    InitializePsychSound;

    
    % Choosing the display with the highest display number is
    % a best guess about where you want the stimulus displayed.
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    % Open window with default settings:
    w=Screen('OpenWindow', screenNumber);
    resolutions=Screen('Resolutions', w);

    white = WhiteIndex(w); % pixel value for white
    black = BlackIndex(w); % pixel value for black
    gray = (white+black)/2;
    inc = white-gray;
    Screen(w, 'FillRect', gray);  %% make default screen green
    Screen('TextSize', w, 32);
    
    rect=Screen('Rect',w);
    
    colour.red=[150 0 0];
    colour.white=[255,255,255];
    colour.darkblue=[0 0 200];
    colour.lightblue=[0 100 255];
    colour.green=[0 200 0];
    colour.black=[0,0,0];

    

   % Open the default audio device [], with default mode [] (==Only playback),
    % and a required latencyclass of zero 0 == no low-latency mode, as well as
    % a frequency of freq and nrchannels sound channels.
    % This returns a handle to the audio device:
    freq=fx; nrchannels=2;
    
    % Make a beep 
    beepLengthSecs = 1;
    myBeep = MakeBeep(500, beepLengthSecs, freq);
    noBeep = zeros(length(myBeep),1);    
    try
        % Try with the 'freq'uency we wanted:
        pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
    catch
        % Failed. Retry with default frequency as suggested by device:
        fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
        fprintf('Sound may sound a bit out of tune, ...\n\n');

        psychlasterror('reset');
        pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
    end
    
    % instructions
    message=['Tool Study Main']; 
    DrawFormattedText(w, message, 'center', 'center', BlackIndex(w));
    Screen('Flip', w);
    while(~KbCheck)
       % wait for some response 
    end
    
    
    
    % GET READY SIGN HERE
    message=['Waiting to Start: Get Ready'];
    DrawFormattedText(w, message, 'center', 'center', BlackIndex(w));
    Screen('Flip', w);
    
    HideCursor;
    WaitSecs(.05);
    GetSecs;
    [KeyIsDown, dummy, KeyCode]=KbCheck;  %%% poll keyboard for response
    cc2=zeros(1,256); aa2=0; bb2=0;  %% for responses
    
    % initialise response variables - change at scanner
    expr1code=KbName('1');
    expr2code=KbName('2');
    breakCode=KbName('ESCAPE');
    
    % timing parameters
    InitViewTime=.250;
    trialTime=20;
    onOffTime=10; % for stim or fix
    InitFixTime=14;
    soundplaytime = 0.5;
    reps = 5;
    OffTimeScans = 5;
    RepTime = 2.0;

%     
    % WAIT FOR TRIGGER  %%%
    TrigCode=KbName('S');   %% ('5%') upstairs for mac keyboard
    cc=zeros(1,256); aa=0; bb=0; kz=1;
    disp('Waiting for Trigger');
    while (~cc(TrigCode))
        [aa,bb,cc]=KbCheck(-1);  %%% poll keyboard for response (-1 means merged input from all keyboards), 7 for FORP input
        if(cc(TrigCode))      
          TrigStartTime=bb;  %% the key time stamp for experiment --- first trigger
        end
    end
    disp('Caught Trigger');
    
    
    % display initial fixation period
%    Screen('DrawTexture',w, fixTex); %[], [507 379 518 390]);  %% [] = source rectangle
%    Screen('Flip', w);
    if(realConfig)
        putvalue(ml.line(1:8),fixred)
    end
    message=['InitialFixation']; 
    DrawFormattedText(w, message, 'center', 'center', BlackIndex(w));
    Screen('Flip', w);
    while(GetSecs-bb < InitFixTime)
        
        if(GetSecs-bb>4 && kz==1)
              % play first trial instruction sound
                PsychPortAudio('FillBuffer', pahandle, [nosound sn{1}]');
                t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
                kz=2;
        end
        
        
    end
     % Stop playback:
     PsychPortAudio('Stop', pahandle);
    

    
    for k=1:nTrials
        

        kz=1;
        % show object
        % play auditory sound
        if inpdata(k,1)==1 %% if left
            ps = ss{1};
        else
            ps = ss{2};
        end
        
          if(k<nTrials)
            ssl = length(ps);
            snl = length(sn{k+1});
            if ssl<snl
                SL = padarray(ps,snl-ssl,'post');
                SR = sn{k+1};
            else
                SL = ps;
                SR = padarray(sn{k+1},ssl-snl,'post');
            end
          else
               SL=ps; SR=ps;
          end
        soundout = [SL SR];       
        T1(k,1)=GetSecs;
        PsychPortAudio('FillBuffer', pahandle, soundout');
        t1(k,1) = PsychPortAudio('Start', pahandle, 1, 0, 1); % wait until sound starts
        T1(k,2)=GetSecs;
        
        % put visual cue on screen
        message=sprintf('%s  %s', char(direction{inpdata(k,1)}), char(obs{inpdata(k,2)}));
        DrawFormattedText(w, message, 'center', 'center', BlackIndex(w));
        Screen('Flip', w);
        
%         while((GetSecs-T1(k,2))<soundplaytime)
%             % wait till after sound start
%         end
        
        T1(k,3)=GetSecs;
        
      while(GetSecs-T1(k,3) <=onOffTime)

          for i=1:reps  % do repetitions for trial  

            T2(k,i,1)=GetSecs;
            if(realConfig)
                % Put Iluminator on for viewing period of 250ms
                putvalue(ml.line(1:8),ill_one_fixred)
               % comment following if to end out and uncomment line above if
               % only red fixation should be shown
    %             if strcmp(inpdata{k,2},'L')
    %                 putvalue(ml.line(1:8),ill_one+fixred)  %red for left
    %             else
    %                 putvalue(ml.line(1:8),ill_one+fixblue)  %blue for right
    %             end            
                end

         %   currTime=GetSecs;
            while(GetSecs-T2(k,i,1) <= InitViewTime) % 250ms
                % wait
            end

            if(realConfig)
                %%turn off the illuminator but keep fix on 
                putvalue(ml.line(1:8),fixred)

            end

            T2(k,i,2)=GetSecs;

            %wait until end of rep
            while(GetSecs-T2(k,i,1) <= RepTime)
                % wait
            end

          end
      
      end  %% end while loop for stimulation block
      
      
      
        
      T1(k,4)=GetSecs;
      
      
 % play beep
        PsychPortAudio('FillBuffer', pahandle, [noBeep myBeep']');
        PsychPortAudio('Start', pahandle, 1, 0, 1); 
        
        while(GetSecs-T1(k,4) <= onOffTime)  
           % wait 
            [aa2,bb2,cc2]=KbCheck(-1);  %% loop to catch response
            if(find(cc2)==escKeyCode)
                    % break out of pgm
                    ShowCursor;
                    sca; % close screen
                    return;
            end
        end
        
        T1(k,5)=GetSecs;
        
        % Stop playback:
        PsychPortAudio('Stop', pahandle);

        
    end  
    
    WaitSecs(InitFixTime); 
    
    if(realConfig)
        %all lights low
        putvalue(ml,0);
    end
    
    
        
    EndTime=GetSecs;
    

    % Close the audio device:
    PsychPortAudio('Close', pahandle);

%         
     TotalTime=EndTime-TrigStartTime;

     Screen('CloseAll');  %% close presentation screen
     ShowCursor;
     
  %   curOrder=1; %% change this later
      outname=sprintf('%s_run%d_order%d_TypicalTool.mat',subject,run,curOrder);
      save(outname);

    
catch
    
   % Priority(0);
    Screen('CloseAll');

    if(realConfig)
        %all lights low
        putvalue(ml,0);
    end
    
	% Restores the mouse cursor.
	ShowCursor;
    
	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror); 
    
end