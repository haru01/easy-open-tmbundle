RSpec::Matchers.define :eq_token do |expect|
  match do |actual|
    expect == actual
  end

  failure_message_for_should do |actual|
    "expected: #{expect.sort.to_a.flatten}\n     got: #{actual.sort.to_a.flatten}"
  end
end
