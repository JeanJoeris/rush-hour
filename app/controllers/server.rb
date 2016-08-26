module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      if Client.find_by(identifier: params[:identifier], root_url: params[:rootUrl])
        status 403
        body "that is already a client"
      else
        client = Client.new(identifier: params[:identifier], root_url: params[:rootUrl])
        if client.save
          status 200
          body "{'identifier':'#{client.identifier}'}"
        else
          status 400
          body "not a valid client"
        end
      end
    end

    def is_valid_client
    end
  end
end
