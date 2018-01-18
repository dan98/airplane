function frames2video(frames, filename)
	nr = length(frames);
	v = VideoWriter(filename);
	v.FileFormat = 'mp4';
	v.Quality = 100;
	v.FrameRate =nr/10;
	open(v);

	for i=1:length(frames)
		writeVideo(v, frames(i));
	end

	close(v);
end
