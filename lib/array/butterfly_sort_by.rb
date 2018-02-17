
class Array
  
  # Let <tt>a</tt> is {Array}. Let <tt>as</tt> is <tt>a.</tt>{#sort_by}<tt>(&criteria)</tt>.
  # Then <tt>as.</tt>{#butterfly_sort_by}<tt>(&criteria) =
  # [as[n], as[0], as[n-1], as[1], as[n-2], as[2], as[n-3], as[3], …]</tt>.
  # 
  # @yieldparam [Object] item
  # @yieldreturn [Comparable]
  # @return [Array]
  # 
  def butterfly_sort_by(&criteria)
    a = sort_by(&criteria)
    r = Array.new(a.size)
    (0...(a.size >> 1)).each do |i|
      r[i*2] = a[-i-1]
      r[i*2+1] = a[i]
    end
    if a.size.odd? then
      r[-1] = a[a.size >> 1]
    end
    return r
  end
  
  # @method sort_by(&criteria)
  #   See Ruby doc.
  
end
