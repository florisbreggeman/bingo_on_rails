# Bingo on Rails

A small Ruby on Rails application made as a technical assesment.
You can create bingo cards and fill them in the browser.

## Features:

The core of the application is the bingo card.
This is a 5 by 5 matrix of bingo fields.
When you click on a bingo field, an image will appear in the background of the field to indicate you have filled the field.

Furthermore, we support the following features:

### Persistence

When you first load a bingo card, the fields of the card are ordered randomly.
This ordering is then stored in a cookie, so you can't cheat fate by refreshing the page :).
The information will be preserved until you alter the page, or until the card creator adds or removes a field.

Whether you have filled a field is stored in the local storage of your browser.
This information persists even if the cookie storing your card sequence is cleared.

### Creating and Editing Cards

When you log in, you can create new cards with the "New Card" button in the menu.
Once you have filled in a card and configured a custom text in the free space, you can add fields.
You must add at least 24 fields for the card to be playable.
If you add more fields, players will be shown the first 24 random fields.

You can change the title and free space of the card, and add, remove, or edit fields at any time.
Please note that, when editing a field, the change will be propagated as soon as you press the button or hit enter, even if you receive no visible feedback.

### User account creation

When you install the application, the "admin" user is created by default.
This user has the username "admin" and the password "Welcome123!".
Unfortunately, while multi-user support is present, it is not yet possible to add new users or change passwords through other means than the console.

To add a user via the console, run `bin/rails console' and type the following:

```ruby
user = User.new
user.username = <username>
user.name = <display name>
user.password = <password, in plain text>
use.save
```

To edit the password of the default administrator, run `bin/rails console` and type the following:

```ruby
user = User.find(1)
user.password = <new password>
user.save
```

## Installation

To try the application locally, simply:

1. Clone this repository.
2. Run `bundle install` to get the dependencies.
3. Change `config/database.yml`, see [the relevant Ruby on Rails documentation](https://ruby-on-rails-documentation.github.io/database/Configurations.html) (unless you have a mysql/mariadb instance on your machine ;).
4. Run `bin/rails server`.

You can then access the application via `localhost:3000`.

To deploy the application on a Linux server:

### Acquiring

In order to ensure all the files and dependencies you need are present:

1. Install `ruby` and `bundle` via your distribution's package manager.
2. Clone or copy this repository into a directory of your choice, e.g. `/opt/bingo_on_rails` as an example.
3. Create a dedicated user for the application, e.g. `bingo_on_rails`.
4. Ensure the dedicated user you just created is the only user with write access to your application directory.
5. As the dedicated user, `cd` to the application directory and run `bundle config set --local path 'vendor/bundle; bundle install` to fetch dependencies.

### Setting up the Database

1. Install your favourite PostgreSQL or MySQL server
2. Create 4 databases:
    1. `bingo_on_rails_production`
    2. `bingo_on_rails_production_queue`
    3. `bingo_on_rails_production_cache`
    4. `bingo_on_rails_production_cable`
3. Create a database user with full privileges on all of these databases
4. Update `config/database.rb`:
    1. Enter the correct connection details and credentials at the top of the file
    2. Comment out the "development" configuration
    3. Uncomment the "production" configuration near the bottom of the file, and make any adjustments that may be necessary
5. As the dedicated user, run `bundle exec rails db:migrate`

At this point, you can (as the dedicated user) run `RAILS_ENV=production bundle exec rails server` to test your work.
If you have configured everything correctly, the above should not indicate any errors, and running `wget localhost:3000` while the server is running should return an `index.html` page.

### Daemonising the Server

*NB*: all of the following must be done as root!

You can daemonise the server using systemd with the following configuration file, [per the Puma documentation](https://puma.io/puma/file.systemd.html).
Paste the following in `/etc/systemd/system/bingo_on_rails.service`:

```conf
[Unit]
Description=Bingo on Rails server
After=network.target

[Service]
Type=notify
User=<dedicated user>

WorkingDirectory=<application directory>
Environment="RAILS_ENV=production"
ExecStart=/usr/local/bin/bundle exec puma -C config/puma.rb -b <bind target>
# Before starting, compile static assets; allows for download-and-restart updating.
ExecStartPre=/usr/local/bin/bundle exec rake assets:precompile

[Install]
WantedBy=multi-user.target
```

[See the Puma documentation for options for the `<bind target>`](https://github.com/puma/puma#binding-tcp--sockets). I recommend binding to a Unix socket for security reasons.

In order to start the service, use `systemctl daemon-reload; systemctl start bingo_on_rails`.
Use `journalctl -u bingo_on_rails` to get logging.

### Reverse Proxy Configuration

Finally, configure your favourite reverse proxy to pass the requests on:

- First try `<application directory>/public` for any direct files.
- If that did not work, pass the requests on the socket created in the previous section.
- Be sure to set the required headers for security:
  - Host
  - X-Forwarded-For
  - X-Forwarder-Proto
  - X-Real-Ip

For example, here is my nginx configuration:

```conf
upstream bingo {
        server unix:///var/run/bingo/bingo_on_rails.sock;
}

server {
        listen [::]:443 ssl ipv6only=on; 
        listen 443 ssl;
        server_name bingo.sfbtech.nl;

        location / {
                # First look in /public, then pass to the socket
                root /opt/bingo_on_rails/public;
                try_files $uri @app;
        }

        location @app {
                proxy_pass http://bingo;
                proxy_set_header X-Real-Ip $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Host $http_host;
                proxy_redirect off;
                proxy_next_upstream error timeout invalid_header http_502;
        }
}

```

## Roadmap

### Must Have

- Account Managament
  - Change own password
  - Distinguish between admin/non-admin users
  - Add/remove users
  - Set users to admin/non-admin
  - Password recovery (via administrative password reset)
- Giving the user feedback when editing a field has taken effect

### Should Have

- Splitting javascript over multiple files
- Splitting CSS over multiple files, and only including those which are necessary for a given page
- Better redirects for the logout button

### Wishlist

- Javascript which sprays confetti when you get bingo
- Sending a notification to all concurrent viewers of a card when one player gets bingo
  - Possible using websockets?

## Use of Generative AI

No Generative AI was used in the creation of this codebase.
