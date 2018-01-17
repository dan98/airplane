function frames2video(frames, filename)
	v = VideoWriter(filename);
	open(v);

	for i=1:length(frames)
		writeVideo(v, frames(i));
	end

	close(v);
end
