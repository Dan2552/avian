class String
  def titlecase
    downcase.gsub("_", " ").split(/(\W)/).map(&:capitalize).join
  end

  def underscore
    gsub(/([^A-Z])([A-Z]+)/, '\1_\2').downcase
  end

  def singularize
    sub(/s$/, '')
  end

  def pluralize
    sub(/$/, 's')
  end

  def demodulize
    split("::").last
  end
end
