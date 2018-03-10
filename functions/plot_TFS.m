function plot_TFS(path,type,one)
% plot_TFS: plots the time,STFT and spectrogram plots of different types of
%           sounds for comparison between them
%    input: path - variable storing the path of the main recordings dir
%           type - variable for plotting different types of sounds
%                  'vow' - vowels
%                  'dip' - dipthongs
%                  'sho' - short consonants
%                  'fri' - fricatives
%                  'aff' - affricates
%                  'nas' - nasals
%                  'sem' - semivowels
%                  'vel' - velar
%                  'alv' - alveolar
%                  'pal' - palatal
%                  'UVU' - unvoiced unaspirated
%                  'UVA' - unvoiced aspirated
%                  'VUA' - voiced unaspirated
%                  'VAs' - voiced aspirated
%             one: variable for deciding no. of variables to be plotted
%                  one - 1 -> plot only one figure for that kind
%                  one - 0 -> plot all in that kind

%% declaring path
if(type(1:3)=='vow')
t = '\vowels\'
elseif(type(1:3)=='dip')
t = '\dipthongs\'
elseif(type(1:3)=='sho')
t = '\short consonants\'
elseif(type(1:3)=='fri')
t = '\fricatives\'
elseif(type(1:3)=='nas')
t = '\nasals\'
elseif(type(1:3)=='sem')
t = '\semivowels\'
elseif(type(1:3)=='aff')
t = '\affricates\'
elseif(type(1:3)=='vel')
t = '\velar\'
elseif(type(1:3)=='alv')
t = '\alveolar\'
elseif(type(1:3)=='den')
t = '\dental\'
elseif(type(1:3)=='bil')
t = '\bilabial\'
elseif(type(1:3)=='pal')
t = '\palatal\'
elseif(type(1:3)=='UVU')
t = '\UVUA\'
elseif(type(1:3)=='UVA')
t = '\UVA\'
elseif(type(1:3)=='VUA')
t = '\VUA\'
elseif(type(1:3)=='VAs')
t = '\VA\'
end

%% extract each STFT, spectrogram and signal into a cell
% path = 'C:\Users\AkhilBabu\Desktop\8th sem\EE628_speech_technology\assignment_work\Akhil_rec\recordings\rec2';
path = [path,t];
files = dir(path);
x = cell(length(files),1);     % cell for signal
y = cell(length(files),1);     % cell for resampled signal
I = cell(length(files),1);     % cell for spectrograms
f = zeros(length(files),1);    
j = 1;
fsize = 30;                    % frame size in ms
fshift = 10;                   % frame shift in ms
for i=1:length(files)
    if (files(i).isdir == 0)
        if (~isempty(strfind(files(i).name,'wav')))
            fullfile(path,files(i).name);
            [x{j},f(j)] = wavread(fullfile(path,files(i).name));  % reading each file into cell
            y{j} = resample(x{j},8000,f(j));                      % resampling them to 8KHz
            size(y{j})
            I{j} = plot_spec(y{j},8000,fsize,fshift,0);
            j = j+1
        end
    end
end
%% time-domain plot
if(j>3)
    k = j/2;         % variable for storing no. of figures if sounds>2                       
else
    k=1;
end
p=j;
j=3;
for l = 1:k
    %% breaking if we need only one figure to compare(see input) 
    if(one==1)
        if(l==2)
            break;
        end
    end
    
figure;
%% plotting signal
for i=1:j-1
    if(2*(l-1)+i==p)
        break;
    end
    subplot(j-1,3,3*(i-1)+1);    
    plot([1:length(y{2*(l-1)+i})],y{2*(l-1)+i});
    xlim([1 length(y{2*(l-1)+i})]);
end

%% frequency-domain plot
for i = 1:j-1
    if(2*(l-1)+i==p)
        break;
    end
    stft{2*(l-1)+i} = plot_STFT(y{2*(l-1)+i},8000,fsize,fshift);
    %% framewise parameters
    spf = floor(fsize*8);             % samples per each frame
    sps = floor(fshift*8);            % samples in one shift of frame
    nof = floor((length(y{2*(l-1)+i})-spf)/sps);   % total no. of frames
    
    t = [1:nof]*fshift;                           % plotting in time frame per fshfit
    w = linspace(1/8000,4000,size(stft{2*(l-1)+i},1));           % plotting in frequency frame
    subplot(j-1,3,3*(i-1)+2)
    surf(t,w,stft{2*(l-1)+i});                               % plotting stft with time and frequency
    title(['\fontsize{12}\color{red}',sprintf('%s',files(2+2*(l-1)+i).name)]);
    colorbar;
    xlim([fshift fshift*nof]);                    
    ylim([1/8000 4000]);
    xlabel('time');
    ylabel('frequency');
    zlabel('STFT Magnitude Spectrum');
    shading interp;                               % for smoothness of the plot
end

%% spectrogram plot
for i=1:j-1
    if(2*(l-1)+i==p)
        break;
    end
    a = [1/8:1/8:length(y{2*(l-1)+i})/8];
    b = linspace(1/8000,4000,size(I{2*(l-1)+i},2));
    subplot(j-1,3,3*(i-1)+3)
    imagesc(a,b,I{2*(l-1)+i});
    xlim([a(1) a(length(a))]);
    colormap(gray);
    set(gca,'YDir','normal'); 
end
end
end