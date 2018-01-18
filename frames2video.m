function frames2video(frames, filename)
	nr = length(frames);
	v = VideoWriter(filename, 'FileFormat', 'mp4', 'Quality', 100, 'FrameRate', nr/10);
	open(v);

	for i=1:length(frames)
		writeVideo(v, frames(i));
	end

	close(v);
end
