require 'spec_helper'
require 'cancan/matchers'

describe "User" do
  describe "abilities" do
    subject { ability }
    let(:ability) { Ability.new(user) }

    context "when is an admin" do
      let(:user)    { Fabricate(:user, role: 'admin') }
      let(:picker)  { Fabricate.build(:user, role: 'picker') }
      let(:tracked) { Fabricate.build(:tracked_word) }

      it { should be_able_to(:read, picker) }
      it { should_not be_able_to(:create, picker) }
      it { should_not be_able_to(:update, picker) }
      it { should_not be_able_to(:destroy, picker) }

      it { should be_able_to(:read, tracked) }
      it { should be_able_to(:destroy, tracked) }
      it { should_not be_able_to(:create, tracked) }
      it { should_not be_able_to(:update, tracked) }

      it { should_not be_able_to(:manage, Fabricate.build(:picked_word)) }
    end

    context "when is a user" do
      let(:user)   { Fabricate(:user, role: 'picker') }
      let(:picked) { Fabricate(:picked_word, user: user) }

      it { should be_able_to(:manage, user) }
      it { should_not be_able_to(:manage, Fabricate.build(:user)) }

      it { should be_able_to(:manage, picked) }
      it { should_not be_able_to(:manage, Fabricate.build(:picked_word)) }

      it { should be_able_to(:translate, :word) }

      it { should_not be_able_to(:manage, Fabricate.build(:tracked_word)) }
    end
  end
end
