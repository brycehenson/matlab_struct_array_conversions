function out_struct=struct_array_to_struct_of_array(struct_arr_in,convert_to_num_arr,convert_single_cell_arr)
% convert from the terrible struct array format to a structure of arrays
% can handle arb strucuture depth, this is what makes this implementation very slow
% TODO
% - use the faster approach when ther is no depth to the struct element
% bryce henson 2020-06-29

% example
% tensor_dims=[3,4,3];
% test_struct_array=struct('data1',num2cell(rand(tensor_dims)),'data2',num2cell(rand(tensor_dims)>0.5));
% 
% out_struct=struct_tensor_to_struct_of_tensor(test_struct_array)

if nargin<2
    convert_to_num_arr=true;
end

if nargin<3
    convert_single_cell_arr=true;
end

field_paths_in=struct_field_paths_elements_flatten(struct_arr_in);
nfields = numel(field_paths_in);
input_size=size(struct_arr_in);
jjmax=prod(input_size);
sub_tmp=cell([1,numel(input_size)]); % array index cell arr
out_struct=[];

out_field_vals=cell(nfields,1);
field_val_template=cell(input_size);

for ii=1:nfields
    field_val_tmp=field_val_template;
    % not sure how to get the feild values out more than 1 at a time for a struct that is more than 1 deep
    % so will have to brute force it
    for jj=1:jjmax
        [sub_tmp{:}]=ind2sub(input_size,jj);
        field_val_tmp{sub_tmp{:}}=getfield(struct_arr_in(sub_tmp{:}),field_paths_in{ii}{:});
    end
    out_field_vals{ii} =field_val_tmp;
end

%out_struct=setfield(out_struct,field_paths_in{1}{:},field_values);

if convert_to_num_arr
    for ii=1:nfields
        try
            element_tmp=out_field_vals{ii};
            empty_mask=cellfun(@isempty,element_tmp);
            element_tmp(empty_mask)=repmat({NaN},[sum(empty_mask(:)),1]);
            element_tmp=cell2mat(element_tmp);
            out_field_vals{ii}=element_tmp;
        catch
            tmp_path=field_paths_in{ii};
            fprintf('cant convert field %s to double\n',strjoin(tmp_path(:),','))
        end
    end
end

% un nest cell array
if convert_single_cell_arr
    if ~convert_to_num_arr
        error('must also select convert_to_num_arr')
    end
    for ii=1:nfields
            element_tmp=out_field_vals{ii};
            if iscell(element_tmp)
                element_tmp=un_nest_cell_array(element_tmp);
                out_field_vals{ii}=element_tmp;
            end
    end
end

out_struct=struct_field_paths_elements_build(field_paths_in,out_field_vals);


end
