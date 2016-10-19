require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key.to_s} = ?"}.join(" AND ")
    parse_all(DBConnection.execute(<<-SQL, params.values.flatten))
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

  end
end

class Datum
  extend Searchable
end
