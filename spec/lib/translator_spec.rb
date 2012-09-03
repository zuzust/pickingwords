require 'spec_helper'

describe Translator do

  describe "translate" do
    let(:args) {{ name: "word", from: "en", to: "ca", ctxt: "" }}
    let(:ctxt) { "this is a word in English" }
    let(:l10n) {{ name: "paraula", ctxt: "aquesta es una paraula en angles" }}

    it "should search for a matching tracked word" do
      Translator.stub(:get_translation).and_return([l10n[:name], 0])
      TrackedWord.should_receive(:search).with(args[:name], args[:from])
      Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])
    end

    describe "existent tracked word" do
      before(:each) { @tracked = TrackedWord.new.localize(args[:from], args[:name]) }

      context "already localized" do
        before(:each) do
          @tracked.localize(args[:to], l10n[:name])
          TrackedWord.stub(:search).and_return(@tracked)
        end

        it "should not call translation service for word translation" do
          Translator.should_not_receive(:get_translation).with(args[:name], args[:from], args[:to])
          Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])
        end
      end

      context "not localized yet" do
        before(:each) { TrackedWord.stub(:search).and_return(@tracked) }

        it "should call translation service for word translation" do
          Translator.should_receive(:get_translation).with(args[:name], args[:from], args[:to]).and_return([l10n[:name],args[:name].length])
          Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])
        end

        it "should localize it to translation lang" do
          Translator.stub(:get_translation).and_return([l10n[:name], args[:name].length])
          expect {
            Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])
          }.to change { @tracked.translate(args[:to]) }.from(nil).to(l10n[:name])
        end
      end
    end

    describe "nonexisting tracked word" do
      before(:each) { TrackedWord.stub(:search).and_return(nil) }

      it "should call translation service for word translation" do
        Translator.should_receive(:get_translation).with(args[:name], args[:from], args[:to]).and_return([l10n[:name],args[:name].length])
        Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])
      end

      describe "after valid translation" do
        before(:each) { Translator.stub(:get_translation).and_return([l10n[:name],args[:name].length]) }

        it "should create a new tracked word" do
          expect {
            Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])
          }.to change(TrackedWord, :count).by(1)
        end

        it "should localize the new tracked word to origin and destination langs" do
          pickable, trans_chars = Translator.translate(args[:name], args[:from], args[:to], args[:ctxt])

          pickable.tracked.translate(args[:from]).should == args[:name]
          pickable.tracked.translate(args[:to]).should == l10n[:name]
        end
      end
    end

    describe "given word context" do
      let(:tracked) { TrackedWord.new.localize(args[:from], args[:name]).localize(args[:to], l10n[:name]) }
      before(:each) { Translator.stub(:track_translation).and_return([tracked,0]) }

      it "should call translation service for context translation" do
        Translator.should_receive(:get_translation).with(ctxt, args[:from], args[:to]).and_return([l10n[:ctxt],ctxt.length])
        Translator.translate(args[:name], args[:from], args[:to], ctxt)
      end
    end

    it "should build a new picked word filled with translations" do
      Translator.stub(:get_translation).and_return([l10n[:name],0], [l10n[:ctxt],ctxt.length])
      pickable, trans_chars = Translator.translate(args[:name], args[:from], args[:to], ctxt)

      pickable.translation.should == l10n[:name]
      pickable.contexts.first.translation.should == l10n[:ctxt]
    end

    it "should return the number of chars translated by translation service" do
      Translator.stub(:get_translation).and_return([l10n[:name],args[:name].length], [l10n[:ctxt],ctxt.length])
      pickable, trans_chars = Translator.translate(args[:name], args[:from], args[:to], ctxt)

      trans_chars.should == args[:name].length + ctxt.length
    end

    it "should raise a ServiceProviderError if Translation Service not responding" do
      TrackedWord.stub(:search).and_return(nil)
      Translator.provider.stub(:translate).and_raise(StandardError)
      lambda { Translator.translate(args[:name], args[:from], args[:to], ctxt) }.should raise_error(Translator::ServiceProviderError)
    end
  end

end
