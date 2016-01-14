# ActiveRecord-Lite
An ORM inspired by the functionality of ActiveRecord

### Motivation
To better understand how Ruby on Rails' ActiveRecord methods are converted into SQL queries.

### Features
+ `::attr_accessor`
+ `SQLObject`
  + `::all`
  + `::find`
  + `#insert`
  + `#update`
  + `#save`
  + `#table_name=`
  + `#columns`
  + `#finalize!`
  + `#initialize`
+ `Searchable`
  + `::where`
+ `Associatable`
  + `belongs_to`
  + `has_many`
  + `has_one_through`

### Example usage
```ruby
BigDog.table_name # => "big_dogs"

class Cat < SQLObject
  belongs_to :human, :foreign_key => :owner_id
  has_one_through :home, :human, :house

  finalize!
end

c = Cat.new
c.name = "Gizmo"
c.owner_id = 123

c.name #=> "Gizmo"
c.owner_id #=> 123

class Human < SQLObject
  self.table_name = "humans"

  belongs_to :house

  finalize!
end

class House < SQLObject
  finalize!
end

human_options = Cat.assoc_options[:human]
human_options.foreign_key # => :owner_id
human_options.class_name # => "Human"
human_options.primary_key # => :id

cat.home # => house the cat's owner lives in.
```

### License
ActiveRecord-Lite is released under the [MIT License](http://www.opensource.org/licenses/MIT).
