# AppleHealthParser

The ideal audience of this package is someone who is familiar with the workflow of performing data analytsis through the familiar process. That is accessing the file where the data is stored typically a .CSV then using DataFrames to extract insights through summary statistics, regressions, and charts. Someone in that audience might not be that familiar with how to deal with arcane file types like the XML format preferred by Apple or the DTD syntax which encodes how the data is structured. This package also allows users to navigate "big data" conveniently. With the term "big" referring both to the size of the data in memory and "big" in reference to data that is unstructured and difficult to view.

## Problems

The initial version of this package is incomplete. Processing the data from the XML file to an array of dictionaries is faster than the equivalent process in Python. However converting those dictionaries to a dataframe is much slower which means the "Record" data tags are currently omitted. This hopefully will be fixed later on.





[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sumant-28.github.io/AppleHealthParser.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sumant-28.github.io/AppleHealthParser.jl/dev/)
[![Build Status](https://github.com/sumant-28/AppleHealthParser.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/sumant-28/AppleHealthParser.jl/actions/workflows/CI.yml?query=branch%3Amain)
