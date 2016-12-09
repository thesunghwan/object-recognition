function histogram = make_histogram( image, vocab, vocab_size )
    [locations, SIFT_features] = vl_dsift(image, 'fast', 'step', 12);
    
    D = vl_alldist2(single(SIFT_features), transpose(single(vocab)));
    histogram = zeros(1, vocab_size);
    
    for j = 1:size(D, 1)
        [M, I] = min(D(j,:));
        histogram(I) = histogram(I) + 1;
    end
end

