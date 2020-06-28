function out_array=struct_of_array_to_cell_array_of_struct(in_struct)
%https://au.mathworks.com/matlabcentral/fileexchange/40712-convert-from-a-structure-of-arrays-into-an-array-of-structures
% field sizes must match or have size 1 in unmatching dimensions

if numel(in_struct)>1
    error('this should only have one element')
end

% convert the struct into a 2 peices of data
% the field_names and a cell with the value of each field
field_names_in = fieldnames(in_struct);
nfields = numel(field_names_in);
field_cells=struct2cell(in_struct);
field_cells=match_array_sizes(field_cells,'repmat');
% we need to change how the the elements are adressed if they come from a cell array
is_field_cell_array=cellfun(@(x) iscell(x),field_cells);

cell_sizes=size(field_cells{1});
ind_max=prod(cell_sizes);

out_array=cell(cell_sizes);
element_template=cell2struct(cell(nfields,1),field_names_in);

sub_tmp=cell([1,numel(cell_sizes)]);
for ii=1:ind_max
        element_tmp=element_template;
        [sub_tmp{:}]=ind2sub(cell_sizes,ii);
        for jj=1:nfields
            array_tmp=field_cells{jj};
            val_tmp=array_tmp(sub_tmp{:});
            if is_field_cell_array(jj) %if come from cell array the output will be a single element cell array
                if numel(val_tmp)>1
                    error('runtime error, cell array query returned more than signle element cell array')
                end
                val_tmp=val_tmp{1};
            end
            element_tmp.(field_names_in{jj})=val_tmp;
        end
        out_array{sub_tmp{:}}=element_tmp;
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