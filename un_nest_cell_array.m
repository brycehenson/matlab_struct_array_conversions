function cell_out=un_nest_cell_array(cell_arr_in)
% un nest a nested cell arrays
% but only if the first level has a sigle element
% example
% a={{'1'},{[2]},{[1,2,3]}}
% out=un_nest_cell_array(a)
% where out is now {'1',[2],[1,2,3]}
% bryce henson 2020-06-28

cell_out=cell_arr_in;
    if iscell(cell_arr_in)
        is_elem=cellfun(@(x) iscell(x) && numel(x)==1,cell_arr_in);
        if  all(is_elem(:))
            cell_out=cellfun(@(x) x{1},cell_arr_in,'UniformOutput', false);
        end
    end


end