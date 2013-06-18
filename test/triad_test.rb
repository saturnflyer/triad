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
end

describe Triad, '#key' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the key for the given descriptor' do
    assert_equal :admin, triad.key('Admin')
  end

  it 'returns the key for the given value' do
    assert_equal :admin, triad.key(user)
  end
end

describe Triad, '#descriptor' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the descriptor for the given key' do
    assert_equal 'Admin', triad.descriptor(:admin)
  end

  it 'returns the descriptor for the given value' do
    assert_equal 'Admin', triad.descriptor(user)
  end
end

describe Triad, '#value' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the value for the given key' do
    assert_equal user, triad.value(:admin)
  end

  it 'returns the value for the given descriptor' do
    assert_equal user, triad.value('Admin')
  end
end

describe Triad, '#value' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }

  it 'returns the value for the given key' do
    assert_equal user, triad.value(:admin)
  end

  it 'returns the value for the given descriptor' do
    assert_equal user, triad.value('Admin')
  end
end