class Card < ApplicationRecord
  has_many :fields

  def add_field(contents)
    field = Field.new
    field.contents = contents
    field.card = self
    self.fields << field
    field.save()
  end

  def contents
    return self.fields.map { |f| f.contents }
  end

  def size
    return self.fields.length
  end

end
