{application,task_management,
             [{applications,[kernel,stdlib,elixir,logger,poison,cowboy,
                             plug_cowboy,jsonapi,mongodb,timex,joken,
                             pbkdf2_elixir,elixir_uuid,amqp]},
              {description,"task_management"},
              {modules,['Elixir.Api.Helpers.EventBus',
                        'Elixir.Api.Helpers.MapHelper',
                        'Elixir.Api.JwtValidation','Elixir.Api.Models.Base',
                        'Elixir.Api.Models.Task','Elixir.Api.Plugs.AuthPlug',
                        'Elixir.Api.Plugs.JsonTestPlug','Elixir.Api.Router',
                        'Elixir.Api.Service.Auth','Elixir.Api.TaskEndpoint',
                        'Elixir.Api.Token','Elixir.Api.Views.TaskView',
                        'Elixir.TaskManagement',
                        'Elixir.TaskManagement.Application']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.TaskManagement.Application',[]}}]}.