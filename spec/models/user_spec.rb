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