def update_shopping_cart(cart, action):
  product_id = action.get("product_id")

  # handle adding items
  if action["type"] == "add":
      if product_id in cart:
          cart[product_id] += action["quantity"]
      else:
          cart[product_id] = action["quantity"]

  # Handle removing items
  elif action["type"] == "remove":
      if product_id in cart:
          del cart[product_id]

  # Handle changing quantity
  elif action["type"] == "change" and "quantity" in action:
      if action["quantity"] > 0:
          cart[product_id] = action["quantity"]
      else:
          del cart[product_id]

  return cart

# do not modify the values below
print(update_shopping_cart({ "product_A": 4, "product_B": 3, "product_C": 1 }, { "type": "change", "product_id": "product_B", "quantity": 2 }))