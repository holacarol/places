# PostgreSQLAdapter patch


#ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
#  def tables(name = nil)
#    query("SELECT tablename FROM pg_tables WHERE schemaname = ANY (current_schemas(false))", name).map{|row| row[0]}
#  end
#end