require_relative 'lib/words_from_string'
require_relative 'lib/count_frequency'

def sorted_count_frequency(word_list)
  count_frequency(word_list).sort_by { |key, count| count }
end

abort 'Must specify a text file to read from' if ARGV.length == 0

raw_text = File.read ARGV.first
word_list = words_from_string raw_text
sorted = sorted_count_frequency word_list
sorted.reject{|word, count| word.length <= 3 }.last(5).reverse.each do |word, count|
  puts "#{word}: #{count}"
end


