function mouthmap = getMouthmap(im_test, face_location)
%im_test = imread('TestImagesForPrograms\22.jpg');
[n,m,~] = size(im_test);
mask = zeros(n,m);
mask(face_location) = 255;
se = [0,1,0; 1,1,1; 0,1,0];
mask = imdilate(mask,se);
mask = imerode(mask,se);
face = zeros(n,m,3);
[row, col] = find(mask == 255);
idx = sub2ind(size(mask),row, col);
face(idx) = im_test(idx); face(idx + n*m) = im_test(idx + n*m); face(idx + 2*n*m) = im_test(idx + 2*n*m);
T = [0.299, 0.587, 0.114; -0.169, -0.331, 0.5; 0.5, -0.419, -0.081];
feature_test = double(reshape(face, [n*m,3]));
feature_test1 = T*(feature_test)';
feature_test1 = feature_test1';
im_recover = double(reshape(feature_test1, [n,m,3]));
% image in YCbCr coordinate
Y = im_recover(:,:,1);
Cb = im_recover(:,:,2);
Cr = im_recover(:,:,3);
pos = find(Cr ~= 0);
[num, ~] = size(pos);
numerator = sum(Cr(pos).^2)/num;
denominator = sum(Cr(pos)./Cb(pos))/num;
eta = 0.95*numerator/denominator;
temp = (Cr.^2 - (eta*Cr)./Cb).^2;
mouthmap = myGeneralAnd(Cr.^2, temp);
end