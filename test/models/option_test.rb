# == Schema Information
#
# Table name: options
#
#  id                      :integer          not null, primary key
#  name                    :string
#  stock_price             :decimal(, )
#  strike_price            :decimal(, )
#  years_to_maturity       :decimal(, )
#  risk_free_interest_rate :decimal(, )
#  volatality              :decimal(, )
#  call_flag               :boolean          default(TRUE)
#  black_scholes_value     :decimal(, )
#  guest_id                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
