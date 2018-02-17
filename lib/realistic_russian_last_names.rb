require 'realistic_russian_male_last_names'
require 'realistic_russian_female_last_names'

# @param [:male, :female] gender
# @return [WeighedDistribution<String>]
def realistic_russian_last_names(gender)
  case gender
  when :male then realistic_russian_male_last_names
  when :female then realistic_russian_female_last_names
  end
end
