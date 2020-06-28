function st_out=struct_field_paths_elements_build(paths,fields)
% build a structure using the output fromat of of struct_field_paths_elements_flatten
% paths is a cell array of the path of each field
% eg {{'data1','thing1','value1'},
%     {'data2','uncert'}
%     }
% fields is the value of that field
% eg {{[1,2,3,4]},{'abc'}}

% it can be helpfull to manipulate the flattened form then rebuild the struct
% Bryce Henson 2020-06-29

st_out=[];
for ii=1:numel(paths)
    st_out=setfield(st_out,paths{ii}{:},fields{ii});
end


end