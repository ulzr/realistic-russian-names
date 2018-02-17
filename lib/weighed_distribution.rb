# encoding: UTF-8
require 'numeric/but_not_less_than'
require 'array/butterfly_sort_by'

# An infinite set composed of specified items. The higher the weight is assigned
# to an item in {#initialize}, the higher the probability of {#sample} returning
# that item.
class WeighedDistribution
  
  # @param [Enumerable<Array<(Object, Numeric)>>] items_and_weights
  # @param [Random] random
  def initialize(items_and_weights)
    items_and_weights = items_and_weights.
      map { |item, weight| ItemAndWeight.new(item, weight) }
    @interim_weights_sums_table = InterimWeightsSumsTable.new(
      # Group items by equal weight:
      #   {a, 10}, {b, 10}, {c, 10}, … → {[a, b, c], 30}, …
      items_and_weights.group_by(&:weight).map do |weight, items_and_weights|
        ItemsAndWeightsSum.new(
          items_and_weights.map(&:item),
          weight * items_and_weights.size
        )
      end.
      # Balance weights distribution.
      butterfly_sort_by(&:weights_sum).
      #
      map { |x| [x.items, x.weights_sum] }
    )
    @weights_sum = items_and_weights.map(&:weight).reduce(&:+)
  end
  
  # This method works for O(log(w)) where w is the number of distinct weights
  # passed to {#initialize}.
  # 
  # @overload sample
  #   @return [Object]
  # @overload sample(random: rng)
  #   @param [Random] rng
  #   @return [Object]
  def sample(args = {})
    rng = args[:random] || Kernel
    # 
    chosen_interim_weights_sum = rng.rand(@weights_sum)
    # Binary-search for @interim_weights_sums_table's entry index which is:
    #   chosen_interim_weights_sum ≥ (previous entry).interim_weights_sum and
    #   chosen_interim_weights_sum < (chosen entry).interim_weights_sum
    chosen_entry_index = begin
      table = @interim_weights_sums_table
      start_index = 0
      end_index = table.last_index
      while true
        middle_index = ((end_index + start_index) / 2).floor
        break middle_index if
          chosen_interim_weights_sum >= table[middle_index - 1].interim_weights_sum and
          chosen_interim_weights_sum < table[middle_index].interim_weights_sum
        if chosen_interim_weights_sum >= table[middle_index].interim_weights_sum then
          start_index = middle_index + 1
        else # if chosen_interim_weights_sum < table[middle_index].interim_weights_sum then
          end_index = (middle_index - 1).but_not_less_than(start_index)
        end
      end
    end
    #
    chosen_entry = @interim_weights_sums_table[chosen_entry_index]
    # 
    chosen_item = begin
      chosen_items = chosen_entry.value
      if chosen_items.size == 1 then
        chosen_items.first
      else
        previous_entry = @interim_weights_sums_table[chosen_entry_index - 1]
        chosen_items_weights_sum = chosen_entry_weight =
          previous_entry.interim_weights_sum - chosen_entry.interim_weights_sum
        weight_per_item =
          chosen_items_weights_sum / chosen_items.size
        chosen_item_index =
          ((chosen_interim_weights_sum - previous_entry.interim_weights_sum) / weight_per_item).floor
        chosen_items[chosen_item_index]
      end
    end
    #
    return chosen_item
  end
  
  # @yieldparam [Object] item
  # @yieldreturn [Object]
  # @return [WeighedDistribution] having all items passed through the block.
  def map(&f)
    Mapped.new(self, &f)
  end
  
  private
  
  # @!visibility private
  class Mapped < WeighedDistribution
    
    # @api private
    # @note Used by {WeighedDistribution#map} only.
    def initialize(source, &map)
      @source = source
      @map = map
    end
    
    # (see WeighedDistribution#sample)
    def sample(*args)
      @map.(@source.sample(*args))
    end
    
  end
  
  # @!visibility private
  ItemAndWeight = Struct.new :item, :weight
  
  # @!visibility private
  ItemsAndWeightsSum = Struct.new :items, :weights_sum
  
  # @!visibility private
  class InterimWeightsSumsTable
    
    # @param [Array<(Object, Numeric)>] values_and_weights
    def initialize(values_and_weights)
      interim_weights_sum = 0
      @entries = values_and_weights.map do |value, weight|
        interim_weights_sum += weight
        Entry.new(value, interim_weights_sum)
      end
    end
    
    # @param [Integer] index
    # @return [Entry, nil] {Entry} if index < {#size} and nil otherwise.
    #   If index < 0 then resultant {Entry#interim_weights_sum} = 0.
    def [](index)
      if index < 0 then
        Entry.new([], 0)
      else
        @entries[index]
      end
    end
    
    # @return [Integer]
    def last_index
      size - 1
    end
    
    # @return [Integer]
    def size
      @entries.size
    end
    
    # - interim_weights_sum (Numeric) - sum of weights of this {Entry} and
    #   all previous {Entry}es.
    # - value (Object)
    Entry = Struct.new :value, :interim_weights_sum
    
  end
  
