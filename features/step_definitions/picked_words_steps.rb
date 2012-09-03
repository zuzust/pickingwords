def fill_in_form(word, from, to, ctxt="")
  fill_in "name", with: word
  select from, from: "from" unless from.blank?
  select to, from: "to" unless to.blank?
  fill_in "ctxt", with: ctxt unless ctxt.blank?
end

Given /^I picked the following words:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |attrs|
    Fabricate(:picked_word, attrs.merge(user: @user))
  end
end

Given /^just the following filters are applied:\s*(.*?)$/ do |filters|
  filters.scan(/\w+/).each do |filter|
    filter.upcase! if filter =~ /^[a-z]{2}$/i
    click_link filter unless filter =~ /#{I18n.locale}/i
  end
end

When /^I look for nonexistent pick '(.*?)' from '(.*?)' to '(.*?)'$/ do |word,from,to|
  step "I look for pick '#{word}' from '#{from}' to '#{to}'"
end

When /^I look for existing pick '(.*?)' from '(.*?)' to '(.*?)'$/ do |word,from,to|
  step "I look for pick '#{word}' from '#{from}' to '#{to}'"
end

When /^I look for pick '(.*?)' from '(.*?)' to '(.*?)'$/ do |word,from,to|
  fill_in_form word, from, to
  click_button "Translate"
end

Then /^just the following filters should be applied:\s*(.*?)$/ do |filters|
  url_params = []
  filters.scan(/\w+/).each do |filter|
    case filter
    when "fav"       then url_params << "favs=1"
    when /[a-z]{2}/i then url_params << "locale=#{filter.downcase}"
    when /[a-z]{1}/  then url_params << "letter=#{filter}"
    end
  end
  current_url.should =~ /\?#{url_params.sort.join("&")}$/
end

Then /^I should see a missing name error message$/ do
  step "I should see the following error message: 'Name can't be blank'"
end

Then /^I should see a invalid name error message$/ do
  step "I should see the following error message: 'Name is not a dictionary word'"
end

Then /^I should see a same source and target locales error message$/ do
  step "I should see the following error message: 'Make sure that source and target languages are different'"
end

Then /^I should see a nothing to show message$/ do
  step "I should see the text 'No picks to show'"
end

Then /^I should only see the pick '(.*?)' listed$/ do |word|
  step "I should see the pick '#{word}'"
  page.has_css? 'div.pw-word', count: 1
end

Then /^I should see the pick '(.*?)'$/ do |word|
  step "I should see the text '#{word}'"
end

