require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    self.class_name = name.to_s.camelcase
    self.foreign_key = (name.to_s.underscore + "_id").to_sym
    self.primary_key = "id".to_sym

    options.each do |option, value|
      self.send("#{option}=", value)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.class_name = self_class_name # .to_s.camelcase
    self.foreign_key = (name.to_s.underscore + "_id").to_sym
    self.primary_key = "id".to_sym

    options.each do |option, value|
      self.send("#{option}=", value)
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end
