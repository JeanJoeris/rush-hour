module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      # this feels hacky, probably better way once we are saving these objects to db
      if params.keys.sort == ["identifier", "root_url"]
        status 200
        body "{'identifier':'#{params[:identifier]}'}"
      else
        status 400
        body "not a valid source"
      end
    end
  end
end