end

# 
# NOTE: The following is the reimplementation of the class above based on
# balanced binary tree. Somehow it is slower than the implementation above.
# 
# # An infinite set composed of specified items. The higher the weight is assigned
# # to an item in {#initialize}, the higher the probability of {#sample} returning
# # that item.
# class WeighedDistribution
#   
#   # @param [Enumerable<Array<(Object, Numeric)>>] items_and_weights
#   def initialize(items_and_weights)
#     items_and_weights =
#       items_and_weights.map { |item, weight| ItemAndWeight.new(item, weight) }
#     # Group items with the same weight:
#     #   {item1, 10}, {item2, 10}, {item3, 10}, ... →
#     #   {30, [item1, item2, item3]}, ...
#     items_and_weights_sums = items_and_weights.
#       group_by(&:weight).map do |weight, items_and_weights|
#         items = items_and_weights.map(&:item)
#         ItemsAndWeightsSum.new(items, weight * items.size)
#       end
#     #
#     @impl = begin
#       leaves = items_and_weights_sums.
#         map { |x| BalancedBinaryTree::Leaf.new(x.weights_sum, x.items) }.
#         sort_by(&:key)
#       BalancedBinaryTree.new(leaves, leaves.map(&:key).reduce(&:+))
#     end
#   end
#   
#   # This method works for O(log(w)) where w is a number of distinct weights
#   # passed to {#new}.
#   # 
#   # @overload sample
#   #   @return [Object]
#   # @overload sample(random: rng)
#   #   @param [Random] rng
#   #   @return [Object]
#   def sample(args = {})
#     rng = args[:random] || Kernel
#     chosen_interim_weights_sum = rng.rand(@impl.keys_sum)
#     less_weights_sum, items, items_weights_sum = begin
#       r = @impl.delimit(chosen_interim_weights_sum)
#       [r.less_keys_sum, r.leaf.value, r.leaf.key]
#     end
#     chosen_interim_weights_sum -= less_weights_sum
#     per_item_weight = items_weights_sum / items.size
#     items[(chosen_interim_weights_sum / per_item_weight).floor]
#   end
#   
#   private
#   
#   ItemAndWeight = Struct.new :item, :weight
#   
#   ItemsAndWeightsSum = Struct.new :items, :weights_sum
#   
#   module BalancedBinaryTree
#     
#     # @param [Enumerable<Leaf>] {Leaf}s sorted by {Leaf#key}, size >= 1
#     # @param [Numeric] keys_sum
#     # @return [BalancedBinaryTree]
#     def self.new(leaves, keys_sum)
#       case leaves.size
#       when 1
#         leaves.first
#       when 2
#         Node.new(*leaves, keys_sum)
#       else
#         # Split leaves into two parts so the first part keys sum is
#         # approximately equal to the second part keys sum.
#         part1_index = 1 # after the last part #1's leaf
#         part1_keys_sum = leaves.first.key
#         part2_index = leaves.size - 1 # at the first part #2's leaf
#         part2_keys_sum = leaves.last.key
#         until part1_index == part2_index
#           if part1_keys_sum < part2_keys_sum then
#             part1_keys_sum += leaves[part1_index].key
#             part1_index += 1
#           else
#             part2_index -= 1
#             part2_keys_sum += leaves[part2_index].key
#           end
#         end
#         # 
#         Node.new(
#           BalancedBinaryTree.new(leaves[0...part1_index], part1_keys_sum),
#           BalancedBinaryTree.new(leaves[part2_index..-1], part2_keys_sum),
#           keys_sum
#         )
#       end
#     end
#     
#     # @method delimit(n)
#     #   @abstract
#     #   
#     #   Returns {Leaf} _x_ which has minimum {Leaf#key} and (sum of
#     #   {Leaf#key}s less than _x_'s) < n.
#     #   
#     #   @param [Numeric] n
#     #   @return [DelimitResult]
#     
#     # @method keys_sum
#     #   @abstract
#     #   @return [Numeric] sum of all keys under this {Node}.
#     
#     DelimitResult = Struct.new :less_keys_sum, :leaf
#     
#     class Node < Struct.new :left, :right, :keys_sum
#       
#       include BalancedBinaryTree
#       
#       # (see BalancedBinaryTree#delimit)
#       def delimit(n)
#         if n < left.keys_sum
#           left.delimit(n)
#         else
#           r = right.delimit(n - left.keys_sum)
#           DelimitResult.new(left.keys_sum + r.less_keys_sum, r.leaf)
#         end
#       end
#       
#     end
#     
#     class Leaf < Struct.new :key, :value
#       
#       include BalancedBinaryTree
#       
#       # (see BalancedBinaryTree#delimit)
#       def delimit(n)
#         DelimitResult.new(keys_sum, self)
#       end
#       
#       # (see BalancedBinaryTree#keys_sum)
#       def keys_sum
#         key
#       end
#       
#     end
#     
#   end
#   
# end
