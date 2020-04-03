class ChangeSyncStatusToSyncTask < ActiveRecord::Migration[4.2]
  def up
    change_table :scc_accounts, bulk: true do |t|
      t.remove :sync_status
      t.column :sync_task_id, :uuid, null: true
    end
    # add_foreign_key "scc_accounts", "foreman_tasks_tasks", name: "scc_accounts_foreman_tasks_tasks_id_fk", column: "sync_task_id", primary_key: "id" , on_delete: :nullify
  end

  def down
    change_table :scc_accounts, bulk: true do |t|
      t.column :sync_status, :string
      t.remove :sync_task_id
    end
  end
end
