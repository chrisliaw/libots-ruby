
class LamportSign
  include Ots::Ruby::LamportSign
end

class LamportVerify
  include Ots::Ruby::LamportVerify
end

RSpec.describe Ots::Ruby::LamportSign do

  before do
    @ls = LamportSign.new
    @lv = LamportVerify.new
  end

  it 'generates 2 x 256 arrays of keys' do
    priv, pub = Ots::Ruby::LamportKeyEngine.generate 
    expect(priv.length == 256).to be true
    expect(pub.length == 256).to be true

    data = "testing 123"
    res = @ls.sign_init(priv) do 
      update data
    end

    expect(res.length == 256).to be true
   
    vres = @lv.verify_init(pub) do
      res.each do |s|
        update(:sign, s)
      end
      update(:data, data)
    end
   
    expect(vres).to be true

  end
  
end
