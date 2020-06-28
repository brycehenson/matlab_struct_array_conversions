function cell_of_arrays=match_array_sizes(cell_of_arrays,method)
% matches size of arrays by repeating singleton elements
% dim sizes must match or have size 1 in unmatching dimensions

if ~strcmp(method,'repmat')
    error('not yet implemented')
end

if ~isvector(cell_of_arrays)
    error('input is not vector of cells')
end

narrays = numel(cell_of_arrays);
% make a matrix of the dimensionality
field_size=cell(1,narrays);
for ii=1:narrays
    this_array = cell_of_arrays{ii};
    field_size(ii)={size(this_array)};
end
% build a matrix of the field sizes so we can see if they match or are 1
field_dimension=cellfun(@numel,field_size);
max_dimension=max(field_dimension);
array_size_mat=ones(narrays,max_dimension);
for ii=1:narrays
    array_size_mat(ii,1:field_dimension(ii))=field_size{ii};
end

biger_dimension_size=nan(1,max_dimension);
for ii=1:max_dimension
    tmp_sizes=unique(array_size_mat(:,ii));
    tmp_sizes(tmp_sizes==1)=[];
    if numel(tmp_sizes)>1 
        error('dimension %u of the arrays cannot be matched',ii)
    end
    biger_dimension_size(ii)=tmp_sizes;
end
%biger_dimension_size

for ii=1:narrays
    this_array = cell_of_arrays{ii};
    field_size_tmp=size(this_array);
    if numel(field_size_tmp)~=max_dimension
        % pad up field_size_tmp
        field_size_tmp=cat(2,field_size_tmp,ones(1,max_dimension-numel(field_size_tmp)));
    end
    if ~isequal(field_size_tmp,biger_dimension_size)
        matching_mask=field_size_tmp==biger_dimension_size;
        repeats=ones(1,max_dimension);
        repeats(~matching_mask)=biger_dimension_size(~matching_mask);
        this_array=repmat(this_array,repeats);
        cell_of_arrays{ii}=this_array;
    end
end


end