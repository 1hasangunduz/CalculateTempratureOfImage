clear all
close all
clc
ben= imread('hotcoffee.tif');

whos ben
range = [min(ben(:)) max(ben(:))]

figure
imshow(ben,[])
colormap(gca,hot)
title('Original image')

smoothValue = 0.01*diff(range).^2;
J = imguidedfilter(ben,'DegreeOfSmoothing',smoothValue);

figure
imshow(J,[])
colormap(gca,hot)
title('Guided filtered image')

thresh = multithresh(J,2)

L = imquantize(J,thresh);
L = imfill(L);

figure
imshow(label2rgb(L))
title('Label matrix from 3-level Otsu')

props = regionprops(L,ben,{'Area','BoundingBox','MeanIntensity','Centroid'});

[~,idx] = max([props.Area]);

figure
imshow(ben,[])
colormap(gca,hot)
title('Segmented regions with mean temperature')
for n = 1:numel(props)
    
    if n ~= idx
       rectangle('Position',props(n).BoundingBox,'EdgeColor','c')
       
       T = [num2str(props(n).MeanIntensity,3) ' \circ C'];
       text(props(n).Centroid(1),props(n).Centroid(2),T,...
           'Color','c','FontSize',12)
    end
end