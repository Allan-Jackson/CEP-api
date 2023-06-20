require 'net/http'

class MyService 
  
  private  
    def get(uri, headers)
        Net::HTTP.get(uri, headers)
    end

    # def post(uri, params)
    #     Net:HTTP.post_formd(uri, params)
    # end
end


