class SyncJob < ActiveJob::Base
  queue_as :default

  def perform(list_id)
    ActiveRecord::Base.connection_pool.with_connection do
      List.find_by(id: list_id).try(:perform_sync)
    end
  end
end
