
class Numeric
  
  # @param [Numeric] n
  # @return [Numeric]
  def but_not_less_than(n)
    if self < n then n else self end
  end
  
end
