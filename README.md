# TwoDbTest

This is a dummy repo to document how you can connect multiple databases to a single Phoenix server. You can follow the commits or the steps provided here.

> 📗\
 This repo can get obsolete as Phoenix/Elixir maintainers change Ecto and its related functionality.

## Commit #1

**Init**: Initialize the Phoenix repo using `mix phx.new two_db_test` and push it to GitHub. No config changes in this commit.

## Commit #2

**Configure MySQL with Phoenix**: By default, Phoenix creates a repo with Postgres drivers. I'll be using MySQL (since that's what I need at work too and hence this project 😜). So I'll have to replace the Postgres driver with MySQL driver. To do this:

1. We'll replace `:postgrex` with `:myxql` in `mix.exs` file.
  ElixirLS will freak out (if you use it) but you can run `mix deps.get` to fix it. ![ElixirLS doesn't like that you replaced `postgrex` with `myxql`](assets/screenshots/angry_elixirLS.png)

2. We need to configure the repos. In Phoenix, repo == database. Tables will be created under the repo (database.) In Phoenix, the repo is specified in the `config.exs` file. But if you see, a repo is already specified there.\
![phoenix repos](assets/screenshots/repos.png)\
That's because when you create a new Phoenix project using `mix phx.new <project>`, it takes care of the scaffolding. Also note that the `ecto_repos` property of the `config/2` function takes an array, which indicates that Phoenix supports multiple repos. We'll need that later.\
However, we'll have to tweak this a bit since we'll be using two databases. In the folder hierarchy, you can see that the `repo.ex` file is created under `lib/two_db_test`.\
![phoenix mysql repo](assets/screenshots/repo_mysql_config.png)\
Since we'll be using two databases, I'll organize the files and folders a bit. I'll create a folder called `repo` under `lib/two_db_test` and move `repo.ex` under the folder. In addition, I'll rename the file `repo.ex` to `mysql.ex` so that we can later differentiate which database Phoenix should talk to. It'll be easier to use in the code too (we'll get to that in a bit).\
![phoenix mysql repo](assets/screenshots/mysql_repo.png)\
To stick to the convention, I'll modify the file. Currently, it looks like:

    ```elixir
    defmodule TwoDbTest.Repo do
      use Ecto.Repo,
        otp_app: :two_db_test,
        adapter: Ecto.Adapters.Postgres
    end
    ```

    We'll change it to:

    ```elixir
    defmodule TwoDbTest.Repo.MySql do
      use Ecto.Repo,
        otp_app: :two_db_test,
        adapter: Ecto.Adapters.MyXQL
    end
    ```

    I have changed the module name to match the folder hierarchy. In addition, we have changed the adapter to `MyXQL` since we'll be using MySQL as our database instead of Postgres.

    However, now since the repo's configuration lives in the `TwoDbTest.Repo.MySql` module, we need to go back to `config.exs` and tell Phoenix that it should look for the repo's configuration in the new module.

    So we'll change:

    ```elixir
    config :two_db_test,
      ecto_repos: [TwoDbTest.Repo]
    ```

    to:

    ```elixir
    config :two_db_test,
      ecto_repos: [TwoDbTest.Repo.MySql]
    ```

    The next step would be to tell Phoenix what should be the name of the database in MySQL under which it should create tables and add data to it. Since Phoenix separates the operation modes as dev, test, and prod, it provides a script(`.exs`) file for each mode. Since I'll be only running Phoenix in dev mode on my laptop for this exercise, we'll specify the database name in the `dev.exs` file only.

    In the `dev.exs` file, I'll change:

    ```elixir
    config :two_db_test, TwoDbTest.Repo,
      username: "postgres",
      password: "postgres",
      database: "two_db_test_dev",
      hostname: "localhost",
      show_sensitive_data_on_connection_error: true,
      pool_size: 10
    ```

    to:

    ```elixir
    config :two_db_test, TwoDbTest.Repo.MySql,
      username: "root",
      password: "",
      database: "two_db_test_dev",
      hostname: "localhost",
      show_sensitive_data_on_connection_error: true,
      pool_size: 10
    ```

    Note that I have changed the name of the module (the second property that we send to the `config/3` function), and changed the username and password properties according to the default MySQL settings. I am leaving the database name as it is. In addition, I'm leaving hostname as it is too since the MySQL instance is running locally. I am not sure about the remaining two properties, so I'm leaving those two as it is.

    At this point, we can run `mix ecto.setup`. It should create the `two_db_test_dev` database in our MySQL instance. To learn more about what `mix ecto.setup` does, you can take a look at Mix's documentation. In addition, its alias is specified in the `mix.exs` file at the bottom. It tells you the commands mix will run when you run `mix ecto.setup`. As a quick reference, `mix ecto.setup` runs:

    - `ecto.create`: It'll connect to the database instances and create the repos that you specify in the `config.exs` file. Remember that it's an array. If you have more than one repos configured, Phoenix will create both the repos in the instances of all the databases that you connect. We'll get to that in a bit.
    - `ecto.migrate`: It'll run migration on the databases that you configured (such as adding tables to the database, updating tables etc.) We'll get to that in a bit.
    - `run priv/repo/seeds.exs`: If you have sample data that your tables should be populated with, you can use this file to provide the data

    As expected, when we run `mix ecto.setup`, mix can create the database in MySQL.\
    ![phoenix mysql repo creates database](assets/screenshots/mysql_db_created.png)\

## To start your Phoenix server

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
