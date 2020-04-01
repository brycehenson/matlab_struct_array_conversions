# Matlab Structure Tensor Conversions
**[Bryce M. Henson](https://github.com/brycehenson)**  
convert between the various ways tensors(arb. dim. arrays) can be stored in (or interact with) structures  
**Status:** This Code is **NOT ready for use in other projects**. Unit Testing is **crudely** implemented for functions. Integration/system testing is **not** implemented.

| ![diagram of the conversion between struct-tensor types](/figs/figs/diagram.png "Fig1") | 
|:--:| 
 **Figure 1**- Schematic of the different storage types and how the conversion maps elements.|

## Motivation
matlab has 3 distinct way you can store tensors(arb. dim. arrays) in structures.
- ***(A)*** structure with tensor(arrays) in each field (aka. struct of tensors)
  - I think this is the easiest to work with
  - it does not enforce dimension matching things can go wrong if you not carefull about building/ modifying each field
  - acess and creation is the simplest
- ***(B)*** Cell tensor(array) of structures
  - this is the most flexible as the cell in each tensor can have completely different fields
  - it is very difficult to query as you must handle the possibly different fields present
- ***(C)*** structure tensor(array) 
  - this can be hard to build as it is pretty difficult to set multiple values at the same time.
  - all querys come as 

Each has their own advantages, fustration and quirks. Conventions (including in matlab) vary and we would like a way to convert between these formats.

## Code
This package provides conversions ***(A)*** <-> ***(B)*** and ***(A)*** <-> ***(C)***
- (***(B)*** -> ***(A)***) cell_tensor_of_struct_to_struct_of_tensor
- (***(A)*** -> ***(B)***) struct_of_tensor_to_cell_tensor_of_struct

- (***(C)*** -> ***(A)***) struct_tensor_to_struct_of_tensor
- (***(A)*** -> ***(C)***)  struct_of_tensor_to_struct_tensor

It also provides match_tensor_sizes sizes which is used in struct_of_tensor_to_cell_tensor_of_struct to repeat a smaller tensor along its singleton dimensions to match a larger tensor.

## TODO
- [ ] full test script including error cases
  - [ ] roundrobin tests
- [ ] option in struct_of_tensor_to_cell_tensor_of_struct to use nan instead of repeating along singleton dim.
- [ ] better speed bencmarking
- [ ] standard funciton headers including examples
- [ ] pretty picture to represent conversions
- [ ] add to fileExchange






