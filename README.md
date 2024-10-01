# AppleHealthParser

## Introduction

There are estimated to be hundreds of millions of people who own an Apple Watch. All of those individual product owners have thousands of data records collected natively on the hardware per week and potentially more in Apple Health from various APIs to connected accounts. After a few years the author has over five million records in the export.xml file that Apple allows users to download.

## Motivation

Getting the data out of the Apple Health source file to perform statistical analysis on is not without difficulty. This perhaps explains a gap the author has noticed in how-to guides. It is always possible to explore the data structure and select what is needed interactively however automating the process in a software package is not something that has been done in this way yet. The structure of the export file is specified in the DTD syntax at the head of the file. If Apple decides to structure the download differently in the future this package will fail however after observing a few other successful attempts to process this file they are all structured the same way.

## Existing Approaches

There are existing analyses online to process the data in [R](https://rpubs.com/heidithornton09/AccessingAppleHealthData), [Python](https://github.com/jameno/Simple-Apple-Health-XML-to-CSV) and with a [database](https://github.com/christophhagen/HealthDB). There may be others.

### Parser

Of these implementations one problem that can be run into is that with the file being so big it is slow to load the entire XML tree or all of the nodes corresponding to the main tag ("Record") because it exceeds the memory of the computer. The faster way is with an XML parser that parses elements individually rather than loading the entire document at once. 

### Output

A database is likely to be the best option to convert the xml file to something useful for statistical analysis. However that setup might be too much hassle for someone who wants to do quick summary statistics and does not have an extensive data engineering background. To convert the xml file into a dataframe which is the preferred data type for analysis there are two approaches. One is with a flat table and the other separating the data into three dataframes by the main tags ("Record", "Workout", "ActivitySummary"). Because of how Apple structures the data there are duplicate headers for the same data type with one big table resulting in a sparse matrix. This combined with the large data size makes the author prefer splitting the output into three dataframes.

## Problems

The initial version of this package is incomplete. Processing the data from the XML file to an array of dictionaries is faster than the equivalent process in Python. However converting those dictionaries to a dataframe is much slower which means the "Record" data tags are currently omitted. This hopefully will be fixed later on.





[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sumant-28.github.io/AppleHealthParser.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sumant-28.github.io/AppleHealthParser.jl/dev/)
[![Build Status](https://github.com/sumant-28/AppleHealthParser.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/sumant-28/AppleHealthParser.jl/actions/workflows/CI.yml?query=branch%3Amain)
