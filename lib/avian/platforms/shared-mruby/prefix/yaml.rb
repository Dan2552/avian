module YAML
  def self.load_file(path)
    path = path.to_s.gsub(/\.ya?ml$/, ".json")
    file_contents = File.read(path)
    JSON.parse(file_contents)
  end
end
