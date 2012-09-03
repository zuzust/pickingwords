Given /^the translation service provides the following translations?:$/ do |translations|
  stub_request(:post, /datamarket.accesscontrol.windows.net.*/).to_return(status: 200, body: "{\"access_token\": \"token\", \"expires_in\": \"600\"}")

  stub = stub_request(:get, /api.microsofttranslator.com.*/)
  translations.hashes.each do |response|
    stub.send(:to_return, {status: 200, body: "<string xmlns='http://schemas.microsoft.com/2003/10/Serialization/'>#{response[:translation]}</string>"})
    stub.send(:then)
  end
  stub.to_return({})
end

Given /^the translation service does not respond$/ do
  stub_request(:post, /datamarket.accesscontrol.windows.net.*/).to_raise(StandardError)
  stub_request(:get, /api.microsofttranslator.com.*/).to_raise(StandardError)
end

Then /^I should see a service provider not responding message$/ do
  step "I should see the following error message: 'Sorry, translation service not responding. Try it again in a few minutes.'"
end

When /^I translate '(.*?)' from '(.*?)' to '(.*?)'( with context '(.*?)')?$/ do |word,from,to,_,ctxt|
  fill_in_form word, from, to, ctxt
  click_button "Translate"
end

Then /^I should see the word '(.*?)' and its translation '(.*?)'$/ do |text, translation|
  within("#new_picked_word") do
    find("#picked_word_name").value.should =~ /#{text}/
    find("#picked_word_translation").value.should =~ /#{translation}/
  end
end

Then /^I should see the context '(.*?)' and its translation '(.*?)'$/ do |text, translation|
  within("#new_picked_word") do
    find("#picked_word_contexts_attributes_0_sentence").value.should =~ /#{text}/
    find("#picked_word_contexts_attributes_0_translation").value.should =~ /#{translation}/
  end
end
