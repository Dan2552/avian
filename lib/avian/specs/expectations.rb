def it_has_an_accessor(name, type = String)
  name = name.to_s
  it "has a #{name} accessor" do
    value = "test" if type == String
    value = 25 if type == Integer || type == Numeric
    value = true if type == Boolean
    value = Vector[1, 1] if type == Vector

    described_instance.send("#{name}=", value)
    expect(described_instance.send(name)).to eq(value)
  end
end

def it_has_an_attribute(name, example_value:)
  name = name.to_s
  it "has a #{name} attribute" do
    value = example_value
    described_instance.send("#{name}=", value)
    expect(described_instance.send(name)).to eq(value)
  end
end

def it_has_a_reader(name)
  name = name.to_s
  it "has a #{name} reader" do
    described_instance.instance_variable_set(:"@#{name}", "test")
    expect(described_instance.send(name)).to eq("test")
  end
end

def it_has_a_vector(name)
  name = name.to_s
  it "has a #{name} Vector" do
    vector = described_instance.send(name)
    expect(vector).to be_a(Vector) if vector

    described_instance.send("#{name}=", Vector[5, 2])

    vector = described_instance.send(name)
    expect(vector.x).to eq(5)
    expect(vector.y).to eq(2)
  end
end
