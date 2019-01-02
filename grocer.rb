require 'pry'

def consolidate_cart(cart)
  
## creates cart to be output at the end
  consolidated_cart = {}
  
## iterates over each item and all its data
  cart.each { |item|
    

## for each item in the cart, do something to just its name, then the price info
    item.each { |name, price|
      
      
## if the name of the item is not already a key in consolidated_cart
      if consolidated_cart[name].nil?
        ## make the name a key, and make its values the price info plus the count of 1 

        consolidated_cart[name] = price.merge({:count => 1})
      else
        consolidated_cart[name][:count] += 1
      end
    }
  
    
    
    
  }
  consolidated_cart
  
end

def apply_coupons(cart, coupon)
  coupon.each {|item|
    name_of_item = item[:item]
    if cart.has_key?(name_of_item) == true && cart[name_of_item][:count] >= item[:num]
      cart[name_of_item][:count] = cart[name_of_item][:count] - item[:num]
      new_item = name_of_item + (" W/COUPON")
      if cart.has_key?(new_item) == false
        cart[new_item] = {:price => item[:cost], :clearance => cart[name_of_item][:clearance], :count => 1}
      else 
        cart[new_item][:count] += 1
      end
    end
  }
   cart
end
  


def apply_clearance(cart)
 cart.each {|x,y|
 if y[:clearance] === true
   clearance_price = y[:price] * 0.8
   y[:price] = clearance_price.round(2)
 end 
 }
end

def checkout(cart, coupons)
  grand_total = 0 
  cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
   cart.each {|x, y|
  grand_total += (y[:price] * y[:count])}
  if grand_total > 100 
    grand_total *= 0.9
  end
  grand_total
  end
