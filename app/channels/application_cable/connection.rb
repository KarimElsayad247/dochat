module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      session_record = Session.find_by_id(cookies.signed[:session_token])
      if session_record
        Current.session = session_record
        session_record
      else
        reject_unauthorized_connection
      end
    end
  end
end
