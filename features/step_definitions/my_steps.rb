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
  sleep 1
end

Then(/^I see no stars$/) do
  sleep 1
  page.has_no_css?('.glyphicon.glyphicon-star-empty')
end

Then(/^there is still only one option$/) do
  assert Array(
             find(:css, '.list-group-item')
         ).length == 1
end


# fixme: use factory girl!

Given(/^There is a poll set up$/) do
  @poll = Poll.new(title:'some test poll' , url:'some_url')
  @poll.candidates.push(Candidate.new(name: 'option name2'))
  @poll.save!
end

And(/^Someone has voted on a candiate$/) do
  new_vote = Vote.new(
      poll_id: @poll.id,
      candidate_id: @poll.candidates.first.id,
      nickname: 'not you')
  new_vote.save!
end

And(/^I go to the poll url$/) do
  visit "/vote_here/#{@poll.url}"
end

# todo: model tests
And(/^I clean up for coverage$/) do
  @poll.destroy
end

Then(/^I see "([^"]*)" stars$/) do |arg|
  assert page.assert_selector('.glyphicon.glyphicon-star-empty', :count => arg.to_i)
end

And(/^I go to the poll page$/) do
  visit '/polls'
end

Then(/^I should get a "([^"]*)"$/) do |status|
  assert_equal status.to_i, page.status_code
end

And(/^I go to the poll page with a token$/) do
  visit "/polls?auth_code=#{Rails.application.config.auth_code}"
end

When(/^I update the existing poll$/) do
  click_link 'Edit'
  fill_in 'Title' , with: 'new title'
  fill_in 'Url' , with: 'new url'
  click_button 'Update Poll'
end

Then(/^it should be updated$/) do
  assert page.has_content? 'Poll was successfully updated.'
end

When(/^I click back$/) do
  click_link 'Back'
end

And(/^I click destroy and confirm$/) do
  click_link 'Destroy'
end

Then(/^There should be no polls in database$/) do
  assert Poll.all.empty?
end