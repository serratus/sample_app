# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#


class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  email_regex = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  
  validates :name, presence: true,
                   length: {maximum: 50}
  validates :email, presence: true,
                    format: {with: email_regex}
end

