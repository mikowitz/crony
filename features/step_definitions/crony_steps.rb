require 'crony'

When /^I parse the expression "(.*?)"$/ do |expression|
  @parsed = Crony.parse(expression)
end

Then /^I return "(.*?)"$/ do |expected|
  assert_equal expected, @parsed
end
