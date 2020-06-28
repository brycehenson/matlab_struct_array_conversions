%struct_array conversion
% TODO
% - more cases to check
% - split checks into functions

% struct_of_array_to_cell_array_of_struct
% cell_array_of_struct_to_struct_of_array
% struct_of_array_to_struct_array
% struct_array_to_struct_of_array

%% convert a structure of arrays to a cell array of structures
% create a test structure where each field has an array
array_dims=[3,4,3];
test_st_of_arr=[];
test_st_of_arr.data1=rand(array_dims);
test_st_of_arr.data2=rand(array_dims);
test_st_of_arr.data2(1,1)=nan;
test_st_of_arr.data3=rand(array_dims)>0.5;
test_st_of_arr.data4=num2cell(rand(array_dims));
test_st_of_arr.data4{1,1}='a';
test_st_of_arr.data5=6;
test_st_of_arr.data6=rand(array_dims(1:2));
test_st_of_arr.data7=rand(array_dims(1),1,array_dims(3));
test_st_of_arr.data8=num2cell(rand(array_dims));


%cell_array_of_struct_to_struct_of_array

out_st_of_arr=struct_of_array_to_cell_array_of_struct(test_st_of_arr);

% in the remainder of this section we check that the output is what we expect

% check that the dimensions are the same
if ~isequal(size(out_st_of_arr),array_dims)
    error('sizes are not the same')
end


% lets go through each field/element and check that the values are equal
field_names=fields(test_st_of_arr);
kkmax=prod(array_dims); %max linear index of he array
%initalize the cells to store the array subsscript
index_test_cell=cell(1,numel(array_dims));
% loop over all the linear index
for kk=1:kkmax
    [index_test_cell{:}]=ind2sub(array_dims,kk);
    index_test_vec=[index_test_cell{:}];
    single_stuct=out_st_of_arr{index_test_cell{:}};
    for ii=1:numel(field_names)
        out_value=out_st_of_arr{index_test_cell{:}}.(field_names{ii});
        tmp_field_array=test_st_of_arr.(field_names{ii});
        % we need to deal with the mismatch in dimensions for example in test_struct.data5=6 
        field_size=size(tmp_field_array);
        field_size=cat(2,field_size,ones(1,numel(index_test_vec)-numel(field_size)));
        idx_above_size_mask=index_test_vec>field_size;
        index_tmp=index_test_vec;
        index_tmp(idx_above_size_mask)=1;
        index_tmp=num2cell(index_tmp);
        % check that the values are the same
        in_value=tmp_field_array(index_tmp{:});
        if iscell(in_value)
            in_value=in_value{1};
        end
        if ~ isequaln(out_value,in_value)
            error('not equal')
        end
    end
end

%% convert back into a struct of arrays

out_struct_of_arr=cell_array_of_struct_to_struct_of_array(out_st_of_arr,1)

% lets simplify the comparison by comparing with test_struct_of_arrays
% now something that comes up here is that .data8 was a cell array but is trivialy convertable to a numeric array
% the second (optional) argument 'convert_to_mat' will auto convert this
% this is not the case for .data4 because it has one element which is a string so it is not convertable back

% if we sepecidied this option as false then everything would be cell array

check_that_st_of_arr_are_the_same(test_st_of_arr,out_struct_of_arr)


%% convert a cell array of (possibly unmatching) structures to a structure of 
%  cell arrays or if converable double arrays

% create a a cell arrays of structs for testing
% the structure in a cell will not ness have the same felds as another
test_cell_arr_of_st=cell(2,3);
a=[];
a.data1=4;
a.data2='ma';
a.data3={};
test_cell_arr_of_st{1,1}=a;
a=[];
a.data1=5;
a.data3='t';
test_cell_arr_of_st{1,2}=a;
a=[];
a.data1=6;
a.data2='r';
test_cell_arr_of_st{1,3}=a;
a=[];
a.data1=7;
a.data2='y';
a.data3='e';
test_cell_arr_of_st{2,1}=a;
a=[];
a.data1=8;
a.data3='s';
test_cell_arr_of_st{2,2}=a;
a=[];
a.data1=9;
a.data3='t';
test_cell_arr_of_st{2,3}=a;


out_st_of_arr=cell_array_of_struct_to_struct_of_array(test_cell_arr_of_st)


% the remainder of this section we will test if these are equivelent

field_names=fields(out_st_of_arr);
iimax=numel(field_names);

for ii=1:iimax
    single_field=out_st_of_arr.(field_names{ii});
    jjmax=numel(single_field);
    for jj=1:jjmax
        index_test_cell=cell(1,numel(size(single_field)));
        [index_test_cell{:}]=ind2sub(size(single_field),jj);
        single_element=single_field(index_test_cell{:});
        if iscell(single_element)
            if numel(single_element)==1
                single_element=single_element{1};
            else
                error('if element of output is a cell then it should be singleton')
            end
        end
        % if not nan or empty
        if ~isempty(single_element) && (isnumeric(single_element) && ~isnan(single_element) )
            single_element_in=test_cell_arr_of_st{index_test_cell{:}}.(field_names{ii});  
            if ~isequal(single_element_in,single_element)
                error('not equal')
            end
        end 
    end
