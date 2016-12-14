function [vn] = normalized(v)

num=repmat(min(v), [size(v,1) 1]);
den=repmat(max(v)-min(v), [size(v,1) 1]);
vn=double(v-num)./double(den);
vn(isnan(vn))=0;
end