def _disable_instance_update!
  allow(described_instance).to receive(:update)
end

def _disable_child_update!
  described_instance.children.each do |child|
    allow(child).to receive(:update)
  end
end

def disable_all_updates_except(except)
  before do
    _disable_instance_update! unless except == :described_instance
    _disable_child_update! unless except == :children
  end
end
