require 'pry'

def consolidate_cart(cart)
  consolidated_cart = Hash.new
  array = Array.new
  cart.each do |item|
    array.push(item) unless array.include?(item)
  end
  array.each do |food|
    new_array = Array.new
    cart.each do |item|
      if item == food
        new_array.push(item)
      end
    end
    food.each do |food_name, food_data|
      food_data[:count] = new_array.size
      consolidated_cart[food_name] = food_data
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
         cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => cart[coupon[:item]][:count]/coupon[:num]}
         cart[coupon[:item]][:count] = cart[coupon[:item]][:count] % coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_info|
    if item_info[:clearance] == true
      item_info[:price] = (item_info[:price] * 0.8).round(1)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, item_info|
    total += (item_info[:price] * item_info[:count]).round(1)
  end
  if total > 100
    total = (total * 0.9).round(1)
  end
  total
end
