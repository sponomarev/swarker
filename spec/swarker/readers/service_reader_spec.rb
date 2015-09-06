describe Swarker::Readers::ServiceReader do
  let(:service_dir) { File.expand_path('spec/fixtures/service') }
  let(:service_hosts) { %w(lurker.razum2um.me lurker-app.herokuapp.com:8080 ) }

  subject { Swarker::Readers::ServiceReader.new(service_dir) }

  it 'create only Service objects' do
    expect(subject.services).to all(be_an(Swarker::Service))
  end

  it 'find proper number of services' do
    expect(subject.services.count).to eq(2)
  end

  it 'recognise hosts' do
    expect(subject.services.collect(&:host)).to match_array(service_hosts)
  end
end
