describe Swarker::Serializers::ServiceSerializer do
  let(:service_dir) { File.expand_path('spec/fixtures/service') }
  let(:service) { Swarker::Readers::ServiceReader.new(service_dir).services.last }

  context '#schema' do
    subject { Swarker::Serializers::ServiceSerializer.new(service).schema }

    it 'has proper structure' do
      expect(subject).to include(:consumes, :host, :produces, :swagger)
      expect(subject[:info]).to include(:version, :title)

      expect(subject).to include(:paths, :definitions)
    end
  end
end
