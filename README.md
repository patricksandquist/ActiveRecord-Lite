# ActiveRecord-Lite
An ORM inspired by the functionality of ActiveRecord

### Motivation
To better understand how Ruby on Rails' ActiveRecord methods are converted into SQL queries.

### Features
+ ::attr_accessor
+ SQLObject
  + ::all
  + ::find
  + #insert
  + #update
  + #save
  + #table_name=
  + #columns
  + #finalize!
  + #initialize
+ Searchable
  + ::where
+ Associatable
  + belongs_to
  + has_many
  + has_one_through
