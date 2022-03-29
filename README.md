# README
# Fetch Rewards Coding Exercise - Backend Software Engineering

## Description

Our users have points in their accounts. Users only see a single balance in their accounts. But for reporting purposes we actually track their
points per payer/partner. In our system, each transaction record contains: payer (string), points (integer), timestamp (date).
For earning points it is easy to assign a payer, we know which actions earned the points. And thus which partner should be paying for the points.
When a user spends points, they don't know or care which payer the points come from. But, our accounting team does care how the points are
spent. 

## Requirements and Setup (for Mac):

### Ruby and Rails
- Ruby Version 2.7.2
- Rails Version 5.2.6

### Database
- Sqlite3

### Gems Utilized
- RSpec 
- Pry
- SimpleCov
- Capybara
- Shoulda-Matchers 
- jsonapi-serializer
- rspec_junit_formatter
- Orderly
- launchy

## Setup
1. Clone this repository:
On your local machine open a terminal session and enter the following commands for SSH or HTTPS to clone the repositiory.


- using ssh key <br>
```shell
$ git clone git@github.com:dkassin/fetch_rewards_challenge.git
```

- using https <br>
```shell
$ git clone https://github.com/dkassin/fetch_rewards_challenge.git

Once cloned, you'll have a new local copy in the directory you ran the clone command in.

2. Change to the project directory:<br>
In terminal, use `$cd` to navigate to the fetch_rewards_challenge Application project directory.

```shell
$ cd fetch_rewards_challenge
```

3. Install required Gems utilizing Bundler: <br>
In terminal, use Bundler to install any missing Gems. If Bundler is not installed, first run the following command.

```shell
$ gem install bundler
```

If Bundler is already installed or after it has been installed, run the following command.

```shell
$ bundle install
```

There should be be verbose text diplayed of the installation process that looks similar to below. (this is not an actual copy of what will be output).

```shell
$ bundle install
Using rake 13.0.6
Using concurrent-ruby 1.1.9
Using i18n 1.9.1
Using minitest 5.15.0
Using thread_safe 0.3.6
Using tzinfo 1.2.9
Using activesupport 5.2.6
Using builder 3.2.4
Using erubi 1.10.0
Using mini_portile2 2.7.1
Using racc 1.6.0
Using nokogiri 1.13.1
Using rails-dom-testing 2.0.3
Using crass 1.0.6
Using loofah 2.13.0
Using rails-html-sanitizer 1.4.2
Using actionview 5.2.6
Using rack 2.2.3
Using rack-test 1.1.0
Using actionpack 5.2.6
Using nio4r 2.5.8
Using websocket-extensions 0.1.5
Using websocket-driver 0.7.5
Using actioncable 5.2.6
Using globalid 1.0.0
Using activejob 5.2.6
Using mini_mime 1.1.2
Using mail 2.7.1
Using actionmailer 5.2.6
Using activemodel 5.2.6
Using arel 9.0.0
Using activerecord 5.2.6
Using marcel 1.0.2
Using activestorage 5.2.6
Using msgpack 1.4.4
Using bootsnap 1.10.3
Using bundler 2.1.4
Using byebug 11.1.3
Using coderay 1.1.3
Using diff-lcs 1.5.0
Using docile 1.4.0
Using factory_bot 6.2.0
Using method_source 1.0.0
Using thor 1.2.1
Using railties 5.2.6
Using factory_bot_rails 6.2.0
Using faker 2.19.0
Using ffi 1.15.5
Using jsonapi-serializer 2.2.0
Using rb-fsevent 0.11.1
Using rb-inotify 0.10.1
Using ruby_dep 1.5.0
Using listen 3.1.5
Using pg 1.3.1
Using pry 0.14.1
Using puma 3.12.6
Using sprockets 4.0.2
Using sprockets-rails 3.4.2
Using rails 5.2.6
Using rspec-support 3.10.3
Using rspec-core 3.10.2
Using rspec-expectations 3.10.2
Using rspec-mocks 3.10.3
Using rspec-rails 5.1.0
Using shoulda-matchers 5.1.0
Using simplecov-html 0.12.3
Using simplecov_json_formatter 0.1.3
Using simplecov 0.21.2
Using spring 2.1.1
Using spring-watcher-listen 2.0.1

If there are any errors, verify that bundler, Rails, and your ruby environment are correctly setup.

4. Database Migration<br>
Before using the web application you will need to setup your databases locally by running the following command

```shell
$ rails db: {:create, :migrate}
```


5. Startup and Access<br>
Finally, in order to use the web app you will have to start the server locally and access the app through a web browser. 
- Start server
```shell
$ rails s
```

- Open web browser and visit link
    http://localhost:3000/
    
At this point you should be taken to a page with an example JSON response for a user

## Endpoints provided 
```
** For the following endpoints must send a JSON payload in the body of the request **

- POST /api/v1/users/add_transactions
  Content-Type: application/json
  Accept: application/json
     
● { "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z" }

- POST /api/v1/users/spend_points
  Content-Type: application/json
  Accept: application/json

  { "points": 100 }

- GET /api/v1/users/points_balance
  Content-Type: application/json
  Accept: application/json

```
### example successful response for POST /api/v1/users/add_transactions

![Screen Shot 2022-03-29 at 3 34 48 PM](https://user-images.githubusercontent.com/76177498/160711160-4021f645-f4c7-4e3a-9823-2bff15651d95.png)

### example successful response for POST /api/v1/users/spend_points
![Screen Shot 2022-03-29 at 3 15 57 PM](https://user-images.githubusercontent.com/76177498/160711424-cba19d5f-3a1f-4987-a225-2957bd714677.png)

### example successful response for GET /api/v1/users/points_balance

![Screen Shot 2022-03-29 at 3 15 48 PM](https://user-images.githubusercontent.com/76177498/160711318-43e8d382-0c0d-4455-bb62-2ff8ab854287.png)

### Attached is a zipfile of a postman collection for testing:

[Fetch Rewards.postman_collection.json.zip](https://github.com/dkassin/fetch_rewards_challenge/files/8375083/Fetch.Rewards.postman_collection.json.zip)

## **Contributors** ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
      <td align="center"><a href="https://github.com/dkassin"><img src="https://avatars.githubusercontent.com/u/76177498?v=4" width="100px;" alt=""/><br /><sub><b>David(he/him)</b></sub></a><br /><a href="https://github.com/dkassin/sweater_weather/commits?author=dkassin" title="Code">💻</a> <a href="https://github.com/dkassin/sweater_weather/pulls?q=is%3Apr+author%3Adkassin" title="Reviewed Pull Requests">👀</a>
    </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.
<!--





