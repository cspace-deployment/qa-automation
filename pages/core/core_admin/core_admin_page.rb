require_relative '../../../spec_helper'

class CoreAdminPage

  include Logging
  include Page
  include CollectionSpacePages
  # include CoreSearchResultsPage

  DEPLOYMENT = Deployment::CORE

  # Locators
  def admin_users_link; {:xpath => '//a[contains(.,"Users")]'} end
  def admin_roles_link; {:xpath => '//a[contains(.,"Roles and Permissions")]'} end
  def email_field_locator; {:xpath => '//input[@data-name="email"]'} end
  def username_field_locator; {:xpath => '//input[@data-name="screenName"]'} end
  def password_field_locator; {:xpath => '//input[@data-name="password"]'} end
  def confirm_password_field_locator; {:xpath => '//input[@data-name="confirmPassword"]'} end
  def role_locator(role); {:xpath => "//fieldset[@data-name=\"roleList\"]//li[contains(.,\"#{role}\")]//input"} end
  def search_filter_bar; {:xpath => '//div[contains(@class, "AdminSearchBar")]//input[contains(@class,"LineInput")]'} end
  def result_rows; {:xpath => '//div[@class="cspace-ui-SearchResultTable--common"]//*[@aria-label="row"]'} end
  def role_name_locator; {:xpath => '//input[@data-name="displayName"]'} end
  def role_desc_locator; {:xpath => '//textarea[@data-name="description"]'} end

  def permission_locator(record_type, value); {:xpath  => "//section/div[contains(.,\"#{record_type}\")]//input[@value=\"#{value}\"]"} end

  # The following 4 methods are added temporarily while SearchPageResults is fixed...
  def fill_search_filter_bar(value)
    wait_for_element_and_type(search_filter_bar, value)
    wait_for_results
    sleep 1
  end

  def result_row(id)
    {:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][contains(.,\"#{id}\")]"}
  end

  def wait_for_results
    wait_until(Config.medium_wait) { elements(result_rows).any? }
  end

  def row_exists?(unique_identifier)
    exists? result_row(unique_identifier)
  end

  ###################
  ## User Creation ##
  ##################
  def click_users_link
    wait_for_page_and_click admin_users_link
  end

  # Creates a new user given an email, name, password and role
  def create_new_user(email, name, password, role)
    click_element admin_users_link
    click_element create_new_button

    wait_for_element_and_type(email_field_locator, email)
    wait_for_element_and_type(username_field_locator, name)
    wait_for_element_and_type(password_field_locator, password)
    wait_for_element_and_type(confirm_password_field_locator, password)
    wait_for_element_and_click role_locator(role)

    save_record
  end

  # Checks whether a user exists
  def user_exists(name)
    click_element admin_users_link
    fill_search_filter_bar name
    return exists? result_row(name)
  end

  # Change a user's role. Assumes the role exists
  def change_user_role(user, prev_role_name, new_role_name)
    click_element admin_users_link

    fill_search_filter_bar user
    wait_for_results
    wait_for_element_and_click result_row(user)

    wait_for_element_and_click role_locator(prev_role_name)
    wait_for_element_and_click role_locator(new_role_name)

    save_record
    sleep 5
  end


  #########################
  ## Roles & Permissions ##
  #########################
  def click_roles_link
    wait_for_page_and_click admin_roles_link
  end

  def role_exists(name)
    click_element admin_roles_link
    fill_search_filter_bar  name
    wait_for_results
    return exists? result_row(name)
  end

  # Creates a user role given a name, description and permissions
  def create_user_role(role_name, description, permissions)

    click_element admin_roles_link
    click_element create_new_button
    wait_for_element_and_type(role_name_locator, role_name)
    change_role_permissions permissions
    scroll_to_top
    hide_header_bar

    wait_for_element_and_type(role_desc_locator, description)

    wait_for_element_and_click top_save_button
  end

  # Takes in a Hash of mappings from Permission name to either "R, W, D, N"
  # Assumes role is checked for existence elsewhere
  def change_role_permissions(permissions)
    permissions.each do |key, value|
      # scroll_to_bottom

      case value
      when "N"
        revoke_permission key
      when "R"
        grant_read_permission key
      when "D"
        grant_delete_permission key
      when "W"
        grant_write_permissions key
      else
        "Error: Unknown permission type. Defaulting to NONE."
      end
    end
  end

  # Revokes permission from a record type
  def revoke_permission(record)
    wait_for_element_and_click permission_locator(record, "")
  end

  # Grants Read and List permission
  def grant_read_permission(record)
    wait_for_element_and_click permission_locator(record,  "RL")
  end

  # Grants Full CRUDL permissions
  def grant_delete_permission(record)
    wait_for_element_and_click permission_locator(record, "CRUDL")
  end

  # GRants Create, Read, List, Unrelate permissions
  def grant_write_permissions(record)
    wait_for_element_and_click permission_locator(record, "CRUL")
  end

  # TO DO: For now assume that this already exists
  # end
end