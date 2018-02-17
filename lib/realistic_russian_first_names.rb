require 'realistic_russian_male_first_names'
require 'realistic_russian_female_first_names'

# @param [:male, :female] gender
# @return [WeighedDistribution<String>]
def realistic_russian_first_names(gender)
  case gender
  when :male then realistic_russian_male_first_names
  when :female then realistic_russian_female_first_names
  end
end
