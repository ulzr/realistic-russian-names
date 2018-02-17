require 'realistic_russian_male_first_names'
require 'russian_patronymic'

# @param [:male, :female] gender
# @return [WeighedDistribution<String>]
def realistic_russian_patronymics(gender)
  realistic_russian_male_first_names.map { |n| russian_patronymic(n, gender) }
end
