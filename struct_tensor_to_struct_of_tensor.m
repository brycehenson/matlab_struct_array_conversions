function out_struct=struct_tensor_to_struct_of_tensor(struct_tensor_in,convert_to_mat)

% example
% tensor_dims=[3,4,3];
% test_struct_array=struct('data1',num2cell(rand(tensor_dims)),'data2',num2cell(rand(tensor_dims)>0.5));
% 
% out_struct=struct_tensor_to_struct_of_tensor(test_struct_array)

if nargin<2
    convert_to_mat=1;
end

input_size=size(struct_tensor_in);
in_field_names=fieldnames(struct_tensor_in);
out_struct=[];

for ii=1:numel(in_field_names)
    % not sure how to get the feild values out as an array directly
    field_values={struct_tensor_in.(in_field_names{ii})};
    field_values=reshape(field_values,input_size);
    out_struct.(in_field_names{ii})=field_values;
end

if convert_to_mat>=1
    for ii=1:numel(in_field_names)
        try
        	element_tmp=out_struct.(in_field_names{ii});
            empty_mask=cellfun(@isempty,element_tmp);
            element_tmp(empty_mask)=repmat({NaN},[sum(empty_mask(:)),1]);
            element_tmp=cell2mat(element_tmp);
            out_struct.(in_field_names{ii})=element_tmp;
        catch
            if convert_to_mat>=2
                fprintf('cant convert field ''%s'' to double \n',in_field_names{ii})
            end
        end
    end
end



end
