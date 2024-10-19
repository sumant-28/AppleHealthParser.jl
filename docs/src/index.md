```@meta
CurrentModule = AppleHealthParser
```

# AppleHealthParser

Documentation for [AppleHealthParser](https://github.com/sumant-28/AppleHealthParser.jl). 

This will be added to in later versions. The main functions to pay attention to are `basic_export` and `enhanced_metadata`.
The former will export the data sans child elements to .CSV files because the data is reliably fixed width. With unstructured
metadata of variable lines the conversion to tabular data of fixed width is no longer as simple. Therefore the data is left as 
vectors of dictionaries separated by parent tag names.

```@index
```


