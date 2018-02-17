require 'russian_female_last_name'

# @param [String] family_name the person's family name in the male gender.
# @param [:male, :female] gender
# @return [String, nil] the person's family name in the specified gender.
def russian_last_name(family_name, gender)
  case gender
  when :male then family_name
  when :female then russian_female_last_name(family_name)
  end
end
