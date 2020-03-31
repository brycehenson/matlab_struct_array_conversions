function out_tensor=struct_of_tensor_to_cell_tensor_of_struct(in_struct)
%https://au.mathworks.com/matlabcentral/fileexchange/40712-convert-from-a-structure-of-arrays-into-an-array-of-structures
% field sizes must match or have size 1 in unmatching dimensions

if numel(in_struct)>1
    error('this should only have one element')
end

    
field_names_in = fieldnames(in_struct);
nfields = numel(field_names_in);
field_cells=struct2cell(in_struct);
field_cells=match_tensor_sizes(field_cells,'repmat');

cell_sizes=size(field_cells{1});
ind_max=prod(cell_sizes);

out_tensor=cell(cell_sizes);
element_template=cell2struct(cell(nfields,1),field_names_in);

sub_tmp=cell([1,numel(cell_sizes)]);
for ii=1:ind_max
        element_tmp=element_template;
        [sub_tmp{:}]=ind2sub(cell_sizes,ii);
        for jj=1:nfields
            tensor_tmp=field_cells{jj};
            element_tmp.(field_names_in{jj})=tensor_tmp(sub_tmp{:});
        end
        out_tensor{sub_tmp{:}}=element_tmp;
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