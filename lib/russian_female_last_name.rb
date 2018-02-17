# encoding: UTF-8
require 'string/chompn'

# @param [String] male_last_name last name in the male form.
# @return [String, nil] female last name derived from the
#   <tt>male_last_name</tt>.
def russian_female_last_name(male_last_name)
  name = male_last_name
  if name.include? "-" then
    return name.split("-", -1).
      map { |part| russian_female_last_name(part) or return nil }.
      join("-")
  end
  case name
  when /(ой|ый)$/ then name.chompn(2) + "ая"
  when /[гжкцчшщ]ий$/ then name.chompn(2) + "ая"
  when /ий$/ then name.chompn(2) + "яя"
  when /(ов|ев|ёв|ын|ин)$/ then name + "а"
  when /[бвгджзйклмнпрстфхцчшщьаеиоуыэюя]$/ then name
  else return nil
  end
end
