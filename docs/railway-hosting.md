# Hosting LegSim on Railway

Cloudflare Pages is only a static/Workers host, so it cannot run this Rails app directly. Use Railway for the Rails web process, MySQL, Redis, and the Sidekiq worker.

## Services

Create one Railway project with these services:

1. MySQL database
2. Redis database
3. Web service from this GitHub repository
4. Worker service from the same GitHub repository

Railway will use the root `Dockerfile` and `railway.toml` in this repo.

## Adding services after repo import

If you already created a project from the repo root, Railway created only the Rails web service. To add the rest:

1. Open the project and go back to the project canvas, where you can see the service tile for this repo.
2. Click `+ New` in the top right of the canvas, or press `Cmd + K` / `Ctrl + K`.
3. Choose `Database`, then choose `MySQL`.
4. Click `+ New` again, choose `Database`, then choose `Redis`.
5. Click `+ New` again, choose `GitHub Repo`, select this same repo, and name that service `worker`.
6. Click `Deploy` / `Apply Changes` if Railway shows staged changes.

## Web service variables

Set these variables on the Rails web service. If your Railway database service names are not exactly `MySQL` and `Redis`, adjust the reference namespace.

```text
RAILS_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true
SECRET_KEY_BASE=<generate with: openssl rand -hex 64>

MYSQLHOST=${{MySQL.MYSQLHOST}}
MYSQLPORT=${{MySQL.MYSQLPORT}}
MYSQLUSER=${{MySQL.MYSQLUSER}}
MYSQLPASSWORD=${{MySQL.MYSQLPASSWORD}}
MYSQLDATABASE=${{MySQL.MYSQLDATABASE}}

REDIS_URL=${{Redis.REDIS_URL}}
```

If Railway exposes one MySQL URL, you can set this instead of the five separate MySQL variables:

```text
MYSQL_URL=${{MySQL.MYSQL_URL}}
```

The app also accepts `DATABASE_URL`, `MYSQL_PRIVATE_URL`, `DATABASE_PRIVATE_URL`, `MYSQL_PUBLIC_URL`, or `DATABASE_PUBLIC_URL` if those are the URL names your MySQL service exposes.

If `REDIS_URL` resolves to an empty value, open the Redis service in Railway and copy its Redis connection variable from that service's `Variables` tab. Paste that exact reference into both the web and worker services. The service may have a different name than `Redis`, and the variable may be named differently depending on the Railway Redis template.

If Railway exposes Redis as separate fields instead of one URL, set these on both web and worker services:

```text
REDISHOST=${{Redis.REDISHOST}}
REDISPORT=${{Redis.REDISPORT}}
REDISUSER=${{Redis.REDISUSER}}
REDISPASSWORD=${{Redis.REDISPASSWORD}}
```

Optional but usually needed:

```text
APP_HOST=<your custom hostname, for example legsim.example.org>
MAILER_DOMAIN=legsim.org
GMAIL_USER_NAME=<gmail smtp username>
GMAIL_PASSWORD=<gmail app password>
ELAVON_PRODUCTION_LOGIN=<elavon login>
ELAVON_PRODUCTION_USER=<elavon user>
ELAVON_PRODUCTION_PASSWORD=<elavon password>
```

## Web service settings

The repo config already sets:

```text
Build: Dockerfile
```

The Dockerfile default start command is:

```text
bundle exec puma -C config/puma.rb
```

Set the web service pre-deploy command to:

```text
bin/rails db:prepare
```

Set the web service healthcheck path to:

```text
/health
```

Generate a public Railway domain in the web service Networking tab. For a custom domain, set `APP_HOST` to that exact host and add the DNS record Railway gives you.

## Worker service settings

Create another service from the same repo for Sidekiq. Give it the same variables as the web service, then override the start command:

```text
bundle exec sidekiq -C config/sidekiq.yml
```

The worker does not need a public domain.
Do not set a healthcheck path on the worker service.

## First admin account

After the first deploy and migration succeed, open a Rails console in Railway and create a system user:

```ruby
SystemUser.create!(
  email: "admin@example.com",
  password: "replace-me",
  password_confirmation: "replace-me"
)
```

Then visit `/system` on the deployed site.

## Notes

Uploaded files currently use local Active Storage. That is OK for a first deploy, but files may be lost when the container is replaced unless you attach persistent storage or move Active Storage to S3-compatible storage such as Cloudflare R2.

## If a deployment fails

Open the failed service tile, then open the latest failed deployment logs. Check whether the failure happened in `Build Logs` or `Deploy Logs`.

Common fixes:

```text
Missing `secret_key_base` for 'production' environment
```

Set `SECRET_KEY_BASE` on the crashed service. Generate it locally with `openssl rand -hex 64`, or use Railway's variable generator.

In Railway, open the crashed Rails service, go to `Variables`, add `SECRET_KEY_BASE`, paste the generated value, save, then redeploy. Set it on the worker service too if you deploy Sidekiq from the same Rails app.

```text
Missing encryption key to decrypt file with
```

Set `RAILS_MASTER_KEY` if you are deploying with `config/credentials.yml.enc`. If you are using environment variables instead, make sure the corresponding env vars are set so the app does not need encrypted credentials at boot.

```text
Connection refused - connect(2) for 127.0.0.1:6379
```

The service is trying to use local Redis. Make sure `REDIS_URL=${{Redis.REDIS_URL}}` is set on both web and worker services.

If Railway exposes separate Redis variables instead, set `REDISHOST`, `REDISPORT`, `REDISUSER`, and `REDISPASSWORD` on the crashed service.

```text
Invalid URL: ""
```

`REDIS_URL` is set to a blank value. Replace it with the Redis service reference from Railway, or delete the blank value while debugging.

```text
Mysql2::Error::ConnectionError
```

Make sure the MySQL service exists, then verify the `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, and `MYSQLDATABASE` variables are set on the web service. If your database service is not named `MySQL`, update the variable references to match the real service name.

```text
Can't connect to local MySQL server through socket '/run/mysqld/mysqld.sock'
```

The Rails service did not receive a MySQL host, so the MySQL client tried the container's local socket. Set `MYSQL_URL=${{MySQL.MYSQL_URL}}`, or set all five separate `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, and `MYSQLDATABASE` variables on the web service. Set them on the worker too because Sidekiq jobs boot Rails models.

```text
Table '...' doesn't exist
```

Set the web service pre-deploy command to `bin/rails db:prepare`, then redeploy the web service.
