# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  firstname              :string(255)
#  lastname               :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  login                  :string(255)
#  avatar                 :string(255)
#  sign_out_at            :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
