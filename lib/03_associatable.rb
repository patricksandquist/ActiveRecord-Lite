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
    class_name.to_s.constantize
  end

  def table_name
    model_class.table_name
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
    self.class_name = name.to_s.singularize.camelcase
    self.foreign_key = (self_class_name.underscore + "_id").to_sym
    self.primary_key = "id".to_sym

    options.each do |option, value|
      self.send("#{option}=", value)
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      foreign_key_value = self.send(options.foreign_key)
      target_class = options.model_class
      target_class.where(id => foreign_key_value).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      primary_key_value = self.send(options.primary_key)
      target_class = options.model_class
      target_class.where(options.foreign_key => primary_key_value)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
