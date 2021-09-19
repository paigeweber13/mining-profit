module DBTools

using SQLite
using Tables


function loadorcreatedb()
  db = SQLite.DB("historical-data.sqlite")

  tables = SQLite.tables(db)
  println(tables)
  println(tables[1])
  #println(size(tables))
  println(size(tables[1]))
  println(tables.name)
  println(size(tables.name))

  if size(tables.name) == (0,)
    println("There appears to be no existing data, creating new tables...")
    schema_miningstats = Tables.Schema(
      ["id", "pool", "datetime", "hashrate", "balance"],
      [Int, String, String, Float64, Float64]
    )
    SQLite.createtable!(db, "mining_stats", schema_miningstats)
    # DBInterface.execute(db, """
    #   CREATE TABLE mining_stats(
    #     id INTEGER NOT NULL PRIMARY KEY,
    #     pool TEXT NOT NULL,
    #     datetime TEXT NOT NULL,
    #     hashrate REAL,
    #     balance REAL
    #   )
    # """)
  end

  return db
end

end # module
