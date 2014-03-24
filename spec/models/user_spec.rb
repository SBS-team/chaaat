# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
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
#  profile_avatar         :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  user_stat_id           :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_stat_id          (user_stat_id)
#

require 'spec_helper'

describe User do
  context 'User db columns' do
    it { should have_db_column(:email).of_type(:string)}
    it { should have_db_column(:encrypted_password).of_type(:string)}
    it { should have_db_column(:reset_password_token).of_type(:string)}
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime)}
    it { should have_db_column(:remember_created_at).of_type(:datetime)}
    it { should have_db_column(:sign_in_count).of_type(:integer)}
    it { should have_db_column(:current_sign_in_at).of_type(:datetime)}
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string)}
    it { should have_db_column(:last_sign_in_ip).of_type(:string)}
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime)}
    it { should have_db_column(:firstname).of_type(:string)}
    it { should have_db_column(:lastname).of_type(:string)}
    it { should have_db_column(:provider).of_type(:string)}
    it { should have_db_column(:uid).of_type(:string)}
  end
  context 'User relationship' do
    it { should have_many(:message) }
    it { should have_many(:rooms_users) }
  end
 end
