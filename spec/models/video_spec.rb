require 'spec_helper'

describe Video do
  it { should have_many(:categories).through(:categorizations) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:description) }
end