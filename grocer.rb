
def consolidate_cart(cart)
  consolidated_cart = {}
  in_cart = []
  cart.each do |item|
    if in_cart.include?(item.keys.join)
      consolidated_cart[item.keys.join][:count] += 1
    else
      in_cart << item.keys.join
      consolidated_cart[item.keys.join] = item[item.keys.join]
      consolidated_cart[item.keys.join][:count] = 1
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  return_cart = {}
  return_cart.merge!(cart)
  coupons.each do |coupon|
    cart.each do |item, properties|
      coupon_applies = (coupon[:item] == item)
      enough_items = (coupon[:num] <= properties[:count])
      if coupon_applies && enough_items
        if return_cart.keys.include?("#{coupon[:item]} W/COUPON") #This coupon applied already?
          return_cart["#{coupon[:item]} W/COUPON"][:count] += 1   #Increment its :count by 1
        else                                                      #Else, add coupon to cart
          return_cart.merge!({"#{item} W/COUPON" => {:price => coupon[:cost], :clearance => properties[:clearance], :count => 1}})
        end
        return_cart[item][:count] -= coupon[:num]
      end
    end
  end
  return_cart
end

def apply_clearance(cart)
  cart.each do |item, properties|
    properties[:price] = (properties[:price] * 0.8).round(2) if properties[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated_cart, coupons)
  clearance_applied = apply_clearance(coupons_applied)
  item_totals_array = clearance_applied.collect do |item, properties|
    properties[:price] * properties[:count]
  end
  item_totals_sum = item_totals_array.inject(0){|sum, item_total| sum + item_total}
  item_totals_sum > 100.0 ? total = (item_totals_sum * 0.9).round(2) : total = item_totals_sum
  total
end
