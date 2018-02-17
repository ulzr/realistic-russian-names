require 'weighed_distribution'
require 'simple_yaml_load'

# (see #realistic_russian_female_first_names)
REALISTIC_RUSSIAN_FEMALE_FIRST_NAMES =
  WeighedDistribution.new(
    simple_yaml_load(
      "#{File.dirname(__FILE__)}/russian_female_first_names_and_popularity.yaml"
    )
  )

# @return [WeighedDistribution<String>]
def realistic_russian_female_first_names
  REALISTIC_RUSSIAN_FEMALE_FIRST_NAMES
end
