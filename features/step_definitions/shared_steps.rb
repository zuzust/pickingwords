Given /^I am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I fill in '(.*?)' with '(.*?)'$/ do |field,value|
  fill_in field, with: value
end

When /^I press '(.*?)'$/ do |button|
  click_button button 
end

Then /^I should be on (.+)$/ do |page_name|
  current_url.should =~ /#{path_to(page_name)}/
end

Then /^I should remain on (.+)$/ do |page_name|
  current_url.should =~ /#{path_to(page_name)}/
end

Then /^I should see the following error messages:\s*(.*?)$/ do |errors|
  errors.split(/,\s*/).each { |error| step "I should see a #{error} error message" }
end

Then /^I should see a missing name error message$/ do
  step "I should see the following error message: 'Name.*can't be blank'"
end

Then /^I should see the following (error )?message: '(.*?)'$/ do |_,mesg|
  page.body.should =~ /#{mesg}/i
end

Then /^I should see the text '(.*?)'$/ do |text|
  page.body.should have_content(text)
end

