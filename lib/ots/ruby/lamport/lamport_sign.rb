
require 'openssl'
require 'securerandom'

module Ots
  module Ruby
    module LamportSign
      include ToolRack::ConditionUtils
      def sign_init(priv, &block)
        raise OtsError, "Private key used to sign message should not be empty" if is_empty?(priv)

        @priv = priv
        @dig = OpenSSL::Digest.new("sha3-256")

        if block
          instance_eval(&block)
          sign_final
        else
          self
        end

      end

      def sign_update(data, &block)
        @dig.update(data) 
      end
      alias_method :update, :sign_update

      def sign_final
       
        sign = []
        dmsg = @dig.digest
        indx = 0
        dmsg.each_byte do |b|
          # 0x1000000
          # start with left most
          t = 128
          while t > 0
            if (b & t) == t
              # value is 1
              sign << @priv[indx][1]
            else
              sign << @priv[indx][0]
            end
            indx += 1
            t = t >> 1
          end
        end

        sign

      end
      alias_method :sign, :sign_final
      alias_method :final, :sign_final

    end
  end
end
