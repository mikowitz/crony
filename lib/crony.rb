require_relative 'utility_functions'
require_relative 'crony/parser'
Dir[File.dirname(__FILE__) + '/crony/**/*.rb'].each {|file| require_relative file}

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
