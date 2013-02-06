require_relative 'utility_functions'
require_relative 'crony/parser'
require_relative 'crony/formatters/cron_struct'
require_relative 'crony/formatters/minute_formatter'
require_relative 'crony/formatters/hour_formatter'
require_relative 'crony/formatters/day_of_month_formatter'
require_relative 'crony/formatters/month_formatter'
require_relative 'crony/formatters/day_of_week_formatter'
require_relative 'crony/formatters/year_formatter'
require_relative 'crony/presenters/time_presenter'
require_relative 'crony/presenters/day_presenter'
require_relative 'crony/presenters/year_presenter'
require_relative 'crony/version'

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