end

%% try converting this out_cell_arr_of_struct back to cell_of_struct
out_cell_arr_of_st=struct_of_array_to_cell_array_of_struct(out_st_of_arr)


for ii=1:numel(out_cell_arr_of_st)
    
    st_cback= out_cell_arr_of_st{ii};
    fnames=fieldnames(st_cback);
    empty_logic=structfun(@(x) (isempty(x) || (isnumeric(single_element) && isnan(x))) ,st_cback);
    fnames=fnames(~empty_logic);
    st_orig= test_cell_arr_of_st{ii};
    
    for jj=1:numel(fnames)
        val_cback=st_cback.(fnames{jj});
        val_orig=st_orig.(fnames{jj});
        if ~ isequaln(val_cback,val_orig)
            error('not equal')
        end
    end 
    
end

%% round robbin test 
% run through all the conversions and check what comes out is reasonable

array_dims=[3,4,3];
test_st_of_arr=[];
test_st_of_arr.data1=rand(array_dims);
test_st_of_arr.data2=rand(array_dims);
test_st_of_arr.data2(1,1)=nan;
test_st_of_arr.data3=rand(array_dims)>0.5;
test_st_of_arr.data4=num2cell(rand(array_dims));
test_st_of_arr.data4{1,1}='a';
test_st_of_arr.data5=6;
test_st_of_arr.data6=rand(array_dims(1:2));
test_st_of_arr.data7=rand(array_dims(1),1,array_dims(3));
test_st_of_arr.data8=num2cell(rand(array_dims));


out_cell_arr_of_st=struct_of_array_to_cell_array_of_struct(test_st_of_arr);
out_st_of_arr=cell_array_of_struct_to_struct_of_array(out_cell_arr_of_st,1,1);
out_st_arr=struct_of_array_to_struct_array(out_st_of_arr);
out_st_of_arr=struct_array_to_struct_of_array(out_st_arr,1,1)
check_that_st_of_arr_are_the_same(test_st_of_arr,out_st_of_arr)


%% now we will have a look at deeper structures

array_dims=[3,4,3];
test_st_of_arr=[];
test_st_of_arr.data1.val=rand(array_dims);
test_st_of_arr.data1.unc=rand(array_dims);
test_st_of_arr.data2=rand(array_dims);
test_st_of_arr.data2(1,1)=nan;
test_st_of_arr.data3=rand(array_dims)>0.5;
test_st_of_arr.data4=num2cell(rand(array_dims));
test_st_of_arr.data4{1,1}='a';
test_st_of_arr.data5=6;
test_st_of_arr.data6=rand(array_dims(1:2));
test_st_of_arr.data7=rand(array_dims(1),1,array_dims(3));
test_st_of_arr.data8=num2cell(rand(array_dims));

out_st_of_arr=struct_of_array_to_cell_array_of_struct(test_st_of_arr);

%%
cell_array_of_struct_to_struct_of_array(out_st_of_arr) 

%% 

function check_that_st_of_arr_are_the_same(st_a,st_b)

field_names_a=fields(st_a);
field_names_b=fields(st_b);
if ~isequal(field_names_a,field_names_b)
    error('field names are not the same')
end



for ii=1:numel(field_names_a)
    % field value of what was converted back
    st_field_a= st_a.(field_names_a{ii});
    st_field_b= st_b.(field_names_a{ii});
    if ~isequal(size(st_field_a),size(st_field_b))
        % we need to match the field sizes
        out_match=match_array_sizes({st_field_a,st_field_b},'repmat');
        if ~isequal(out_match{1},out_match{2})
            error('not equal sizes')
        end
    elseif iscell(st_field_b) || iscell(st_field_a)
        % lets see if we get the same after a cell2mat conversion
        convert_count=0;
        try
            if iscell(st_field_b)
                st_field_b=cell2mat(st_field_b);
            end
            convert_count=convert_count+1;
        catch
        end
        try
            if iscell(st_field_a)
                st_field_a=cell2mat(st_field_a);
            end
            convert_count=convert_count+1;
        catch
        end
        
        if ~isequal(st_field_a,st_field_b)
            st_field_a
            st_field_b
            error('not equal, field: %s',field_names_a{ii})
        end
        if convert_count>0
            warning('not strictly equal used cell2mat on parts, field: %s',field_names_a{ii})
        end
    else
        if ~ isequaln(st_field_a,st_field_b)
            st_field_a
            st_field_b
            error('not equal, field: %s',field_names_a{ii})
        end
    end
    
end

end 




%%
% array_dims=[3,4,3];
% rdata1=num2cell(rand(array_dims));
% rdata2=num2cell(rand(array_dims)>0.5);
% test_struct_array=struct('data1',rdata1,'data2',rdata2);
% 
% out_struct_array=struct_array_to_struct_of_array(test_struct_array);
% isequal(cell2mat(rdata1(2,3,2)),test_struct_array(2,3,2).data1,out_struct_array.data1(2,3,2))
% 
% % Convert a structure of array to a struct array
% out_struct_array=struct_of_array_to_struct_array(out_struct_array);
% 
% 
% isequal(test_struct_array,out_struct_array)

