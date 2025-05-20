#!/usr/bin/env ruby

path = "/home/itagaki_syun/ruby-practices/04.ls"
file = Dir.entries(path)

file.delete_if { |str| str.start_with?('.') }

file = file.sort_by(&:downcase)
p file
