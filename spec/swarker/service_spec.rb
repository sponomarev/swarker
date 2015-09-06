describe Swarker::Service do
  let(:lurker_service) { YAML.load_file(File.expand_path('spec/fixtures/service/LurkerAppRails42.service.yml')) }

  subject { Swarker::Service.new('example_host', lurker_service) }

  it '#definitions is Array' do
    expect(subject.definitions).to be_a(Array)
  end
  it '#paths is Array' do
    expect(subject.paths).to be_a(Array)
  end

  it 'recognise title' do
    expect(subject.schema[:info][:title]).to eq('Lurker Demo Application')
  end

  it 'recognise host' do
    expect(subject.schema[:host]).to eq('example_host')
  end
end
