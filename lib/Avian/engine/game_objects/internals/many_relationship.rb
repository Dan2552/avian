class ManyRelationship
  # - parameter parent: an instance of the parent class
  # - paremeter subject_class: the expected type of children
  #
  def initialize(parent, subject_class)
    @parent = parent
    @subject_class = subject_class
  end

  def count
    collection.count
  end

  def <<(element)
    unless element.is_a? subject_class
      raise "#{element} is not a #{subject_class}"
    end

    element.instance_variable_set(:"@#{parent.class.foreign_relationship_name}", parent)

    collection << element
  end

  def first
    collection.first
  end

  def each(*args, &blk)
    collection.each(*args, &blk)
  end

  def map(*args, &blk)
    collection.map(*args, &blk)
  end

  def include?(*args)
    collection.include?(*args)
  end

  def delete(*args)
    collection.delete(*args)
  end

  def to_a
    collection.dup
  end

  def [](*args)
    collection[*args]
  end

  def find(id)
    collection.each do |object|
      return object if object.id == id
    end
    nil
  end

  def select(*args, &blk)
    collection.select(*args, &blk)
  end

  private

  attr_reader :parent,
              :subject_class

  def collection
    @collection ||= []
  end
end
