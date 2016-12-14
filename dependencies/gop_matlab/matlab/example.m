%{
    Copyright (c) 2014, Philipp Krähenbühl
    All rights reserved.
	
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
        * Neither the name of the Stanford University nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.
	
    THIS SOFTWARE IS PROVIDED BY Philipp Krähenbühl ''AS IS'' AND ANY
    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL Philipp Krähenbühl BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}
clear all;
init_gop;

try
c = parcluster('local');
c.NumWorkers = 12;
matlabpool(12);
catch; end;

% Set a boundary detector by calling (before creating an OverSegmentation!):
% gop_mex( 'setDetector', 'SketchTokens("../data/st_full_c.dat")' );
% gop_mex( 'setDetector', 'StructuredForest("../data/sf.dat")' );
gop_mex( 'setDetector', 'MultiScaleStructuredForest("../data/sf.dat")' );

% Setup the proposal pipeline (baseline)
p = Proposal('max_iou', 0.8,...
    'unary', 130, 5, 'seedUnary()', 'backgroundUnary({0,15})',...
    'unary', 130, 1, 'seedUnary()', 'backgroundUnary({})', 0, 0, ... % Seed Proposals (v1.2 and newer)
    'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ... % Background Proposals
    );
% Setup the proposal pipeline (learned)
% p = Proposal('max_iou', 0.8,...
%              'seed', '../data/seed_final.dat',...
%              'unary', 140, 4, 'binaryLearnedUnary("../data/masks_final_0_fg.dat")', 'binaryLearnedUnary("../data/masks_final_0_bg.dat"',...
%              'unary', 140, 4, 'binaryLearnedUnary("../data/masks_final_1_fg.dat")', 'binaryLearnedUnary("../data/masks_final_1_bg.dat"',...
%              'unary', 140, 4, 'binaryLearnedUnary("../data/masks_final_2_fg.dat")', 'binaryLearnedUnary("../data/masks_final_2_bg.dat"',...
%              'unary', 140, 1, 'seedUnary()', 'backgroundUnary({})', 0, 0, ... % Seed Proposals (v1.2 and newer)
%              'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ...
%              );

% Load in image
imdir='D:\Image Datasets\urban\full\graz50\rectified\';
imnames=dir([imdir '*.jpg']);
parfor it = 1:40
    I = imread([imdir imnames(it).name]);
%    I=imresize(I0,1);
    % Create an over-segmentation
    tic();
    os(it) = OverSegmentation( I );
end
return
    % Generate proposals

    tic();
    os_=os(it);
    props{it} = p.propose( os_ );
    t2 = toc();
   
    fprintf( ' %d proposals generated. OverSeg %0.3fs, Proposals %0.3fs. Image size %d x %d.\n', size(props,1), t1, t2, size(I,1), size(I,2) );
    
    % If you just want boxes
    boxes = os{it}.maskToBox( props );
    %figure();imagesc(I);
    for i=1:length(boxes)
         clf;
%         mask = props(i,:);
%         m = uint8(mask( os.s()+1 ));
%         %         % Visualize the mask
%         %         subplot(3,3,i-18)
%         II = 1*I;
%         II(:,:,1) = II(:,:,1) .* (1-m) + m*255;
%         II(:,:,2) = II(:,:,2) .* (1-m);
%         II(:,:,3) = II(:,:,3) .* (1-m);
         imagesc( I );
         rectangle( 'Position', [boxes(i,1),boxes(i,2),boxes(i,3)-boxes(i,1)+1,boxes(i,4)-boxes(i,2)+1], 'LineWidth',2, 'EdgeColor',[0,1,0] );
%         x1=boxes(i,1)/0.2;x2=boxes(i,3)/0.2;y1=boxes(i,2)/0.2;y2=boxes(i,4)/0.2;
%         cr_l=y2-y1;cr_w=x2-x1;
%         cropped = imcrop(I0,[x1-cr_w/6 y1-cr_l/6 cr_w+cr_w/3 cr_l+cr_l/3]);
%          x1=boxes(i,1);x2=boxes(i,3);y1=boxes(i,2);y2=boxes(i,4);
%         cr_l=y2-y1;cr_w=x2-x1;
%         cropped = imcrop(I,[x1-cr_w/6 y1-cr_l/6 cr_w+cr_w/3 cr_l+cr_l/3]);
%         imwrite(cropped,['objects/' num2str(it) '_' num2str(i) '.jpg']); 
input('');
    end
    %voteobj;
end


