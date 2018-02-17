require 'realistic_russian_male_last_names'
require 'russian_female_last_name'

# @return [WeighedDistribution<String>]
def realistic_russian_female_last_names
  realistic_russian_male_last_names.map { |n| russian_female_last_name(n) }
end
