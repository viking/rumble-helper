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

  before_validation :fetch_data
  validates_presence_of :api_key, :on => :create
  validates_each :api_key do |record, attr, value|
    if record.data.nil?
      record.errors.add(attr, 'is invalid')
    end
  end

  before_create :set_attribs

  belongs_to :team

  protected
    def fetch_data
      @data ||= Rumble.identity(self.api_key)
    end

    def validate
      if self.user_type && self.user_type != 'participant'
        self.errors.add_to_base('You must be a participant to sign up.')
      end
    end

    def set_attribs
      self.nickname = @data['hash']['details']['nickname']
      self.user_type = @data['hash']['details']['user_type']
      self.email = @data['hash']['details']['email']
      self.team_rumble_id = @data['hash']['details']['team']['id']
      self.team_slug = @data['hash']['details']['team']['slug']
      self.team_name = @data['hash']['details']['team']['name']

      if (team = Team.find_by_rumble_id(self.team_rumble_id))
        self.team_id = team.id
      end
    end
end
