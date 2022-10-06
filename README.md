# Getting Started
  
* Clone this repo
* `bundle install`
* `bundle exec figaro install`
* `rails db:{create,migrate}`
* Get API key:
  * [NREL Developer Signup](https://developer.nrel.gov/signup/)
* Store your key in application.yml
  * nrel_api_key: your_key
* From your terminal, run `rails s`
* Open a browser to `http://localhost:3000/`
* Enter an address into the search field, hit enter
* Click a column name to sort by that field, click again to reverse order

## Future feature
* Add an arrow to designate whether column is currently sorted by ascending / descending
