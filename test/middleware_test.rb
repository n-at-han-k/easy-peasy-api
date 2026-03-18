require_relative 'test_helper'
require 'json'

class MiddlewareTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Rails.application
  end

  # --- Collection endpoints (no :id) ---

  def test_get_customers_returns_index
    get '/api/v1/customers'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'index', body['action']
    assert_equal 'customers', body['controller']
  end

  def test_post_customers_returns_create
    post '/api/v1/customers'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'create', body['action']
    assert_equal 'customers', body['controller']
  end

  # --- Member endpoints (with :id) ---

  def test_get_customers_with_id_returns_show
    get '/api/v1/customers/4535'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'show', body['action']
    assert_equal 'customers', body['controller']
    assert_equal '4535', body['id']
  end

  def test_put_customers_with_id_returns_update
    put '/api/v1/customers/4535'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'update', body['action']
    assert_equal 'customers', body['controller']
    assert_equal '4535', body['id']
  end

  def test_patch_customers_with_id_returns_update
    patch '/api/v1/customers/4535'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'update', body['action']
    assert_equal 'customers', body['controller']
    assert_equal '4535', body['id']
  end

  def test_delete_customers_with_id_returns_destroy
    delete '/api/v1/customers/4535'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'destroy', body['action']
    assert_equal 'customers', body['controller']
    assert_equal '4535', body['id']
  end

  # --- Nested controller ---

  def test_get_customers_uncontacted_returns_index
    get '/api/v1/customers/uncontacted'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'index', body['action']
    assert_equal 'customers/uncontacted', body['controller']
  end

  def test_post_customers_uncontacted_returns_create
    post '/api/v1/customers/uncontacted'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'create', body['action']
    assert_equal 'customers/uncontacted', body['controller']
  end

  def test_get_customers_uncontacted_with_id_returns_show
    get '/api/v1/customers/uncontacted/564'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'show', body['action']
    assert_equal 'customers/uncontacted', body['controller']
    assert_equal '564', body['id']
  end

  def test_put_customers_uncontacted_with_id_returns_update
    put '/api/v1/customers/uncontacted/564'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'update', body['action']
    assert_equal 'customers/uncontacted', body['controller']
    assert_equal '564', body['id']
  end

  def test_delete_customers_uncontacted_with_id_returns_destroy
    delete '/api/v1/customers/uncontacted/564'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'destroy', body['action']
    assert_equal 'customers/uncontacted', body['controller']
    assert_equal '564', body['id']
  end

  # --- Deep nested: /api/v1/customers/:customer_id/notes(/:id) ---

  def test_get_customer_notes_index
    get '/api/v1/customers/234/notes'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'index', body['action']
    assert_equal 'customers/notes', body['controller']
    assert_equal '234', body['customer_id']
  end

  def test_post_customer_notes_create
    post '/api/v1/customers/234/notes'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'create', body['action']
    assert_equal 'customers/notes', body['controller']
    assert_equal '234', body['customer_id']
  end

  def test_get_customer_notes_show
    get '/api/v1/customers/234/notes/234234'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'show', body['action']
    assert_equal 'customers/notes', body['controller']
    assert_equal '234', body['customer_id']
    assert_equal '234234', body['id']
  end

  def test_put_customer_notes_update
    put '/api/v1/customers/234/notes/234234'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'update', body['action']
    assert_equal 'customers/notes', body['controller']
    assert_equal '234', body['customer_id']
    assert_equal '234234', body['id']
  end

  def test_delete_customer_notes_destroy
    delete '/api/v1/customers/234/notes/234234'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'destroy', body['action']
    assert_equal 'customers/notes', body['controller']
    assert_equal '234', body['customer_id']
    assert_equal '234234', body['id']
  end

  # --- Deep nested: /api/v1/customers/uncontacted/:uncontacted_id/notes(/:id) ---

  def test_get_uncontacted_notes_index
    get '/api/v1/customers/uncontacted/234234/notes'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'index', body['action']
    assert_equal 'customers/uncontacted/notes', body['controller']
    assert_equal '234234', body['uncontacted_id']
  end

  def test_get_uncontacted_notes_show
    get '/api/v1/customers/uncontacted/234234/notes/999'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'show', body['action']
    assert_equal 'customers/uncontacted/notes', body['controller']
    assert_equal '234234', body['uncontacted_id']
    assert_equal '999', body['id']
  end

  def test_put_uncontacted_notes_update
    put '/api/v1/customers/uncontacted/234234/notes/999'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'update', body['action']
    assert_equal 'customers/uncontacted/notes', body['controller']
    assert_equal '234234', body['uncontacted_id']
    assert_equal '999', body['id']
  end

  def test_delete_uncontacted_notes_destroy
    delete '/api/v1/customers/uncontacted/234234/notes/999'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'destroy', body['action']
    assert_equal 'customers/uncontacted/notes', body['controller']
    assert_equal '234234', body['uncontacted_id']
    assert_equal '999', body['id']
  end

  # --- Pass-through for non-matching paths ---

  def test_non_matching_path_passes_through
    get '/other/path'
    assert_includes [404, 204], last_response.status
  end

  # --- 404 for unknown controllers ---

  def test_unknown_controller_returns_404
    get '/api/v1/nonexistent'
    assert_equal 404, last_response.status
  end

  def test_unknown_nested_controller_returns_404
    get '/api/v1/customers/nonexistent/deep/path'
    assert_equal 404, last_response.status
  end

  # --- Ambiguity: /api/v1/customers/uncontacted prefers nested controller over customers#show ---

  def test_prefers_nested_controller_over_id
    get '/api/v1/customers/uncontacted'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'index', body['action']
    assert_equal 'customers/uncontacted', body['controller']
  end

  # --- set_params: controller overrides default dynamic param names ---

  # UncontactedNotesController uses set_params to rename :uncontacted_id to :customer_id
  # The middleware passes the raw positional dynamic values, and set_params remaps them.

  def test_set_params_renames_dynamic_param_on_index
    get '/api/v1/customers/uncontacted/234234/remapped_notes'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'index', body['action']
    assert_equal 'customers/uncontacted/remapped_notes', body['controller']
    # set_params remapped :uncontacted_id -> :customer_id
    assert_equal '234234', body['customer_id']
    assert_nil body['uncontacted_id']
  end

  def test_set_params_renames_dynamic_param_on_show
    get '/api/v1/customers/uncontacted/234234/remapped_notes/999'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'show', body['action']
    assert_equal 'customers/uncontacted/remapped_notes', body['controller']
    assert_equal '234234', body['customer_id']
    assert_equal '999', body['id']
    assert_nil body['uncontacted_id']
  end

  def test_set_params_renames_dynamic_param_on_update
    put '/api/v1/customers/uncontacted/234234/remapped_notes/999'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'update', body['action']
    assert_equal '234234', body['customer_id']
    assert_equal '999', body['id']
    assert_nil body['uncontacted_id']
  end

  def test_set_params_renames_dynamic_param_on_destroy
    delete '/api/v1/customers/uncontacted/234234/remapped_notes/999'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'destroy', body['action']
    assert_equal '234234', body['customer_id']
    assert_equal '999', body['id']
    assert_nil body['uncontacted_id']
  end
end
