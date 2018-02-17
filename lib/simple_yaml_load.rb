
# Reads YAML file of the form of:
#   
#   key1: int1
#   key2: int2
#   ...
# 
# @return [Array<Array<(Object, Integer)>>]
def simple_yaml_load(file)
  simple_yaml_load1(file).
    map { |k, v| [k, Integer(v)] }
end

# Reads YAML file of the form of:
#   
#   key1: str1
#   key2: str2
#   ...
# 
# @return [Array<Array<(Object, Object)>>]
def simple_yaml_load1(file)
  r = []
  File.read(file).split("\n").each do |line|
    e = line.split(": ", 2).map(&:strip)
    next if e.size != 2
    r.push(e)
  end
  return r
end
