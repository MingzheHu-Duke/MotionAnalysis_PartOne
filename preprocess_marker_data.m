% This is the script that use a butterworth bandpass filter
% To filter out the low and high frequencies
function sig_out = preprocess_marker_data(sig_in, time, cfreq)
% sig_in: the input signal
% time: the trc time
% cfreq: the cutoff frequencies, a vector
Ts = mean(diff(time));
% Sample frequency
Fs = 1/Ts;
Fn  = Fs/2;
% Pass through butterworth
[b, a] = butter(5, cfreq/Fn, "bandpass");
% The order is set  to 5
sig_out = filtfilt(b, a, sig_in);
end
