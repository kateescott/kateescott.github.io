module Jekyll
  module ChunkedArrayFilter
    def add_dummy_entry(input)
        input.unshift({ "dummy" => true })
    end

    def chunked_array(input, chunks)
        itemsPerGroup = ceil(input.length/chunks.to_f)
        return input.each_slice(itemsPerGroup).to_a
    end
  end
end

Liquid::Template.register_filter(Jekyll::ChunkedArrayFilter)
