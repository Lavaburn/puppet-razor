shared_examples 'an idempotent manifest' do
  it 'should not have errors the first time' do
    result = apply_manifests(agents, pp, { :catch_failures => true })
    expect([0, 2]).to include(result.exit_code)
  end

  it 'be idempotent on the second run' do
    result = apply_manifests(agents, pp, { :catch_changes => true })
    expect(result.exit_code).to eq(0)    
  end
end
