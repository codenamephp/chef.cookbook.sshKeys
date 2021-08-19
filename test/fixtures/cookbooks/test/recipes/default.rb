# frozen_string_literal: true

codenamephp_users_from_data_bag 'Create users' do
  groups %w(chef sudo sysadmin)
end
