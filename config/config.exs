import Mix.Config

config :task_management,
       db_host: "localhost",
       db_port: 27017,
       db_db: "stud-money",
       db_tables: [
         "tasks"
       ],
       api_host: "localhost",
       api_port: 5000,
       api_scheme: "http",
       app_secret_key: "secret",
       jwt_validity: 3600
