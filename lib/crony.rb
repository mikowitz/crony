require 'utility_functions'
require 'crony/parser'
require 'crony/formatters/cron_struct'
require 'crony/formatters/minute_formatter'
require 'crony/formatters/hour_formatter'
require 'crony/formatters/day_of_month_formatter'
require 'crony/formatters/month_formatter'
require 'crony/formatters/day_of_week_formatter'
require 'crony/formatters/year_formatter'
require 'crony/presenters/time_presenter'
require 'crony/presenters/day_presenter'
require 'crony/presenters/year_presenter'
require 'crony/version'

module Crony
  def self.parse(expression)
    return 'Invalid Format' if expression.split(/\s+/).size < 5

    @minute, @hour, @day, @month, @weekday, @year = expression.split(/\s+/)
    return 'Invalid Format' unless valid?

    time = TimePresenter.parse(@minute, @hour)
    day = DayPresenter.parse(@day, @month, @weekday)
    year = !!@year ? YearPresenter.parse(@year) : ''
    result = "#{time} #{day} #{year}".strip.squeeze(' ').gsub(/ ,/, ',')
    result.sub(/^(.)/) { $1 == 'x' ? $1 : $1.upcase}
  end

  def self.valid?
    @minute =~ /^[\*\/,\-\d]+$/ &&
    @hour =~ /^[\*\/,\-\d]+$/ &&
    @day =~ /^[\*\/,\-\?LW\d]+$/ &&
    @month =~ /^[\*\/,\-\djanfebmrpyjulgsoctv]+$/i &&
    @weekday =~ /^[\*\/,\-\?\dsunmotewdhfriaL#]+$/i &&
    (@year.nil? || @year  =~ /^[\*\/,\-\d]*$/)
  end
end
