%test_struct_field_paths_elements_flattened

a=[];
a.b.c.d.e=[1,5,9];
a.b.c.d.f=5464356;
a.b.c.g='test1';
a.b.h=pi;
a.i={'a','b'};

[paths,fields]=struct_field_paths_elements_flatten(a)


% and test that we can rebuild it from this flattened form
%%

b=struct_field_paths_elements_build(paths,fields)

isequal(a,b)