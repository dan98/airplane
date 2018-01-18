job = batch('mainv4')
disp('job sent, waiting ..');
wait(job)
load(job, 'frame')
frames2video(frame, 'genvideo')
