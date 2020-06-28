function out_st_arr=struct_of_array_to_struct_array(in_struct)
% this function will build a struct array from a struct of arrays
% i dont recomend using this struct array format
% but this function is here if you need it
% creation is slow because (as far as i can find) matlab has no way to directry create these struct arrays
% while also hadnling arb structure depth eg data1.thing1.unc
% bryce henson 2020-06-29


[field_paths_in,field_cells]=struct_field_paths_elements_flatten(in_struct);
nfields = numel(field_paths_in);
% we need to change how the the elements are adressed if they come from a cell array
is_field_cell_array=cellfun(@(x) iscell(x),field_cells);

% match the sizes of the structure elements
field_cells=match_array_sizes(field_cells,'repmat');
cell_sizes=size(field_cells{1});
ind_max=prod(cell_sizes);

% not really sure how i should initalize out_st_arr
%out_st_arr={};

field_cells_template=cell(size(field_cells));
feild_paths_template=field_paths_in;
sub_tmp=cell([1,numel(cell_sizes)]); % array index cell arr
for ii=1:ind_max
        % initalize the field element and path that will build the strucute for this cell
        element_tmp=field_cells_template;
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
            element_tmp{jj}=val_tmp;
        end
        st_tmp=struct_field_paths_elements_build(feild_paths_template,element_tmp);
        out_st_arr(sub_tmp{:})=st_tmp;
end



end


% field_names_in = fieldnames(in_struct);
% is_struct_mask=structfun(@isstruct, in_struct);
% if sum(is_struct_mask)>0
%     error('this function cannot handle strucutes that are more than 1 deep')
% end
% 
% nfields = numel(field_names_in);
% 
% 
% cell_array_fields=cell(nfields,1);
% for ii=1:nfields
%     cell_array_tmp=in_struct.(field_names_in{ii});
%     cell_array_tmp=num2cell(cell_array_tmp);
%     cell_array_fields{ii}=cell_array_tmp;
% end
% 
% % i cant find any other way to directly produce a struct array
% % cell 2 struct just produces a struct of tensors
% % to allow for dynamic number of fields we have to dynamicaly create the inputs
% creation_comand=reshape([field_names_in,cell_array_fields]',[],1);
% struct_out=struct(creation_comand{:});
% 
% %struct_out = cell2struct(cell_array_fields, field_names_in, 1);
