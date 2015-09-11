require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    arr = DBConnection::execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    arr[0].map { |name| name.to_sym }
  end

  def self.finalize!
    self.columns.each do |column|
      define_method column do
        attributes[column]
      end

      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection::execute(<<-SQL)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |hash| self.new(hash) }
  end

  def self.find(id)
    result = DBConnection::execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      id = ?
    SQL

    return nil if result.empty?
    self.new(result[0])
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      column_array = self.class.columns

      raise "unknown attribute '#{attr_name}'" unless column_array.include?(attr_name)

      column_array.each do |column|
        if column == attr_name
          self.send("#{attr_name}=", value)
        end
      end
    end

    self
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |column| self.send(column) }
  end

  def insert
    col_names = "(#{self.class.columns.join(", ")})"
    question_marks = "(#{(["?"] * self.class.columns.length).join(', ')})"
    DBConnection::execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} #{col_names}
    VALUES
      #{question_marks}
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = "#{self.class.columns.join(" = ?, ")} = ?"
    DBConnection::execute(<<-SQL, *attribute_values, self.id)
    UPDATE
      #{self.class.table_name}
    SET
      #{col_names}
    WHERE
      id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
end
