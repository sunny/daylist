#!/usr/bin/env ruby
# Daylist
# A small checklister for personnal use. Launch it, answer each question and
# get the percentage of stuff done. I've tried unit-testing my daily life this way.
#
# Example:
#   > ruby daylist.rb example.txt
#   Yesterday you...
#   Brushed teeth at least once ? y
#   Washed dishes at least once ? n
#   Ate a veggie meal ? n
#   Results:
#    ✔ Brushed teeth at least once
#    ✗ Washed dishes at least once
#    ✗ Ate a veggie meal
#   1 passed, 2 failed, 33%

require 'rubygems'
require 'highline/import'

class Array
  def lines
    collect { |s| yield s }.join("\n")
  end
end

class DayList
  attr_reader :done, :list

  def initialize(list)
    @list = list.reject { |item| item.empty? }.uniq
    @done = {}
  end

  def done?(item)
    @done[item]
  end

  def passed
    @list.select { |task| @done[task] == true }
  end

  def failed
    @list.select { |task| @done[task] == false }
  end

  def unanswered
    @list.select { |task| @done[task].nil? }
  end
  
  def answered
    @list.reject { |task| @done[task].nil? }
  end

  def percentage
    total_answered = answered.size.to_f
    return 0 if total_answered == 0
    ((passed.size / total_answered) * 100).to_i
  end

  # Loops through all items
  # given block should return true or false for each item
  def do_each
    @list.each { |item| @done[item] = !!yield(item) } # "!!" forces to boolean
    self
  end

  # String methods
  def summary
    "#{passed.size} passed, #{failed.size} failed, #{percentage}%"
  end
end

class DayListReader
  def initialize(file_name)
    items = open(file_name).read.gsub(/\w*#.*$/, '').chomp.split("\n")
    @list = DayList.new(items)
  end
  def ask
    begin
      @list.do_each { |item| agree("#{item} ? ", true) }
    rescue Interrupt
      puts
    end
    puts "Results:"
    puts @list.passed.lines { |task| " ✔ #{task}" } unless @list.passed.empty?
    puts @list.failed.lines { |task| " ✗ #{task}" } unless @list.failed.empty?
    puts @list.unanswered.lines  { |task| " ? #{task}" } unless @list.unanswered.empty?
    puts @list.summary
  end
end

if $0 == __FILE__
  abort "Usage: #{$0} filename" if ARGV.empty?
  DayListReader.new(ARGV.last).ask
end

