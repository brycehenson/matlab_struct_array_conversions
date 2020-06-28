function out_array=struct_of_array_to_cell_array_of_struct(in_struct)
% convert a structure of (nd)arrays  to a cell array of structures
% the strucutes in each cell will not have fields if the coresponding location in the origianl array is empty
% this function can handle full nested strucuted
% Bryce Henson 2020-06-29

if numel(in_struct)>1
    error('this should only have one element')
end

% flatten the struct converting it into 2 peices of information
% the field paths eg data.thing1.subthing1 -> {{'thing1','subthing1'}}
% a cell with the value of each of the fields at that path

[field_paths_in,field_cells]=struct_field_paths_elements_flatten(in_struct);
nfields = numel(field_paths_in);
% we need to change how the the elements are adressed if they come from a cell array
is_field_cell_array=cellfun(@(x) iscell(x),field_cells);

% match the sizes of the structure elements
field_cells=match_array_sizes(field_cells,'repmat');
% initalize the output array
cell_sizes=size(field_cells{1});
ind_max=prod(cell_sizes);
out_array=cell(cell_sizes);

field_cells_template=cell(size(field_cells));
feild_paths_template=field_paths_in;
sub_tmp=cell([1,numel(cell_sizes)]); % array index cell arr
for ii=1:ind_max
        % initalize the field element and path that will build the strucute for this cell
        element_tmp=field_cells_template;
        paths_tmp=feild_paths_template;
        [sub_tmp{:}]=ind2sub(cell_sizes,ii);
        for jj=1:nfields
            array_tmp=field_cells{jj};
            val_tmp=array_tmp(sub_tmp{:});
            if is_field_cell_array(jj) %if come from cell array the output will be a single element cell array
                if numel(val_tmp)>1
                    error('runtime error, cell array query returned more than signle element cell array')
                end
                val_tmp=val_tmp{1};
            end
            if isempty(val_tmp) % if the value is empty dont add this to the output struct
                paths_tmp(jj)=[];
                element_tmp(jj)=[];
            else
                element_tmp{jj}=val_tmp;
            end
        end
        st_tmp=struct_field_paths_elements_build(paths_tmp,element_tmp);
        out_array{sub_tmp{:}}=st_tmp;
end


end
