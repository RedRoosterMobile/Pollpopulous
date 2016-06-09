Given(/^I am on the home page$/) do
  visit '/'
  assert page.has_content? 'Create a Poll'
end

And(/^I create a new poll$/) do
  fill_in 'Title' , with: 'some test poll'
  fill_in 'Url' , with: 'some_url'
  click_button 'Create Poll'
end

Then(/^I'm redirected to the poll page$/) do
  assert page.has_content? 'test poll'
  assert page.has_content? 'Add new option'
end

When(/^I add an option "([^"]*)"$/) do |arg|
  fill_in 'Option' , with: arg
  click_button 'Add new option'
end

When(/^I enter my nickname "([^"]*)"$/) do |arg|
  fill_in 'Name' , with: arg
end

And(/^I vote for "([^"]*)"$/) do |arg|
  sleep 1
  assert page.has_css?('a.vote.btn')
  assert page.assert_selector('a.vote', :text => 'Vote here', :visible => true)
  find(:css,'a.vote').click
end

Then(/^I see one star$/) do
  assert_equal 'span',find(:css,'.glyphicon.glyphicon-star-empty').tag_name
end

When(/^I revoke vote for "([^"]*)"$/) do |arg|
  find(:css,'a.revoke').click
end

Then(/^I see no stars$/) do
  sleep 1
  page.has_no_css?('.glyphicon.glyphicon-star-empty')
end