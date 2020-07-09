function out_struct=cell_array_of_struct_to_struct_of_array(array_of_struct,convert_to_num_arr,convert_single_cell_arr,verbose)
% convert a cell array of structures to a structure of (nd)arrays 
% the arrays in the structure will be empty if the coresponding location in the origianl cell array is empty
% this function can handle full nested strucutes
% Bryce Henson 2020-06-29


%https://au.mathworks.com/matlabcentral/fileexchange/40712-convert-from-a-structure-of-arrays-into-an-array-of-structures
% field sizes must singletons
% if any fields are missing will replace with nan
if nargin<2 || isempty(convert_to_num_arr)
    convert_to_num_arr=true;
end
if nargin<3 || isempty(convert_single_cell_arr)
    convert_single_cell_arr=true;
end
if nargin<4 || isempty(verbose)
    verbose=1;
end



out_field_paths= cell(0,1);%fieldnames(out_struct);
out_field_vals= cell(0,1);%fieldnames(out_struct);
size_tensor=size(array_of_struct);
field_val_tmp=cell(size_tensor);
sub_tmp=cell([1,numel(size_tensor)]); %array index initalization
ind_max=prod(size_tensor);

for ii=1:ind_max
    [sub_tmp{:}]=ind2sub(size_tensor,ii);
    element_struct_tmp=array_of_struct{sub_tmp{:}};
    [field_paths,field_vals]=struct_field_paths_elements_flatten(element_struct_tmp);
    for jj=1:numel(field_paths)
        field_paths_match=cellfun(@(x) isequal(x,field_paths{jj}),out_field_paths);
        % check that there are not more than 1 match
        if sum(any(field_paths_match))>1
            error('error there should not be more than 1 match')
        end
        % see if this path already exists
        if ~any(field_paths_match)
            % create this field
            out_field_paths=cat(1,out_field_paths,{field_paths{jj}});
            out_field_vals=cat(1,out_field_vals,{field_val_tmp});
            field_paths_match(numel(field_paths_match)+1)=true; % it will now match the last value
        end
        % now set the corresponding value in the structure flattenend variable
        out_field_vals{field_paths_match}{sub_tmp{:}}=field_vals{jj};
    end
end


% try to convert the cell array into a numerical array
if convert_to_num_arr
    for ii=1:numel(out_field_paths)
        try
            element_tmp=out_field_vals{ii};
            empty_mask=cellfun(@isempty,element_tmp);
            element_tmp(empty_mask)=repmat({NaN},[sum(empty_mask(:)),1]);
            element_tmp=cell2mat(element_tmp);
            out_field_vals{ii}=element_tmp;
        catch
            tmp_path=out_field_paths{ii};
            if verbose>0
                fprintf('cant convert field %s to double\n',strjoin(tmp_path(:),','))
            end
        end
    end
end

% un nest cell array
if convert_single_cell_arr
    if ~convert_to_num_arr
        error('must also select convert_to_num_arr')
    end
    for ii=1:numel(out_field_paths)
            element_tmp=out_field_vals{ii};
            if iscell(element_tmp)
                element_tmp=un_nest_cell_array(element_tmp);
                out_field_vals{ii}=element_tmp;
            end
    end
end


out_struct=struct_field_paths_elements_build(out_field_paths,out_field_vals);

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


