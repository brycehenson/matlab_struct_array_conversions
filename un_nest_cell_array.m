function cell_arr_out=un_nest_cell_array(cell_arr_in,recursive)
% un nest a nested cell arrays
% but only if the first level has a sigle element
% example
% a={{'1'},{[2]},{[1,2,3]}}
% out=un_nest_cell_array(a)
% where out is now {'1',[2],[1,2,3]}
% the recursive applies the function repeatedly untill the output does not change
% example
% un_nest_cell_array({{{{'1'}}},{{{[2]}}},{{{[1,2,3]}}}},1)
% bryce henson 2020-06-28

if nargin<2
    recursive=0;
end


cell_arr_out=cell_arr_in;
if iscell(cell_arr_in)
    is_elem=cellfun(@(x) iscell(x) && numel(x)==1,cell_arr_in);
    if  all(is_elem(:))
        cell_arr_out=cellfun(@(x) x{1},cell_arr_in,'UniformOutput', false);
    end
end
% keep applying this function until the output does not change upon an aplication
if ~isequaln(cell_arr_out,cell_arr_in) && recursive
    cell_arr_out=un_nest_cell_array(cell_arr_out,1);
end 


end