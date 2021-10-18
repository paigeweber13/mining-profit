module DBTools

using Dates
using Printf
using SQLite
using Tables

TABLE_NAME = "mining_stats"
DATETIME_FORMATSTRING = "YYYY-mm-dd HH:MM:SS"
ERROR_UNHANDLED_SQLITE_EXCEPTION = 1

function loadorcreatedb()
  db = SQLite.DB("historical-data.sqlite")

  try
    DBInterface.execute(db, "SELECT pool FROM " * TABLE_NAME)
  catch e
    if e == SQLite.SQLiteException("no such table: mining_stats")
      println("There appears to be no existing data, creating new tables...")
      schema_miningstats = Tables.Schema(
        ["pool", "datetime", "hashrate", "balance"],
        [String, String, Float64, Float64]
      )
      SQLite.createtable!(db, TABLE_NAME, schema_miningstats)
    else
      println("ERROR: unhandled sqlite exception: ")
      println(e)
      exit(ERROR_UNHANDLED_SQLITE_EXCEPTION)
    end
  end

  return db
end

function insertminingdata(db, pool, datetime, hashrate, balance)
  qs = @sprintf("INSERT INTO %s VALUES ('%s', '%s', '%s', '%s');", TABLE_NAME,
    pool, datetime, hashrate, balance)

  DBInterface.execute(db, qs)
end

"""
One example of how this can be used: 
DBTools.getdata(db, "ezil", Dates.DateTime(2021, 09, 24, 14), 
  Dates.DateTime(2021, 09, 24, 15))
"""
function getdata(db::SQLite.DB, pool::String, time_start::Dates.DateTime, 
    time_end::Dates.DateTime)
  qs = @sprintf("""
    SELECT * FROM '%s' WHERE pool = '%s' AND datetime >= '%s'
    AND datetime <= '%s';
    """,
    TABLE_NAME, pool, Dates.format(time_start, DATETIME_FORMATSTRING),
    Dates.format(time_end, DATETIME_FORMATSTRING)
    )
  return DBInterface.execute(db, qs)
end

function migratedb(inputdb, outputdb_name)
  outputdb = SQLite.DB(outputdb_name)

  schema_miningstats = Tables.Schema(
    ["pool", "datetime", "hashrate", "balance"],
    [String, String, Float64, Float64]
  )
  SQLite.createtable!(outputdb, TABLE_NAME, schema_miningstats)

  qs = @sprintf("SELECT * FROM %s;", TABLE_NAME)
  result = DBInterface.execute(inputdb, qs)

  for row in result
    newdate = Dates.DateTime(row.datetime, "YYYY-mm-dd_HHMM")
    newdatestring = Dates.format(newdate, DATETIME_FORMATSTRING)
    qs = @sprintf("INSERT INTO %s VALUES ('%s', '%s', '%s', '%s');", 
      TABLE_NAME, row.pool, newdatestring, row.hashrate, row.balance)
    DBInterface.execute(outputdb, qs)
  end
end

end # module
