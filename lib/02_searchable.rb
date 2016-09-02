require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key.to_s} = ?"}.join(" AND ")
    param_values = params.values
    debugger
    parse_all(DBConnection.execute(<<-SQL, param_values.flatten))
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

  end
end

class SQLObject
  extend Searchable
end
