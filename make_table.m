filenames_tb=readtable("icd/icd.csv");
file_root = "MotionAnalysis_PartOne";

len = size(filenames_tb.id);
% Pre-allocate the memory
max_p = zeros(len, 1);
f_max_p = zeros(len, 1);
f_sd =zeros(len, 1);
rms_power = zeros(len, 1);
for i=1:len
    id = filenames_tb.id(i);
    trc_filenames = strcat(file_root,string(id), "\*.trc");
    trc_files = dir(trc_filenames);
    f = strcat(trc_files.folder, "\", trc_files.name);
    analysis_out = tremor_analysis('fname', f); 
    max_p(i) = analysis_out(1);
    f_max_p(i) = nalysis_out(2);
    f_sd(i) = analysis_out(3);
    rms_power(i) = analysis_out(4);
    
end
% Generate the table
table = table(max_p',f_max_p', f_sd', rms_power', 'VariableNames', ...
    {'max_p','f_max_p','f_sd','rms_power'});
writetable(table,"results.csv")