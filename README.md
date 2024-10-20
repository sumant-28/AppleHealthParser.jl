# AppleHealthParser

The ideal audience for this package is someone who is familiar with the workflow of a typical data analysis project. That includes accessing the file where the data is stored typically in a .csv, converting it to DataFrame(s), then extracting insights through summary statistics, regressions, and charts. Someone in that audience might not be familiar with how to deal with arcane file types like the .xml format used by Apple or the DTD syntax which encodes how the data is structured. This package also allows users to navigate "big data" conveniently. With the term "big" referring both to the size of the data in memory and "big" in reference to data that is unstructured and difficult to view.

## Problems

The initial version of this package is incomplete. Processing the data from the XML file to an array of dictionaries is faster than the equivalent process in Python. However converting those dictionaries to a dataframe is much slower which means the "Record" data tags are currently omitted. This hopefully will be fixed later on.





[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sumant-28.github.io/AppleHealthParser.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sumant-28.github.io/AppleHealthParser.jl/dev/)
[![Build Status](https://github.com/sumant-28/AppleHealthParser.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/sumant-28/AppleHealthParser.jl/actions/workflows/CI.yml?query=branch%3Amain)
