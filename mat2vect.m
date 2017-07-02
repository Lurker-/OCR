% REFMAT2VEC Convert referencing matrix to referencing vector
%
%   REFMAT2VEC will be removed in a future release. Use
%   refmatToGeoRasterReference instead, which will construct a geographic
%   raster reference object.
%
%   REFVEC = REFMAT2VEC(R,S) converts a referencing matrix, R, to the 
%   referencing vector REFVEC.  R is a 3-by-2 referencing matrix defining a
%   2-dimensional affine transformation from pixel coordinates to
%   geographic coordinates.  S is the size of the data grid that is being
%   referenced. REFVEC is a 1-by-3 referencing vector with elements
%   [cells/angleunit north-latitude west-longitude].  
%
%   Example 
%   -------
%      % Verify the conversion of the geoid referencing vector to a
%      % referencing matrix.
%      load geoid
%      geoidrefvec
%      R = refvec2mat(geoidrefvec, size(geoid))
%      refvec = refmat2vec(R, size(geoid))
%
%   See also refmatToGeoRasterReference

% Copyright 1996-2013 The MathWorks, Inc.

function[j]=mat2vect(i)
j = [];
j =[i(1,:).';i(2,:).';i(3,:).';i(4,:).';i(5,:).';i(6,:).';i(7,:).'; ...
    i(8,:).';i(9,:).';i(10,:).';i(11,:).';i(12,:).';i(13,:).' ...
    ;i(14,:).';i(15,:).';i(16,:).';i(17,:).';i(18,:).' ...
    ;i(19,:).';i(20,:).';i(21,:).';i(22,:).';i(23,:).';i(24,:).';i(25,:).'...
    ;i(26,:).';i(27,:).';i(28,:).';i(29,:).';i(30,:).';i(31,:).';i(32,:).'...
    ;i(33,:).';i(34,:).';i(35,:).'];
end
