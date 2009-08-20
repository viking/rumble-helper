class User < ActiveRecord::Base
  attr_reader :data

  acts_as_authentic do |c|
    c.merge_validates_length_of_email_field_options :allow_nil => true
    c.merge_validates_format_of_email_field_options :allow_nil => true

    def attributes_to_save
      attrs_to_save = attributes.clone.delete_if do |k, v|
        [:id, :persistence_token, :perishable_token, :single_access_token, :login_count,
          :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :created_at,
          :updated_at, :lock_version].include?(k.to_sym)
      end
    end

    def map_openid_registration(registration)
      self.nickname = registration['nickname'] if !registration['nickname'].blank?
      self.email    = registration['email']    if !registration['email'].blank?
    end
  end

  belongs_to :team

  protected
    def fetch_data
      @data = Rumble.identity(self.api_key)
    end

    def validate
      if self.user_type && self.user_type != 'participant'
        self.errors.add_to_base('You must be a participant to sign up.')
      end
      if self.new_record?
        if self.api_key.blank?
          self.errors.add(:api_key, 'is required')
        elsif self.api_key !~ /^[a-fA-F0-9]+$/
          self.errors.add(:api_key, 'is not a hex code')
        else
          connection_error = false
          begin
            self.fetch_data
            if @data.is_a?(Hash) && @data.has_key?('hash') && @data['hash']['error']
              self.errors.add(:api_key, 'is invalid')
            else
              if !set_attribs
                connection_error = true
              end
            end
          rescue SocketError, NoMethodError
            connection_error = true
          end

          if connection_error
            # data is bad
            self.errors.add_to_base("Error connecting to the Rails Rumble server, try again later")
          end
        end
      end
    end

    def set_attribs
      attribs = {
        'nickname' => @data['hash']['details']['nickname'],
        'user_type' => @data['hash']['details']['user_type'],
        'email' => @data['hash']['details']['email'],
        'team_rumble_id' => @data['hash']['details']['team']['id'],
        'team_slug' => @data['hash']['details']['team']['slug'],
        'team_name' => @data['hash']['details']['team']['name']
      }
      if attribs.values.any? { |v| v.nil? }
        return false
      end
      self.attributes = attribs

      if (team = Team.find_by_rumble_id(self.team_rumble_id))
        self.team_id = team.id
      end
      true
    end
end
