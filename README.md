# easy-peasy-api

Filesystem-based API routing for Rails. Drop controller files into a directory and they become API endpoints automatically. No `routes.rb` entries needed.

## Install

```ruby
# Gemfile
gem "easy-peasy-api", require: "easy_peasy_api"
```

```ruby
# config/initializers/easy_peasy_api.rb
EasyPeasyApi.configure do |config|
  config.path = "/api/v1"
end
```

That's it. Every controller under `app/controllers/api/v1/` is now a live endpoint.

## How it works

The URL maps directly to the filesystem. The HTTP method determines the action.

```
URL                                    Controller File                                          Action
─────────────────────────────────────  ─────────────────────────────────────────────────────────  ──────
GET    /api/v1/customers              app/controllers/api/v1/customers_controller.rb             #index
POST   /api/v1/customers              app/controllers/api/v1/customers_controller.rb             #create
GET    /api/v1/customers/42           app/controllers/api/v1/customers_controller.rb             #show
PUT    /api/v1/customers/42           app/controllers/api/v1/customers_controller.rb             #update
DELETE /api/v1/customers/42           app/controllers/api/v1/customers_controller.rb             #destroy
```

Nest directories for nested resources:

```
GET    /api/v1/customers/uncontacted      app/controllers/api/v1/customers/uncontacted_controller.rb   #index
GET    /api/v1/customers/uncontacted/7    app/controllers/api/v1/customers/uncontacted_controller.rb   #show
```

Dynamic segments in the middle just work:

```
GET    /api/v1/customers/42/notes         app/controllers/api/v1/customers/notes_controller.rb         #index
GET    /api/v1/customers/42/notes/99      app/controllers/api/v1/customers/notes_controller.rb         #show
```

The `42` becomes `params[:customer_id]` (singularized parent directory + `_id`). The `99` becomes `params[:id]`.

## Examples

### Basic controller

```ruby
# app/controllers/api/v1/customers_controller.rb
module Api::V1
  class CustomersController < ActionController::API
    def index
      render json: Customer.all
    end

    def show
      render json: Customer.find(params[:id])
    end

    def create
      customer = Customer.create!(customer_params)
      render json: customer, status: :created
    end

    def update
      customer = Customer.find(params[:id])
      customer.update!(customer_params)
      render json: customer
    end

    def destroy
      Customer.find(params[:id]).destroy!
      head :no_content
    end

    private

    def customer_params
      params.permit(:name, :email)
    end
  end
end
```

```
curl localhost:3000/api/v1/customers
curl localhost:3000/api/v1/customers/42
curl -X POST localhost:3000/api/v1/customers -d '{"name":"Acme"}' -H 'Content-Type: application/json'
```

### Nested resource with dynamic parent ID

```ruby
# app/controllers/api/v1/customers/notes_controller.rb
module Api::V1::Customers
  class NotesController < ActionController::API
    def index
      customer = Customer.find(params[:customer_id])
      render json: customer.notes
    end

    def show
      note = Note.find(params[:id])
      render json: note
    end
  end
end
```

```
curl localhost:3000/api/v1/customers/42/notes          # params[:customer_id] = "42"
curl localhost:3000/api/v1/customers/42/notes/99       # params[:customer_id] = "42", params[:id] = "99"
```

### Deeper nesting

```ruby
# app/controllers/api/v1/customers/uncontacted/notes_controller.rb
module Api::V1::Customers::Uncontacted
  class NotesController < ActionController::API
    def index
      render json: Note.where(uncontacted_id: params[:uncontacted_id])
    end

    def show
      render json: Note.find(params[:id])
    end
  end
end
```

```
curl localhost:3000/api/v1/customers/uncontacted/55/notes       # params[:uncontacted_id] = "55"
curl localhost:3000/api/v1/customers/uncontacted/55/notes/12    # params[:uncontacted_id] = "55", params[:id] = "12"
```

### Renaming params with `set_params`

By default, dynamic segments are named after the parent directory (`customers` -> `customer_id`). If you want different names, inherit from `EasyPeasyApi::ApplicationController` and call `set_params` in your action:

```ruby
# app/controllers/api/v1/customers/uncontacted/notes_controller.rb
module Api::V1::Customers::Uncontacted
  class NotesController < EasyPeasyApi::ApplicationController
    def index
      set_params :customer_id
      render json: Note.where(customer_id: params[:customer_id])
    end

    def show
      set_params :customer_id, :id
      render json: Note.find(params[:id])
    end
  end
end
```

```
curl localhost:3000/api/v1/customers/uncontacted/55/notes/12
# Without set_params: params[:uncontacted_id] = "55"
# With set_params:    params[:customer_id] = "55"
```

`set_params` takes the param names in order of appearance in the URL. Call it in the action method, or in a `before_action` -- it rebuilds the params each time so you can call it as many times as you need.

## Param naming rules

| URL pattern | Default param name | Rule |
|---|---|---|
| `/customers/42` | `params[:id]` | Trailing segment after a controller |
| `/customers/42/notes` | `params[:customer_id]` | Mid-path segment, named from parent dir (singularized + `_id`) |
| `/customers/42/notes/99` | `params[:customer_id]`, `params[:id]` | Both rules combined |

## Route priority

When a URL segment could match either a nested controller or a dynamic `:id`, the more specific match (nested controller) wins:

```
app/controllers/api/v1/customers_controller.rb
app/controllers/api/v1/customers/uncontacted_controller.rb
```

```
GET /api/v1/customers/uncontacted   -> UncontactedController#index  (not CustomersController#show)
GET /api/v1/customers/42            -> CustomersController#show     (no matching nested controller)
```

## Action mapping

| HTTP method | With `:id` | Without `:id` |
|---|---|---|
| GET | `show` | `index` |
| POST | -- | `create` |
| PUT / PATCH | `update` | -- |
| DELETE | `destroy` | -- |
