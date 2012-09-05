When /^I submit the Contact form with '(.*?)', '(.*?)', '(.*?)' and '(.*?)' values$/ do |name,email,subject,body|
  steps %Q{
    When I fill in 'Name' with '#{name}'
     And I fill in 'Email' with '#{email}'
     And I fill in 'Subject' with '#{subject}'
     And I fill in 'Body' with '#{body}'
     And I press 'Send'
  }
end

Then /^I should see a missing email error message$/ do
  step "I should see the following error message: 'Email.*can't be blank'"
end

Then /^I should see a email format not valid error message$/ do
  step "I should see the following error message: 'Email.*is not well formed'"
end

Then /^I should see a missing body error message$/ do
  step "I should see the following error message: 'Body.*can't be blank'"
end

Then /^a message from '(.*?)', with subject '(.*?)' and body '(.*?)' should be delivered$/ do |from,subject,body|
  mail = ActionMailer::Base.deliveries.last
  mail[:from].value.should == from
  mail.subject.should == "[pickingwords-contact] #{subject}"
  mail.body.encoded.should =~ /#{body}/
end

Then /^I should see a message successfully delivered message$/ do
  step "I should see the following message: 'Your message has been successfully delivered and will be considered'"
end

Then /^the Contact form fields should be cleared$/ do
  within("form#new_cf") do
    find_field("Name").value.should be_nil
    find_field("Email").value.should be_nil
    find_field("Subject").value.should be_nil
    find_field("Body").value.should be_empty
  end
end
