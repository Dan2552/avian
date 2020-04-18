class String
  def titlecase
    chars(downcase.to_s.gsub(/\b('?\S)/u) { Unicode.upcase($1) })
  end
end
