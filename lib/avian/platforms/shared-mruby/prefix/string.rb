class String
  def titlecase
    downcase.gsub("_", " ").split(/(\W)/).map(&:capitalize).join
  end

  def underscore
    gsub(/([^A-Z])([A-Z]+)/, '\1_\2').downcase
  end

  def singularize
    return sub(/children$/, 'child') if end_with?("children") # e.g. grandchildren -> grandchild
    return sub(/es$/, '') if end_with?("hes") # e.g. torches -> torch
    sub(/s$/, '')
  end

  def pluralize
    return sub(/$/, 'ren') if end_with?("child") # e.g. grandchild -> grandchildren
    return sub(/$/, 'es') if end_with?("h") # e.g. torch -> torches
    sub(/$/, 's')
  end

  def demodulize
    split("::").last
  end
end
