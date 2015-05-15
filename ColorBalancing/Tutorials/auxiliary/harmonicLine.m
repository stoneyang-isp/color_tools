%
% The purpose of this script is to illustrate how a large set of
% cosinusoidal functions (haromnics) sum to a line.  This is
% counter-intuitive.  So I thought to demonstrate how it happens
%

%%
cd('C:\u\brian\Matlab\vistaTEACH\Teaching\EE 362\auxiliary')

%% Create a set of cosinusoids at a range of frequencies from 0 -> N
freq = (1:128); nFreq = length(freq);
c = zeros(length(freq),length(x));

for ii=1:nFreq
    f = freq(ii);
    c(ii,:) = cos(2*pi*f*x)';
end

% Here is a sample of the first few cosinsuoids
plot(x,c(1:3,:))
xlabel('position')
ylabel('amplitude');
title('Cosinusoids')
grid on

%% Sum up the cosinusoids a little bit at a time, plotting them as we go
%
for ii=1:1:(nFreq)
    tmp = c(1:ii,:);
    s = sum(tmp);
    s = s/max(s(:));
    str = sprintf('Freqs 1-%.0f',ii);
    clf; plot(x,s,'k-'); text(0.3,0.75,str);
    set(gca,'ylim',[-.3 1]);
    M(ii) = getframe;
    pause(0.1)
end
movie(M)
movie2avi(M,'harmonicLine')

%% Create the spatial sample positions and line
x = (-127:128)/128;

% Create a line at position 0
Line = zeros(1,256);
Line(128) = 1;
plot(x,Line)
xlabel('x position')
ylabel('intensity')
grid on

%% Compute the Fourier Transform of the line

LineFFT = fft(Line);
plot(x,abs(LineFFT));  %Notice that it is equal amp across freq
xlabel('Frequency');
ylabel('Amplitude');
grid on
set(gca,'ylim',[0 2]);


