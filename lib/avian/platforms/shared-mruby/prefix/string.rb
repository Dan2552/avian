class String
  def titlecase
    downcase.gsub("_", " ").split(/(\W)/).map(&:capitalize).join
  end

  def underscore
    gsub(/([^A-Z])([A-Z]+)/, '\1_\2').downcase
  end

  def singularize
    return sub(/es$/, '') if end_with?("hes") # e.g. torch
    sub(/s$/, '')
  end

  def pluralize
    return sub(/$/, 'es') if end_with?("h") # e.g. torch
    sub(/$/, 's')
  end

  def demodulize
    split("::").last
  end
end
