cl = parcluster('local');
nr = str2num(getenv('SLURM_CPUS_ON_NODE'));;
cl.NumWorkers = nr;
saveProfile(cl);

cl
job = batch('mainv4', 'Pool', 12)
disp('job sent, waiting ..');
wait(job)
load(job, 'frame')
frames2video(frame, 'genvideo')
