% main function for code 11-15

[x,f] = wavread('C:\Users\AkhilBabu\Desktop\8th sem\EE628_speech_technology\assignment_work\Akhil_rec\recordings\rec2\vowels\k-a-k.wav');
y = resample(x,8000,44100);
path = 'C:\Users\AkhilBabu\Desktop\8th sem\EE628_speech_technology\assignment_work\Akhil_rec\recordings\rec2';
% plot_TFS(path,'velar',0);
% ceps_pp(y,8000,30,10);
% fft_cepstrum(y,8000,30,10,1);
% mel_cepstrum(y,8000,30,10,25,1);
% Ffft = feat_extract(y,8000,30,10,'fft');
% Fmel = feat_extract(y,8000,30,10,'mel');
% formant_estimate(y,8000,30,10,1);
formant_estimate(y,8000,30,10,0);
