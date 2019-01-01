require "pry"


def consolidate_cart(cart)
  # code here
  new_cart_hash = {}
  cart.each do |i|
    i.each do |food, data|
      if new_cart_hash.has_key?(food)
        new_cart_hash[food][:count] += 1
      else
        new_cart_hash[food] = {:price => data[:price], :clearance => data[:clearance], :count => 1}
      end
    end
  end
  new_cart_hash
end

def apply_coupons(cart, coupons)
  # code here
  
  coupons.each do |i|
    if cart.has_key?(i[:item])
      active_item = cart[i[:item]]
      name = "#{i[:item].to_s} W/COUPON"
      if cart.has_key?(name) and active_item[:count] >= i[:num]
        cart[name][:count] += 1
        active_item[:count] -= i[:num]
      elsif cart.has_key?(name)
        puts "not enough items for coupon"
      else
        cart[name] = {:price => i[:cost], :clearance => active_item[:clearance], :count => 1}
        active_item[:count] -= i[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  
  cart.each do |food, data|
    if data[:clearance]
      data[:price] = (data[:price] * 0.8).round(1)
    end
  end
  
end

def checkout(cart, coupons)
  
  total = 0
  
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  
  new_cart.each do |food, data|
    if data[:count] > 1
      total += (data[:price] * data[:count])
    elsif data[:count] == 1
      total += data[:price]
    end
  end
  
  if total > 100.0
    total = (total *0.9).round(1)
  else
    total
  end

end
