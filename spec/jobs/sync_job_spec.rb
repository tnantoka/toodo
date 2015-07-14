require 'rails_helper'

RSpec.describe SyncJob, type: :job do
  include ActiveJob::TestHelper

  describe 'perform' do
    let(:user) { create(:user) }
    let(:list) { create(:list, content: '', user: user) }
    before do
      stub_request(:patch, "https://api.github.com/gists/id").
        to_return(status: 200, body: {}.to_json, headers: { 'Content-Type': 'application/json' })
    end
    it 'performs job' do
      perform_enqueued_jobs do
        expect(performed_jobs.size).to eq(0)
        list.update!(gist: true, gist_id: 'id')
        list.run_callbacks(:commit)
        expect(performed_jobs.size).to eq(1)
      end
    end
  end
end
