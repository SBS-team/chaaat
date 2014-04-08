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
#  sign_out_at            :datetime
#  login                  :string(255)
#  avatar                 :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  profile_avatar         :string(255)
#  user_status            :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(login: "petro", encrypted_password: "123456789", firstname: "Example", lastname: "User", email: "user@example.com", user_status: "Available")
  end

  subject { @user }
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
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:login) }
  it { should respond_to(:lastname) }
  it { should respond_to(:firstname) }
  it { should respond_to(:user_status) }

  describe "when login is not present" do
    before { @user.login = "" }
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end
  describe "when lastname is not present" do
    before { @user.lastname = "" }
    it { should_not be_valid }
  end
  describe "when firstname is not present" do
    before { @user.firstname = "" }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.encrypted_password = "" }
    it { should_not be_valid }
  end
  describe "when firstname is too long" do
    before { @user.firstname = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when lastname is too long" do
    before { @user.lastname = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when login is too long" do
    before { @user.login = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @user.email = "a" *50 +"@" +"b"*50 + ".com" }
    it { should_not be_valid }
  end

 end
