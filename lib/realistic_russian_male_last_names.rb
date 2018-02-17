require 'weighed_distribution'
require 'simple_yaml_load'

# (see #realistic_russian_male_last_names)
REALISTIC_RUSSIAN_MALE_LAST_NAMES =
  WeighedDistribution.new(
    simple_yaml_load(
      "#{File.dirname(__FILE__)}/russian_male_last_names_and_popularity.yaml"
    )
  )

# @return [WeighedDistribution<String>]
def realistic_russian_male_last_names
  REALISTIC_RUSSIAN_MALE_LAST_NAMES
end
