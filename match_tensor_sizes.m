function cell_of_tensors=match_tensor_sizes(cell_of_tensors,method)
% matches size of tensors by repeating singleton elements
% dim sizes must match or have size 1 in unmatching dimensions

if ~strcmp(method,'repmat')
    error('not yet implemented')
end

if ~isvector(cell_of_tensors)
    error('input is not vector of cells')
end

ntensors = numel(cell_of_tensors);
% make a matrix of the dimensionality
field_size=cell(1,ntensors);
for ii=1:ntensors
    this_tensor = cell_of_tensors{ii};
    field_size(ii)={size(this_tensor)};
end
% build a matrix of the field sizes so we can see if they match or are 1
field_dimension=cellfun(@numel,field_size);
max_dimension=max(field_dimension);
tensor_size_mat=ones(ntensors,max_dimension);
for ii=1:ntensors
    tensor_size_mat(ii,1:field_dimension(ii))=field_size{ii};
end

biger_dimension_size=nan(1,max_dimension);
for ii=1:max_dimension
    tmp_sizes=unique(tensor_size_mat(:,ii));
    tmp_sizes(tmp_sizes==1)=[];
    if numel(tmp_sizes)>1 
        error('dimension %u of the tensors cannot be matched',ii)
    end
    biger_dimension_size(ii)=tmp_sizes;
end
%biger_dimension_size

for ii=1:ntensors
    this_tensor = cell_of_tensors{ii};
    field_size_tmp=size(this_tensor);
    if numel(field_size_tmp)~=max_dimension
        % pad up field_size_tmp
        field_size_tmp=cat(2,field_size_tmp,ones(1,max_dimension-numel(field_size_tmp)));
    end
    if ~isequal(field_size_tmp,biger_dimension_size)
        matching_mask=field_size_tmp==biger_dimension_size;
        repeats=ones(1,max_dimension);
        repeats(~matching_mask)=biger_dimension_size(~matching_mask);
        this_tensor=repmat(this_tensor,repeats);
        cell_of_tensors{ii}=this_tensor;
    end
end


end