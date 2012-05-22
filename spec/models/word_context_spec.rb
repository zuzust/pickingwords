require 'spec_helper'

describe WordContext do

  def valid_attributes
    {
      sentence: "This word is written in English",
      translation: "Aquesta paraula esta escrita en catala"
    }
  end
  
  it "should require a sentence" do
    no_sentence_ctx = WordContext.new(valid_attributes.merge(sentence: ""))
    no_sentence_ctx.should_not be_valid
  end
  
  it "should require a translation" do
    no_trans_ctx = WordContext.new(valid_attributes.merge(translation: ""))
    no_trans_ctx.should_not be_valid
  end
  
end
