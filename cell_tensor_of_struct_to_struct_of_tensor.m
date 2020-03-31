function out_struct=cell_tensor_of_struct_to_struct_of_tensor(tensor_of_struct,convert_to_mat)
%https://au.mathworks.com/matlabcentral/fileexchange/40712-convert-from-a-structure-of-arrays-into-an-array-of-structures
% field sizes must singletons
% if any fields are missing will replace with nan
if nargin<2
    convert_to_mat=true;
end

out_struct=struct;
out_field_names= cell(0,1);%fieldnames(out_struct);
size_tensor=size(tensor_of_struct);
sub_tmp=cell([1,numel(size_tensor)]);
ind_max=prod(size_tensor);

for ii=1:ind_max
    [sub_tmp{:}]=ind2sub(size_tensor,ii);
    element_struct_tmp=tensor_of_struct{sub_tmp{:}};
    field_names_element =  fieldnames(element_struct_tmp);
    for jj=1:numel(field_names_element)
        if ~any(strcmp(out_field_names,field_names_element(jj)))
            % create this field
            out_struct.(field_names_element{jj})=cell(size_tensor);
            out_field_names=fields(out_struct);
        end
        tmp_element=out_struct.(field_names_element{jj});
        tmp_element{sub_tmp{:}}=element_struct_tmp.(field_names_element{jj});
        out_struct.(field_names_element{jj})=tmp_element;
    end
end

if convert_to_mat
    for ii=1:numel(out_field_names)
        try
            element_tmp=out_struct.(out_field_names{ii});
            empty_mask=cellfun(@isempty,element_tmp);
            element_tmp(empty_mask)=repmat({NaN},[sum(empty_mask(:)),1]);
             element_tmp=cell2mat(element_tmp);
            out_struct.(out_field_names{ii})=element_tmp;
        catch
            fprintf('cant convert field %s to double',out_field_names{ii})
        end
    end
end


end

% 
% fieldnames = fields(s);
% nfields = numel(fieldnames);
% out = [];
% num_entries = length(m);
% for ii=1:nfields
%    this_field = fieldnames{ii};
%    this_data = s.(this_field);
%    if size(this_data,1) == 1
%        this_data = this_data';
%    end
%    if size(this_data,2) > 1
%        out.(this_field) =this_data(m,:);
%    else
%        out.(this_field) =this_data(m);
% 
%    end
% end
% 
% end


