require 'active_support/inflector'

class Datum

  def self.columns
    if @columns
      @columns
    else
      columns = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
            #{table_name}
        LIMIT
          0
      SQL
      @columns = columns.first.map(&:to_sym)
      end
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") { |value| attributes[column] = value }
      define_method("#{column}") { attributes[column] }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.to_s.tableize
  end

  def self.all
    self.parse_all(DBConnection.execute(<<-SQL))
    SELECT
      *
    FROM
      #{table_name}
    SQL

  end

  def self.parse_all(results)
    results.map { |instance| self.new(instance) }
  end

  def self.find(id)
    parse_all(DBConnection.execute(<<-SQL, id)).first
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL
    # self.new(object.first) unless object.empty?
  end

  def initialize(params = {})
    params.each do |name,value|
      if self.class.columns.include?(name.to_sym)
        self.send("#{name}=", value)
      else
        raise "unknown attribute '#{name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def insert
    col_names = self.class.columns[1..-1].join(", ")
    question_marks = (["?"] * (self.class.columns.length - 1))


    DBConnection.execute(<<-SQL, attribute_values)
      INSERT INTO
      #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks.join(", ")})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns[1..-1].map { |column| "#{column} = ?"}.join(", ")
    question_marks = (["?"] * (self.class.columns.length - 1))
    attr_values = attribute_values
    attr_values << attr_values.shift

    DBConnection.execute(<<-SQL, attr_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        #{self.id} = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
