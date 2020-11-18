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

  def delete(element_to_delete)
    deletion_index = store.bsearch_index do |element|
      element.z >= element_to_delete.z
    end

    loop do
      # we've found it
      break if store[deletion_index] == element_to_delete

      # it's not in here
      if store[deletion_index].nil? || store[deletion_index].z != element_to_delete.z
        deletion_index = nil
        break
      end

      deletion_index = deletion_index + 1
    end

    return if deletion_index.nil?

    store.delete_at(deletion_index)
  end

  def each(&blk)
    store.each(&blk)
  end

  private

  def store
    @store ||= []
  end
end
