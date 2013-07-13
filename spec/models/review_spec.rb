require 'spec_helper'

describe Review do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:content) }
  it { should ensure_inclusion_of(:rating).in_array((1..5).to_a) }
end