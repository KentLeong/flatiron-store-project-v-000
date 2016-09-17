class Cart < ActiveRecord::Base
  has_many :line_items
  has_many :items, through: :line_items
  belongs_to :user


  def add_item(item_id)
    item = line_items.find_by(item_id: item_id)
    if item
      item.quantity += 1
    else
      item = self.line_items.build(item_id: item_id)
    end
    item
  end

  def total
    total = 0
    line_items.each do |item|
      total += item.item.price * item.quantity
    end
    total
  end

  def checkout
    self.status = "submitted"
    line_items.each do |item|
      item.item.inventory -= item.quantity
      item.item.save
    end
  end
end
