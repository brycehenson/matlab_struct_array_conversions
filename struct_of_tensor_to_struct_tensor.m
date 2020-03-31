function struct_out=struct_of_tensor_to_struct_tensor(in_struct)

field_names_in = fieldnames(in_struct);
nfields = numel(field_names_in);


cell_array_fields=cell(nfields,1);
for ii=1:nfields
    cell_array_tmp=in_struct.(field_names_in{ii});
    cell_array_tmp=num2cell(cell_array_tmp);
    cell_array_fields{ii}=cell_array_tmp;
end

% i cant find any other way to directly produce a struct tensor
% cell 2 struct just produces a struct of tensors
% to allow for dynamic number of fields we have to dynamicaly create the inputs
creation_comand=reshape([field_names_in,cell_array_fields]',[],1);
struct_out=struct(creation_comand{:});

%struct_out = cell2struct(cell_array_fields, field_names_in, 1);



end