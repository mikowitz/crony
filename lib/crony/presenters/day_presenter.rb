module Crony
  class DayPresenter
    def self.parse(day, month, weekday)
      day = Formatters::DayOfMonthFormatter.new(Parser.parse(day))
      month = Formatters::MonthFormatter.new(Parser.parse(month))
      weekday = Formatters::DayOfWeekFormatter.new(Parser.parse(weekday))

      case [day, month, weekday].map(&:sym).join('')
      when 'eee' then 'every day'
      # 'on May 22nd,' not 'on the 22nd of May'
      when /^[sc]s.$/ then "on #{month.s} #{day.format(false)} #{"and #{weekday.format} in #{month.format}" unless weekday.sym == 'e'}"
      # 'on the weekday(s) closest to May 22nd,' not 'on the weekday(s) closest to the 22nd of May'
      when /^w[cs].$/ then "on the weekday#{"s" if month.sym == 'c'} closest to #{month.format} #{day.s(false)} #{"and #{weekday.format} in #{month.format}" unless weekday.sym == 'e'}"
      when /^u[cs]e$/ then "#{day.v} of #{month.format} starting on the #{day.start.ordinal}"
      when /^e.[^e]$/ then ("on %s of %s" % [weekday.format, month.format]).squeeze(' ')
      when /^..e$/ then ("%s of %s" % [day.format, month.format]).squeeze(' ')
      else ("%s and %s of %s" % [day.format, weekday.format, month.format]).squeeze(' ')
      end
    end
  end
end
