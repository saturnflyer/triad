require_relative 'test_helper'

describe Triad, '#<<' do
  let(:triad){ Triad.new }

  it 'shovels 3 item arrays' do
    assert triad << [:test, 'Test', Object.new]
  end

  it 'rejects arrays with more than 3 items' do
    error = assert_raises(Triad::InvalidAddition){
      triad << [:test, 'Test', Object.new, 'Other']
    }
    assert_match(/array length must be 3/, error.message)
  end

  it 'rejects arrays with fewer than 3 items' do
    assert_raises(Triad::InvalidAddition){
      triad << [:test, 'Test']
    }
  end

  it 'rejects arrays with an existing key' do
    triad << [:test, 'Test', Object.new]
    error = assert_raises(Triad::InvalidAddition){
      triad << [:test, 'More', Object.new]
    }
    assert_match(/key already exists/, error.message)
  end
  
  it 'accepts strings as values' do
    object = "a string as an value"
    triad << [:key, 'Descriptor', object]
    assert_equal [object], triad.values(:key)
  end
end

describe Triad, '#update' do
  let(:triad){ Triad.new }

  it 'updates a descriptor and object for the given key' do
    object = Object.new
    triad << [:test, 'Test', object]
    assert_equal ['Test'], triad.descriptors(:test)
    triad.update(:test, 'Updated', Object.new)
    assert_equal ['Updated'], triad.descriptors(:test)
  end

  it "allows a nil object" do
    triad << [:test, 'Test', nil]
    assert_equal ['Test'], triad.descriptors(:test)
    triad.update(:test, 'Updated', nil)
    assert_equal ['Updated'], triad.descriptors(:test)
  end

  it "does not allow a nil descriptor" do
    err = assert_raises(Triad::InvalidAddition){
      triad.update(:test, nil, Object.new)
    }
    assert_equal "the provided descriptor cannot be nil", err.message
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
    assert_equal [:admin], triad.keys('Admin')
  end

  it 'returns the key for the given value' do
    assert_equal [:admin], triad.keys(user)
  end

  it 'returns the keys for the given key' do
    assert_equal [:admin], triad.keys(:admin)
  end

  it 'returns all keys when given no argument' do
    triad << [:other, 'Other', user]
    assert_equal [:admin, :other], triad.keys
  end

  it 'errors when the given key is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.keys(:invalid_key)
    }
  end

  it 'errors when the given descriptor is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.keys('Invalid Descriptor')
    }
  end

  it 'errors when the given value is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.keys(Object.new)
    }
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
    assert_equal ['Admin'], triad.descriptors(:admin)
  end

  it 'returns the descriptor for the given value' do
    assert_equal ['Admin'], triad.descriptors(user)
  end

  it 'returns the descriptors for the given descriptor' do
    assert_equal ['Admin'], triad.descriptors('Admin')
  end

  it 'returns all descriptors when given no argument' do
    triad << [:other, 'Other', user]
    assert_equal ['Admin', 'Other'], triad.descriptors
  end

  it 'errors when the given descriptor is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.descriptors('Not Present')
    }
  end

  it 'errors when the given key is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.descriptors(:invalid_key)
    }
  end

  it 'errors when the given value is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.descriptors(Object.new)
    }
  end

  it 'assumes nil is a value' do
    triad.update(:admin, 'Admin', nil)
    assert_equal ['Admin'], triad.descriptors(:admin)
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
    assert_equal [user], triad.values(:admin)
  end

  it 'returns the value for the given descriptor' do
    assert_equal [user], triad.values('Admin')
  end

  it 'returns all values when given no argument' do
    triad << [:other, 'Other', user]
    assert_equal [user], triad.values
  end


  it 'errors when the given key is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.values(:invalid_key)
    }
  end

  it 'errors when the given descriptor is not found' do
    assert_raises(Triad::ItemNotPresent){
      triad.values('Invalid Descriptor')
    }
  end
end

describe Triad, 'enumeration' do
  let(:user){ Object.new }
  let(:triad){
    tri = Triad.new
    tri << [:admin, 'Admin', user]
    tri
  }
  it 'yields each triad as 3 block variables' do
    result = ''
    triad.each do |key, descriptor, value|
      result << "key: #{key}, descriptor: #{descriptor}, value: #{value.class.name}"
    end
    assert_equal 'key: admin, descriptor: Admin, value: Object', result
  end
end
