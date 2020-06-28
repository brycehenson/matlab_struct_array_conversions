# Matlab Structure (nd)Array Conversions
**[Bryce M. Henson](https://github.com/brycehenson)**  
convert between the various ways n-dimensional arrays (sometimes called tensors) can be stored in (or interact with) structures  
**Status:** This Code is **ready** for use in other projects. Unit Testing is implemented. Round-Robin testing is implemented and **passing**.

| ![diagram of the conversion between struct-tensor types](/figs/diagram.png "Fig1") | 
|:--:| 
 **Figure 1**- Schematic of the different storage types and how the conversion maps elements.|

## Motivation
matlab has 3 distinct way you can store n-dimensional arrays (aka tensors, multidimendional arrays, or nd-array) in structures.
- ***(A)*** structure with an nd-array in each field (aka. struct of tensors) (fig.1 right)
  - I think this is the easiest to work with
  - it does not enforce dimension matching things can go wrong if you not carefull about building/ modifying each field
  - acess and creation is the simplest
- ***(B)*** Cell nd-array of structures (fig.1 top left)
  - this is the most flexible as the cell in each nd-array can have completely different fields
  - it is very difficult to query as you must handle the possibly different fields present
- ***(C)*** structure nd-array(tensor) (fig.1 bottom left)
  - this can be hard to build as it is pretty difficult to set multiple values at the same time.
  - the reult of queries do not preserve dimensionality eg ```test_struct_array(1,1:2,1:3).data1```

Each has their own advantages, fustration and quirks. Conventions (including in matlab) vary and we would like a way to convert between these formats.

## Code
This package provides conversions ***(A)*** <-> ***(B)*** and ***(A)*** <-> ***(C)***
- (***(B)*** -> ***(A)***) cell_array_of_struct_to_struct_of_array
- (***(A)*** -> ***(B)***) struct_of_array_to_cell_array_of_struct

- (***(C)*** -> ***(A)***) struct_array_to_struct_of_array
- (***(A)*** -> ***(C)***)  struct_of_array_to_struct_array

It also provides match_tensor_sizes sizes which is used in struct_of_tensor_to_cell_tensor_of_struct to repeat a smaller tensor along its singleton dimensions to match a larger tensor.

## caveats


## TODO
- [ ] full test script including error cases
  - [ ] roundrobin tests
- [ ] option in struct_of_tensor_to_cell_tensor_of_struct to use nan instead of repeating along singleton dim.
- [ ] better speed bencmarking
- [ ] standard funciton headers including examples
- [x] pretty picture to represent conversions
- [ ] add to fileExchange






