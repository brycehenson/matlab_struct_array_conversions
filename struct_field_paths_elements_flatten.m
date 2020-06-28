function [paths_out,fields]=struct_field_paths_elements_flatten(st_in,paths_out,fields)
% flatten a structure into the paths and the elements
% a=[];
% a.b.c.d.e=1;
% a.b.c.d.f=a;
% a.b.c.g='test1';
% a.b.h=pi;
% will return
% {{{'b'},{'c'},{'d'},{'e'}},
%  {{'b'},{'c'},{'d'},{'f'}},
%  {{'b'},{'c'},{'g'}},
%  {{'b'},{'h'}},
%  }

% i have found this is helpfull when trying to operate on strucuctures
% Bryce Henson 2020-06-29


if nargin<2
    paths_out={};
    fields={};
end


fnames=fieldnames(st_in);
for ii=1:numel(fnames)
    is_element_st=isstruct(getfield(st_in,fnames{ii}));
    if is_element_st
        elem_tmp=getfield(st_in,fnames{ii});
        [paths_tmp,fields_tmp]=struct_field_paths_elements_flatten(elem_tmp);
        paths_tmp=cellfun(@(x) cat(2,fnames{ii},x),paths_tmp,'UniformOutput',false);
        paths_out=cat(1,paths_out,paths_tmp);
        fields=cat(1,fields,fields_tmp);
    else
        paths_out=cat(1,paths_out,{{ fnames{ii} }});
        fields=cat(1,fields,{ getfield(st_in,fnames{ii}) }  );
    end
end




end