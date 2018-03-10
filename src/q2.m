clc;clear ALL
[x,f] = wavread('sentence_rand1.wav');
fs = 8000;
resample(x,f,fs);       
fsize = 30;                                             % Adjust required frame size
fshift= 10;                                             % Adjust required frame shift

R = plot_STAC(x,f,fsize,fshift,1);                        
pp = plot_pp(x,f,fsize,fshift);