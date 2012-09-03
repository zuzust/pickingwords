Then /^I should be on (.+)$/ do |page_name|
  current_url.should =~ /#{path_to(page_name)}/
end

Then /^I should remain on (.+)$/ do |page_name|
  current_url.should =~ /#{path_to(page_name)}/
end

Then /^I should see the following error messages:\s*(.*?)$/ do |errors|
  errors.split(/,\s*/).each { |error| step "I should see a #{error} error message" }
end

Then /^I should see the following error message: '(.*?)'$/ do |mesg|
  page.body.should =~ /#{mesg}/i
end

Then /^I should see the text '(.*?)'$/ do |text|
  page.should have_content(text)
end

