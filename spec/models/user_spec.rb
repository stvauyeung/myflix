require 'spec_helper'

describe User do
  it { should validate_presence_of(:name)}

  it { should validate_presence_of(:email)}
  it { should validate_uniqueness_of(:email)}
  it { should_not allow_value("jaol").for(:email)}
  it { should allow_value("j@aol.com").for(:email)}

  it { should validate_presence_of(:password_digest) }
end