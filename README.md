# manage_services

Manage system services through attributes while providing all [service resource](https://docs.chef.io/resource_service.html) options provided by Chef. 

---


## Usage

### manage_services::default

Just include `manage_services` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[manage_services]"
  ]
}
```

Then move on to filling out some attributes.

## Attributes

### Ignore Failures

This set the ignore_failures default value for each service you define.

Default Value: 

- `false`

Ruby usage:

```ruby
node['manage_services']['ignore_failures'] = true
```

JSON usage:

```json
{
  "manage_services": {
    "ignore_failures": true
  }
}
```

### Services

The set of services that you intend to manage.


Ruby usage:

```ruby
node['manage_services']['services'] = [
    "nscp" => [
      "action" => ['enable', 'start'],
      "ignore_failure" => false, # Overriding the global settings set earlier
      "retries" => 3,
      "retry_delay" => 5,
      "timeout" => 30,
      "notifies" => [
        "action" => "some_action",
        "resource" => "some[resource]",
        "timer" => "immediate"
      ],
      "subscribes" => [
        "action" => "some_action",
        "resource" => "some[resource]",
        "timer" => "immediate"
      ],
      "supports" => [
        "restart" => false,
        "reload" => false,
        "status" => true
      ]
    ]
]
```

JSON usage:

```json
{
  "manage_services": {
    "services": {
      "nscp": {
        "action": ["enable", "start"],
        "ignore_failure": false,
        "retries": 3,
        "retry_delay": 5,
        "timeout": 30,
        "notifies": {
          "action": "some_action",
          "resource": "some[resource]",
          "timer": "immediate"
        },
        "subscribes": {
          "action": "some_action",
          "resource": "some[resource]",
          "timer": "immediate"
        },
        "supports": {
          "restart": false,
          "reload": false,
          "status": true
        }
      }
    }
  }
}
```

#### Service Caveats:

###### Note: The `action`, `notifies`, `subscribes`, and `supports` directives are defined differently here than they would be when calling the directives directly within a service resource in ruby.

- The `action` directive should always be defined as an array of strings, even if only one action is desired. If no `action` is supplied this will be interpreted as `:nothing` and a warning will be thrown.  

- The `notifies` directive should always be defined as an object with string properties. It will be converted into the correct format within the default recipe.

- The `subscribes` directive should always be defined as an object with string properties. It will be converted into the correct format within the default recipe.

- The `supports` directive should always be defined as an object with boolean properties. It will be converted into the correct format within the default recipe.

All available service properties are defined in the [Chef docs](https://docs.chef.io/resource_service.html) and their types remain the same besides the four mentioned above.
