describe Swarker::Schema do
  let(:example_host) { 'example_host' }
  let(:example_title) { 'ExapleTitle' }

  it 'has constant defaults' do
    expect(subject.swagger).to eq('2.0')
    expect(subject.consumes).to eq('application/json')
    expect(subject.produces).to eq('application/json')
  end

  it '#host can be setted' do
    expect(Swarker::Schema.new.host).to be_nil
    expect(Swarker::Schema.new(host: example_host).host).to eq(example_host)
  end

  it '#title can be setted' do
    expect(Swarker::Schema.new.title).to be_nil
    expect(Swarker::Schema.new(title: example_title).title).to eq(example_title)
  end

  it '#definitions'
  it '#paths'
end
