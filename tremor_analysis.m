% Mingzhe Hu
% 11/13/2021


% function outcomes
function outcomes = tremor_analysis(varargin)

%set up input parser
default_fname = "deidentified_trc/688/sit-rest1-TP.trc";
default_markername = "L.Finger3.M3";
default_plot_flag=0;

prs = inputParser;
prs.addOptional('fname', default_fname);
prs.addOptional('markername', default_markername);
prs.addOptional('plot_flag',default_plot_flag);
prs.parse(varargin{:});

%assign arguments
fname = prs.Results.fname;
markername = prs.Results.markername;
plot_flag = prs.Results.plot_flag;

% Peek the first five rows of the table
data = read_trc(fname);
head(data, 5)
trc = rename_trc(data);
% Obderve the table after renaming
head(trc, 1)
% *Filter data*
% 
% Only leave the data with the specific markername, and pass the data to a butterworth 
% bandpass filter.

% Filter out the unrelated markers
raw_data = trc{:,startsWith(names(trc),markername)};
% View the first row of the data
disp(raw_data(1, :))
% Call the bandpass butterworth filter
filtered_data = preprocess_marker_data(raw_data,trc.Time, [2 45]);
% *Principle component analysis*

% Both pc1_mm and time are 3600 x 1 vector
time_s = trc.Time;
pc1_mm = pc1(filtered_data);
% Visualize the principle component vs. the time.

figure
plot(time_s, pc1_mm);
xlim([0, 5])
xlabel("seconds")
ylabel("mm")
title("first five seconds")

% save the figure
saveas(gcf, "figures/figure1.png")
% *Visualizing time-varying tremor*

% Make the time table
TT=timetable(seconds(time_s),pc1_mm);
TT.Properties.VariableNames = [markername];
TT.Properties.VariableUnits = ["mm"];
% 3D visualization
[p,f,t] = pspectrum(TT, 'spectrogram', 'MinThreshold', -50, 'FrequencyResolution',0.5, 'FrequencyLimits',[0 20]);
figure
waterfall(f, seconds(t), p')
xlabel("Frequency (Hz)")
ylabel("Time (seconds)")
wtf = gca;
wtf.XDir = "reverse";
view([30, 45])
title("time varying tremer")
saveas(gcf, "figures/figure2.png")
% *Visualize the spectrogram over time*

figure
hold on
for i = 1:size(p, 2)
    plot(f, p(:, i));
end
xlabel("Hz")
ylabel("mm2/Hz")
title("spectrogram over time")
saveas(gcf, "figures/figure3.png")
hold off
% *Summarize the outcomes for the left wrist resting / action tremor*

% max power in any window (mm2/Hz)
[max_p, ind] = max(p, [], "all");
disp(["The max power in any window is:", max_p])

% Maximum power in any window
[r_ind,~] = ind2sub(size(p),ind);
f_max_p = f(r_ind);
disp(["The freuncy at overall max power:", f_max_p])

% variability in peak frequency, Hz
[~,ind] = max(p,[],1); 
f_sd = std(f(ind));
disp(["Standard deviation in peak frequency", f_sd])

% find the window number of the maximum power
[~, c_ind] = find(p == max_p);
%find the rms near the overall power
rms_power = rms(p(f-f_max_p<0.5 & f-f_max_p>-0.5, c_ind));
disp(["RMS Power", rms_power])

outcomes = [max_p, f_max_p, f_sd, rms_power];

end