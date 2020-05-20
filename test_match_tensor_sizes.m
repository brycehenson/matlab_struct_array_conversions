a=[];
tensor_dims=[3,4,3,2];
a{1}=rand(tensor_dims);
a{2}=rand(tensor_dims);
a{3}=rand(tensor_dims)>0.5;
a{4}=num2cell(rand(tensor_dims));
a{5}=6;
a{6}=rand(tensor_dims(1:2));
a{7}=rand(tensor_dims(1),1,tensor_dims(3));
a
out_cell=match_tensor_sizes(a,'repmat')


%%
out_cell=match_tensor_sizes({1,[2,3,4],[5,6,7]},'repmat')

%%
[a,b,c]=match_tensor_sizes_multi_in(1,[2,3,4],[5,6,7])