class AddRecurringSync < ActiveRecord::Migration[5.2]
  class FakeSccAccount < ApplicationRecord
    self.table_name = 'scc_accounts'
  end

  def up
    change_table :scc_accounts, bulk: true do |t|
      t.column :foreman_tasks_recurring_logic_id, :integer
      t.column :interval, :string, default: 'never'
      t.column :sync_date, :datetime
      t.column :task_group_id, :integer, index: true
    end
    add_foreign_key :scc_accounts, :foreman_tasks_recurring_logics, :name => 'scc_accounts_foreman_tasks_recurring_logic_fk', :column => 'foreman_tasks_recurring_logic_id'
    add_foreign_key :scc_accounts, :foreman_tasks_task_groups, column: :task_group_id
    FakeSccAccount.all.each do |scca|
      scca.task_group_id ||= SccAccountSyncPlanTaskGroup.create!.id
      scca.save!
    end
  end

  def down
    change_table :scc_accounts, bulk: true do |t|
      t.remove :foreman_tasks_recurring_logic_id
      t.remove :interval
      t.remove :sync_date
      t.remove :task_group_id
    end
    ForemanTasks::TaskGroup.where(:type => 'SccAccountSyncPlanTaskGroup').delete_all
  end
end
