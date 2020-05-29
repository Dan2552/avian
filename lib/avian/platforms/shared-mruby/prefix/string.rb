class String
  def titlecase
    downcase.to_s.gsub("_", " ").split(/(\W)/).map(&:capitalize).join
  end

  def singularize
    sub(/s$/, '')
  end

  def pluralize
    sub(/$/, 's')
  end
end
