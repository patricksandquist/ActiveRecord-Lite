require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    self.class_name = name.to_s.camelcase
    self.foreign_key = "#{name}_id".to_sym
    self.primary_key = :id

    options.each do |option, value|
      self.send("#{option}=", value)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.class_name = name.to_s.singularize.camelcase
    self.foreign_key = "#{self_class_name.underscore}_id".to_sym
    self.primary_key = :id

    options.each do |option, value|
      self.send("#{option}=", value)
    end
  end
end
