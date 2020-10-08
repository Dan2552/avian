class PlatformRenderStore
  def <<(new_element)
    insert_index = store.bsearch_index do |existing_element|
      existing_element.z >= new_element.z
    end

    if insert_index
      store.insert(insert_index, new_element)
    else
      store << new_element
    end

    new_element
  end

  def delete(element)
    # TODO: make it use bsearch_index like insertion

    store.delete(element)
  end

  def each(&blk)
    store.each(&blk)
  end

  private

  def store
    @store ||= []
  end
end
