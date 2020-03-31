%struct_tensor conversion

%% convert a structure of tensors to a cell tensor of structures

tensor_dims=[3,4,3];
test_struct=[];
test_struct.data1=rand(tensor_dims);
test_struct.data2=rand(tensor_dims);
test_struct.data3=rand(tensor_dims)>0.5;
test_struct.data4=num2cell(rand(tensor_dims));
test_struct.data5=6;
test_struct.data6=rand(tensor_dims(1:2));
test_struct.data7=rand(tensor_dims(1),1,tensor_dims(3));

cell_tensor_of_struct_to_struct_of_tensor

out_struct=struct_of_tensor_to_cell_tensor_of_struct(test_struct)

field_names=fields(test_struct);
for kk=1:1e4
    index_test_cell=[randi(tensor_dims(1)),randi(tensor_dims(2)),randi(tensor_dims(3))];
    index_test_cell=num2cell(index_test_cell);
    index_test_vec=[index_test_cell{:}];
    single_stuct=out_struct{index_test_cell{:}};
    for ii=1:numel(field_names)
        tmp_field_tensor=test_struct.(field_names{ii});
        field_size=size(tmp_field_tensor);
        field_size=cat(2,field_size,ones(1,numel(index_test_vec)-numel(field_size)));
        idx_above_size_mask=index_test_vec>field_size;
        index_tmp=index_test_vec;
        index_tmp(idx_above_size_mask)=1;
        index_tmp=num2cell(index_tmp);
        out_value=out_struct{index_test_cell{:}}.(field_names{ii});
        in_value=tmp_field_tensor(index_tmp{:});
        if ~isequal(out_value,in_value)
            error('not equal')
        end
    end

end


%% convert a cell array of (possibly unmatching) structures to a structure of 
%  cell(or if converable double) tensors

test_cell_of_struct=cell(2,2);
a=[];
a.data1=1;
a.data2=53435;
test_cell_of_struct{1,1}=a;
a=[];
a.data1=78;
a.data3=45;
test_cell_of_struct{1,2}=a;
a=[];
a.data2=2;
a.data3=95;
test_cell_of_struct{2,1}=a;
a=[];
a.data1=8;
a.data3=74;
test_cell_of_struct{2,2}=a;


out_struct=cell_tensor_of_struct_to_struct_of_tensor(test_cell_of_struct)



%% Convert a struct tensor to a structure of cell(or if converable double) tensors

tensor_dims=[3,4,3];
rdata1=num2cell(rand(tensor_dims));
rdata2=num2cell(rand(tensor_dims)>0.5);
test_struct_array=struct('data1',rdata1,'data2',rdata2);

out_struct_tensors=struct_tensor_to_struct_of_tensor(test_struct_array);
isequal(cell2mat(rdata1(2,3,2)),test_struct_array(2,3,2).data1,out_struct_tensors.data1(2,3,2))

% Convert a structure of tensors to a struct tensor
out_struct_array=struct_of_tensor_to_struct_tensor(out_struct_tensors);


isequal(test_struct_array,out_struct_array)

