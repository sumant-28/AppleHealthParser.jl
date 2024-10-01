module AppleHealthParser

using XML
using DataFrames
using OrderedCollections
using StatsBase
using CSV
using Revise

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

function generate_csv(element_tags, element_attributes, names)
    for name in names
        indices = findall(.==(name), element_tags)
        dictionaries = element_attributes[indices]
        df = vcat(DataFrame.(dictionaries)...,cols=:union)
        filename = name * ".csv"
        CSV.write(filename, df)
    end
end

function main()
    file = "export.xml"
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

end
