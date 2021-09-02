

module Ots
  module Ruby
    module LamportKeyEngine
     
      def self.generate(size = 256, &block)
        if block
          hash = block.call(:digest_algo)
        else
          hash = :sha3_256
        end

        dig = OpenSSL::Digest.new("sha3-256")

        indx = 0   
        priv = []
        pub = []
        while indx < 256 do
          k1 = SecureRandom.random_bytes(32)
          k2 = SecureRandom.random_bytes(32)

          priv << [k1, k2]
          pub << [dig.digest(k1), dig.digest(k2)]
          indx += 1
        end

        [priv, pub]
      end

    end
  end
end
