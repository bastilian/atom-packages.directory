require 'spec_helper'
require 'models/package'

describe Package do
  subject { Package.create(name: 'test') }

  it "exists" do
    puts subject.inspect
    expect(subject.class).to eq(Package)
  end
end
