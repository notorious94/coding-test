# SEEDRS CODING TEST
Coding test taken by Seedrs which asked to design a backend data model of a mini Seedrs. Main objective was to build an API for fetching data of the Campaigns and another API to let user create an investment for a particulaar campaign. Expected behaviour also needed to be tested using any of the test suite like RSPEC.


# Approach

At first I created the Campaign model with attributes mentioned in the question. Then I used grape gem to setup the environment for the APIs. Since Campaign data can be very big I used will_paginate gem for pagination. Params ``` per_page ``` and ``` page_no ``` are used to set the data limit and to mention the page number accordingly. By default they will be set to 1 and 10 accordingly. In Strech#2 it was mentioned that there can be search params as well. So I have included the search param in the API as an optional parameter. It will help the user to search for Campaigns which matches the search string.  

Since the campaign data is not public therefor to authenticate the API call JWT token and API access token were used to 
ensure data security.


For the investment API I had to be cautions about multiple corner cases like invalid user_id, or invalid campaign_id. Also the amount of investment for a certain campaing has to be the multiple of that campaigns investment_multiple. If all the checking gets passed the system lets the user invest to a certain campaign.

ActiveRecordSerializer is used to serialize the model objects.

RSPEC has been used to test all the APIs.

# HOW TO RUN
```bash
git clone git@github.com:notorious94/coding-test.git
cd coding-test
cp .env.sample .env
rails db:create
rails db:migrate
rails db:seed
```

After running the server please open-up the API collection in Postman and request for a sign-in. A valid credential is already given. A JWT token will be generated everytime a user requests for a sign in and sign-out. All the older version of the token will get expired after it.

# API COLLECTION
Postman Collection url: https://www.getpostman.com/collections/93b7e87333cd6b9a9c8f

# TESTING

For running the test examples simply run the command below.

```bash
rspec
```

# Note

* User Credentials
  * Email: user@admin.com
  * Password: 123456
  