
class String
  
  # @param [Integer] n
  # @return [String] this {String} without n last characters or self
  #   if n≤0.
  def chompn(n)
    return self if n <= 0
    self[0...-n]
  end
  
end
