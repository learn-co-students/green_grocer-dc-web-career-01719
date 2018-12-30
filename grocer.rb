require "pry"

def consolidate_cart(cart)
    cart.map.with_index do |cart_hashes, index|
        item_count = 1
        counter = 0
        while counter < cart.length
            if index != counter && cart[index] == cart[counter]
                item_count += 1
            end
            counter += 1
        end
        
        cart_hashes.map do |item, atts_hash|
           cart_hashes[item][:count] = item_count
        end
        
    end
    
    new_cart = {}
    
    cart.each do |cart_hashes|
        cart_hashes.each do |item, atts_hash|
            new_cart[item] = atts_hash
        end
    end 
    new_cart
end

def apply_coupons(cart, coupons)
#    binding.pry
    cart_keys = cart.keys
#    binding.pry
    coupons.each do |coup_hash|
         coup_hash.each do |coup_att, coup_val|
#             binding.pry
             if cart_keys.include?(coup_hash[:item])
                 cart["#{coup_hash[:item]} W/COUPON"] = {}
             end
         end
    end
    
    cart.each do |item, item_atts_hash|
        coupon_count = 0
        applied_coupon = 0
#        binding.pry
        while coupon_count < coupons.length
                coupons.each do |coup_hash|
#                    binding.pry
                    if item == coup_hash[:item] && coup_hash[:num] <= item_atts_hash[:count] #must ensure conditions for each coupon are met before applying the coupon.
                        applied_coupon += 1
#                        cart["#{item} W/COUPON"] = item_atts_hash
#                        binding.pry #for some reason, this linked both hashes, so that when the values for item W/COUPON updated, so did the values in item_atts_hash
                        cart["#{item} W/COUPON"][:clearance] = item_atts_hash[:clearance]
                        
                        item_atts_hash[:count] = item_atts_hash[:count] - coup_hash[:num]
                        
                        cart["#{item} W/COUPON"][:count] = applied_coupon
#                        binding.pry
                        cart["#{item} W/COUPON"][:price] = coup_hash[:cost]

                        
                    end
                    coupon_count += 1
                end
        end

    end
#    binding.pry
    cart
end

def apply_clearance(cart)
#  binding.pry
    cart.each do |item, att_hash| #received a String to Integer error when attempting to use map. Since the value I was updating was not in the particular iteration, I used the #each method, created a variable (item_price), and set it equal to the value I wanted to change. This fixed the error message
        if att_hash[:clearance] == true
#            binding.pry
        
            item_price = (att_hash[:price] * 0.80).round(2)
            att_hash[:price] = item_price
        end
    end
end

def checkout(cart, coupons)
    cart_consol = consolidate_cart(cart)
    cart_coup = apply_coupons(cart_consol, coupons)
    cart_clear = apply_clearance(cart_coup)
#    binding.pry
    total_price = 0.0
    cart_clear.each do |item, atts_hash|
        item_price = atts_hash[:price] * atts_hash[:count]
        total_price = total_price + item_price
    end
    if total_price > 100.00
        total_price = (total_price * 0.9).round(2)
    end
    total_price
end
