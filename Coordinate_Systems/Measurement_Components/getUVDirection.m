function z=getUVDirection(zC,zRx,M,includeW)
%%GETUVDIRECTION Convert a position into local direction cosines [u;v] or
%         [u;v;w]. Direction cosines u and v are just the x and y
%         coordinates of a unit vector from the receiver to the target in
%         the coordinate system at the receiver. This basically assumes
%         that the boresight direction of the receiver is the z axis.
%         Assuming the target is in front of the receiver, the third unit
%         vector coordinate is not needed. However, with the includeW
%         option, it can be provided, resulting in r-u-v-w coordinates.
%
%INPUT: zC A 3XN matrix of points in global [x;y;z] Cartesian coordinates.
%      zRx The 3XN [x;y;z] location vectors of the receivers in Cartesian
%          coordinates.  If this parameter is omitted or an empty matrix is
%          passed, then the receivers are assumed to be at the origin. If
%          only a single vector is passed, then the receiver location is
%          assumed the same for all of the target states being converted.
%        M A 3X3XN hypermatrix of the rotation matrices to go from the
%          alignment of the global coordinate system to that at the
%          receiver. The z-axis of the local coordinate system of the
%          receiver is the pointing direction of the receiver. If omitted
%          or an empty matrix is passed, then it is assumed that the local
%          coordinate system is aligned with the global and M=eye(3) --the
%          identity matrix is used. If only a single 3X3 matrix is passed,
%          then is=t is assumed to be the same for all of the N
%          conversions. Typically, if includeW is false, it doesn't make
%          sense to return the u-v values that are not local, so one will
%          usually omit M in that instance.
%  includeW An optional boolean value indicating whether a third direction
%          cosine component should be included. The u and v direction
%          cosines are two parts of a 3D unit vector. Generally, one might
%          assume that the target is in front of the sensor, so the third
%          component would be positive and is not needed. However, the
%          third component can be included if ambiguity exists. The default
%          if this parameter is omitted or an empty matrix is passed is 
%          false.
%
%OUTPUT: z The 2XN (or 3XN if includeW is true) matrix of direction cosines
%          of the converted points in the form [u;v] or [u;v;w].
%
%Details of the conversion are given in [1].
%
%REFERENCES:
%[1] David F. Crouse , "Basic tracking using nonlinear 3D monostatic and
%    bistatic measurements," IEEE Aerospace and Electronic Systems
%    Magazine, vol. 29, no. 8, Part II, pp. 4-53, Aug. 2014.
%
%February 2017 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

N=size(zC,2);

if(nargin<4||isempty(includeW))
    includeW=false;
end

if(nargin<3||isempty(M))
    M=repmat(eye(3),[1,1,N]);
elseif(size(M,3)==1)
    M=repmat(M,[1,1,N]);
end

if(nargin<2||isempty(zRx))
    zRx=zeros(3,N);
elseif(size(zRx,2)==1)
    zRx=repmat(zRx,[1,N]);
end

%Allocate space for the return values.
if(includeW==true)
    z=zeros(3,N);
else
    z=zeros(2,N);
end
for curPoint=1:N
    %The target location in the receiver's coordinate system.
    zCL=M(:,:,curPoint)*(zC(:,curPoint)-zRx(1:3,curPoint));

    %Perform the conversion.
    r1=norm(zCL);%Receiver to target.

    u=zCL(1)/r1;
    v=zCL(2)/r1;

    z(1:2,curPoint)=[u;v];
    if(includeW)
        z(3,curPoint)=zCL(3)/r1;
    end
end
end

%LICENSE:
%
%The source code is in the public domain and not licensed or under
%copyright. The information and software may be used freely by the public.
%As required by 17 U.S.C. 403, third parties producing copyrighted works
%consisting predominantly of the material produced by U.S. government
%agencies must provide notice with such work(s) identifying the U.S.
%Government material incorporated and stating that such material is not
%subject to copyright protection.
%
%Derived works shall not identify themselves in a manner that implies an
%endorsement by or an affiliation with the Naval Research Laboratory.
%
%RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF THE
%SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY THE NAVAL
%RESEARCH LABORATORY FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE ACTIONS
%OF RECIPIENT IN THE USE OF THE SOFTWARE.
