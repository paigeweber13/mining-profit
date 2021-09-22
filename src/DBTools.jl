module DBTools

using Printf
using SQLite
using Tables

TABLE_NAME = "mining_stats"
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
      SQLite.createtable!(db, "mining_stats", schema_miningstats)
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

end # module
