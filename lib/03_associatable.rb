require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class

  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    if options[:class_name].nil?
      @class_name = name.camelcase
    else
      @class_name = options[:class_name]
    end
    if options[:foreign_key].nil?
      @foreign_key = (name.underscore + "_id").to_sym
    else
       @foreign_key = options[:foreign_key]
    end
    if options[:primary_key].nil?
      @primary_key = :id
    else
      @primary_key = options[:primary_key]
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    if options[:class_name].nil?
      @class_name = name.singularize.camelcase
    else
      @class_name = options[:class_name]
    end
    if options[:foreign_key].nil?
      @foreign_key = (self_class_name.underscore + "_id").to_sym
    else
       @foreign_key = options[:foreign_key]
    end
    if options[:primary_key].nil?
      @primary_key = :id
    else
      @primary_key = options[:primary_key]
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
