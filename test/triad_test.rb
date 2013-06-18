require 'test_helper'

describe Triad, '#<<' do
  let(:triad){ Triad.new }

  it 'shovels 3 item arrays' do
    assert triad << [:test, 'Test', Object.new]
  end

  it 'rejects arrays with more than 3 items' do
    assert_raises(Triad::InvalidAddition){
      triad << [:test, 'Test', Object.new, 'Other']
    }
  end

  it 'rejects arrays with fewer than 3 items' do
    assert_raises(Triad::InvalidAddition){
      triad << [:test, 'Test']
    }
  end

  it 'rejects arrays with an existing key' do
    triad << [:test, 'Test', Object.new]
    assert_raises(Triad::InvalidAddition){
      triad << [:test, 'More', Object.new]
    }
  end
end

describe Triad, '#keys' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the key for the given descriptor' do
    assert_equal :admin, triad.keys('Admin')
  end

  it 'returns the key for the given value' do
    assert_equal :admin, triad.keys(user)
  end
end

describe Triad, '#descriptors' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the descriptor for the given key' do
    assert_equal 'Admin', triad.descriptors(:admin)
  end

  it 'returns the descriptor for the given value' do
    assert_equal 'Admin', triad.descriptors(user)
  end
end

describe Triad, '#values' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the value for the given key' do
    assert_equal user, triad.values(:admin)
  end

  it 'returns the value for the given descriptor' do
    assert_equal user, triad.values('Admin')
  end
end