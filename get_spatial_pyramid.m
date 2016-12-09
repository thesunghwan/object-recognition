function image_feats = get_spatial_pyramid(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will depend on the structure of
% the spatial pyramid you construct. 

%load('vocab.mat')
%vocab_size = size(vocab, 2);

load('vocab.mat')
vocab_size = size(vocab, 1);
%vocab_size = size(vocab, 2);

histograms = [];

for i = 1:size(image_paths, 1)
    image_path = image_paths(i);
    image = imread(image_path{1});
    image = single(image);
    
    histogram = [];
    
    h0 = make_histogram(image, vocab, vocab_size);
    histogram = [histogram h0];
    
    pyramid_size = 2;
    horizontal_loop = [];
    vertical_loop = [];
    
    horizontal_division_unit = int16(size(image,1)/pyramid_size);
    vertical_division_unit = int16(size(image,2)/pyramid_size);
    
    horizontal_loop = [horizontal_loop 1];
    vertical_loop = [vertical_loop 1];
    for j = 1:pyramid_size-1
        horizontal_loop = [horizontal_loop horizontal_division_unit*j];
        vertical_loop = [vertical_loop vertical_division_unit*j];
    end
    horizontal_loop = [horizontal_loop size(image,1)];
    vertical_loop = [vertical_loop size(image,2)];
    
    for a = 1:pyramid_size
       for b = 1:pyramid_size
           histogram = [histogram make_histogram(imresize(image(horizontal_loop(a):horizontal_loop(a+1), vertical_loop(b):vertical_loop(b+1)), pyramid_size), vocab, vocab_size)];
       end
    end
    
    histograms = [histograms; histogram];
    image_feats = (histograms ./ max(max(histograms))) .* 100;
end

