# Daylist
# A small checklister for personnal use. Launch it, answer each question and
# get the percentage of stuff done. I've tried unit-testing my daily life this way.
#
# Example:
#   > ruby daylist.rb 
#   Yesterday you...
#   Brushed teeth at least once ? y
#   Washed dishes at least once ? n
#   Ate a veggie meal ? n
#   Results:
#    ✔ Brushed teeth at least once
#    ✗ Washed dishes at least once
#    ✗ Ate a veggie meal
#   1 passed, 2 failed, 33%


class Array
  def lines
    collect { |s| yield s }.join("\n")
  end
end

class DayList
  attr_reader :done, :list

  def initialize(list)
    @list = list.uniq
    @done = {}
  end

  def done?(item)
    @done[item]
  end

  def passed
    @list.select { |task| done?(task) }
  end
  
  def unanswered
    @list.select { |task| done?(task).nil? }
  end
  
  def answered
    @list - unanswered
  end
  
  def failed
    @list - passed - unanswered
  end

  def percentage
    ((passed.size.to_f / answered.size) * 100).to_i
  end

  # Loops through all items
  # given block should return true or false for each item
  def do_each
    # "!!" forces to boolean
    @list.each { |item| @done[item] = !!yield(item) }
    self
  end

  # String methods
  def summary
    "#{passed.size} passed, #{failed.size} failed, #{percentage}%"
  end
  
  # Full list of answers
  def to_s
    passed_s = passed.lines { |task| " ✔ #{task}" } + "\n" + \
    failed_s = failed.lines { |task| " ✗ #{task}" } + "\n" + \
    unanswered_s = unanswered.lines  { |task| " ? #{task}" }
  end  
end

# Example usage
if File.basename($0) == File.basename(__FILE__)
  require 'rubygems'
  require 'highline/import'

  items = <<ITEMS
Brushed teeth twice
Washed dishes
Ate a veggie meal
Took a shower
Read 10 pages at least of current book
Blogged
Emptied inbox
Stopped world hunger
ITEMS
  items = items.split("\n")

  list = DayList.new(items)
  puts "Yesterday you…"
  list.do_each { |item| agree("#{item} ? ") }
  puts "Results:"
  puts list
  puts list.summary
end
