function varargout=match_tensor_sizes_multi_in(varargin)
% a wraper so that the outputs can asigned in a single line eg.
% [a,b,c]=match_tensor_sizes_multi_in(1,[2,3,4],[5,6,7])
% istead of
% out_mats=match_tensor_sizes({x,lower,upper},'repmat');
% x=out_mats{1};
% lower=out_mats{2};
% upper=out_mats{3};

% Bryce Henson 2020-04-05
        
    varargout=match_tensor_sizes(varargin,'repmat');
    
end