class FixDenyListExpiredColumn < ActiveRecord::Migration[7.0]
  def change
    change_table :jwt_denylist do |t|
      t.rename :expired_at, :exp
    end
  end
end
