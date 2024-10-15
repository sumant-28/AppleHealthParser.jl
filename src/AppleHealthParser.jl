"""
Module for parsing Apple Health files.
"""
module AppleHealthParser

using XML
using DataFrames
using OrderedCollections
using StatsBase
using CSV

"""
This function returns two outputs. The first are the indices of child elements from the 
file which can be removed. The second output is the collection of indices which are parent elements
for which child elements can be appended to the extracted dictionary.
"""
function return_child_elements_i(element_tags, element_attributes, element_children)
    child_element_indices = trues(length(element_tags))
    list_of_i = []
    let
        i = findnext(!=(LazyNode[]), element_children, 4)
        while i <= length(element_tags)
            push!(list_of_i,i)
            j = 1
            tagvector = unique([tag(x) for x in element_children[i]])
            while (length(element_tags) >= i + j) & (element_tags[i + j] in tagvector)
                if length(element_children[i + j]) > 0
                    newtags = unique([tag(x) for x in element_children[i + j]])
                    tagvector = vcat(tagvector, newtags)
                end
                j += 1
                if i + j >= length(element_tags)
                    child_element_indices[i + j] = false
                    break
                end
            end
            indices = i+1:i+j - 1
            child_element_indices[indices] .= false
            if findnext(!=(LazyNode[]), element_children, i + j) == nothing
                break
            else
                i = findnext(!=(LazyNode[]), element_children, i + j)
            end
        end
    end
    return child_element_indices, list_of_i
end

"""
This function takes a dictionary with nested vectors containing child elements and flattens
the data resulting in a dictionary that only has keys and values.
"""
function flatten_dictionaries(d)
    emptied = Dict()
    new_d = empty(d)
    for (key, value) in pairs(d)
        if isa(value, Vector)
            for i in 1:length(d[key])
                if typeof(d[key][i]) != String
                    myseed = values(collect(d[key][i]))[1][1]
                    if myseed in keys(emptied)
                        emptied[myseed] += 1
                    else
                        emptied[myseed] = 1
                    end
                    counter = emptied[myseed]
                    mykeyset = collect(keys(values(collect(d[key][i]))[1][2]))
                    myvalues = collect(values(collect(d[key][i])[1][2]))
                    for j in 1:length(myvalues)
                        keystring = myseed * string(counter) * String(mykeyset[j])
                        new_d[keystring] = myvalues[j]
                    end
                end
            end
        else
            new_d[key] = value
        end
    end
    return new_d
end

"""
This function takes the vector of element attributes extracted using the XML parser and
modifies it in place so that the parent elements are dictionaries containing keys and values
from all the nested child elements appended as vectors.
"""
function attribute_meta(previous_children, element_tags, element_attributes, element_children)
    somethingnew = []
    for i in previous_children #my_children[2]
        j = 1
        tag_vector = unique([tag(x) for x in element_children[i]])
        child_vector = []
        while (length(element_tags) >= i + j) & (element_tags[i + j] in tag_vector)
            if element_attributes[i + j] != nothing
                push!(child_vector, Dict(element_tags[i + j] => element_attributes[i + j]))
            end
            if length(element_children[i + j]) > 0
                newtagz = unique([tag(x) for x in element_children[i + j]])
                tag_vector = vcat(tag_vector, newtagz)
            end
            j += 1
            if i + j >= length(element_tags)
                j += 1
                break
            end
        end
        ogk = collect(keys(element_attributes[i]))
        push!(ogk,"")
        ogv = vcat(collect(values(element_attributes[i])),[child_vector])
        push!(somethingnew,OrderedDict(zip(ogk,ogv)))
        element_attributes[i] = flatten_dictionaries(OrderedDict(zip(ogk,ogv)))
    end
    element_attributes
end

"""
This function returns the child element indices of the element attributes vector.
"""
function return_child_elements(element_tags, element_attributes, element_children)
    child_element_indices = trues(length(element_tags))
    let
        i = findnext(!=(LazyNode[]), element_children, 4)
        while i <= length(element_tags)
            j = 1
            tagvector = unique([tag(x) for x in element_children[i]])
            while (length(element_tags) >= i + j) & (element_tags[i + j] in tagvector)
                if length(element_children[i + j]) > 0
                    newtags = unique([tag(x) for x in element_children[i + j]])
                    tagvector = vcat(tagvector, newtags)
                end
                j += 1
                if i + j >= length(element_tags)
                    child_element_indices[i + j] = false
                    break
                end
            end
            indices = i+1:i+j - 1
            child_element_indices[indices] .= false
            if findnext(!=(LazyNode[]), element_children, i + j) == nothing
                break
            else
                i = findnext(!=(LazyNode[]), element_children, i + j)
            end
        end
    end
    return child_element_indices
end

"""
This function takes the element tags, element attributes and names of parent nodes and generates a csv file
for each parent node name.
"""
function generate_csv(element_tags, element_attributes, names)
    for name in names
        indices = findall(.==(name), element_tags)
        dictionaries = element_attributes[indices]
        df = vcat(DataFrame.(dictionaries)...,cols=:union)
        filename = name * ".csv"
        CSV.write(filename, df)
    end
end

"""
This function takes the original XML file downloaded from Apple and converts the data into separate CSV files
according to the procedure outlined in the documentation.
"""
function basic_export(file)
    o = read(file, LazyNode)
    element_tags = [tag(x) for x in o]
    element_attributes = [attributes(x) for x in o]
    element_children = [children(x) for x in o]
    print("Finished importing files\n")
    child_index = return_child_elements(element_tags, element_attributes, element_children)
    print("Finished processing data\n")
    reduced_tags = countmap(element_tags[child_index])
    file_dictionary = filter(p -> (100000 > last(p) > 5), reduced_tags)
    file_names = collect(keys(file_dictionary))
    generate_csv(element_tags,element_attributes,file_names)
    print("Done\n")
end

"""
This function takes the original XML file downloaded from Apple and creates separate collections of dictionaries
for each parent node. The metadata is preserved as key value pairs appended to the original dictionaries.
"""
function enhanced_metadata(file)
    o = read(file,LazyNode)
    element_tags = [tag(x) for x in o]
    element_attributes = [attributes(x) for x in o]
    element_children = [children(x) for x in o]
    print("Finished importing files\n")
    my_indices, my_children = return_child_elements_i(element_tags, element_attributes, element_children)
    final_attributes = attribute_meta(my_children, element_tags, element_attributes, element_children)
    reduced_tags = countmap(element_tags[my_children])
    file_dictionary = filter(p -> (100000 > last(p) > 5), reduced_tags)
    names = collect(keys(file_dictionary))
    print(names)
    dictionaries = []
    for name in names
        indices = findall(.==(name), element_tags)
        dictionary = element_attributes[my_indices]
        push!(dictionaries, dictionary)
    end
    return dictionaries
end

export flatten_dictionaries, basic_export, enhanced_metadata

end
