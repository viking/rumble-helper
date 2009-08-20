class Team < ActiveRecord::Base
  attr_accessor :api_key
  attr_reader :data

  include AASM
  aasm_column :status
  aasm_initial_state :shiny
  aasm_state :shiny
  aasm_state :dull
  aasm_event :unwrap do
    transitions :to => :dull, :from => [:shiny]
  end

  has_many :members
  has_many :tasks

  before_update :set_dull
  after_create :create_members_and_find_users

  private
    def validate
      do_fetch = true
      if self.slug.blank?
        do_fetch = false
        self.errors.add(:slug, "cannot be blank")
      end
      if self.api_key.blank?
        do_fetch = false
        self.errors.add(:api_key, "cannot be blank")
      end

      if do_fetch
        connection_error = false
        begin
          fetch_data
          if !@data.is_a?(Hash)
            self.errors.add(:slug, 'is invalid')
          else
            if !set_attribs
              connection_error = true
            end
          end
        rescue SocketError, NoMethodError
          connection_error = true
        end
        if connection_error
          self.errors.add_to_base("Error connecting to the Rails Rumble server, try again later")
        end
      end
    end

    def fetch_data
      @data = Rumble.team(self.slug, self.api_key)
    end

    def set_attribs
      attribs = {
        'rumble_id' => @data['team']['id'],
        'name' => @data['team']['name']
      }
      return false if attribs.values.any? { |v| v.nil? }
      attribs.merge!({
        'app_name' => @data['team']['entry']['name'],
        'app_description' => @data['team']['entry']['description'],
        'app_url' => @data['team']['entry']['direct_url']
      })
      self.attributes = attribs
      true
    end

    def create_members_and_find_users
      if (members = @data['team']['members'])
        members.each do |hash|
          Member.create do |member|
            member.nickname = hash['nickname']
            member.team = self
          end
        end
      end

      users = User.all(:conditions => { :team_rumble_id => self.rumble_id })
      users.each do |user|
        user.update_attribute(:team_id, self.id)
      end
    end

    def set_dull
      self.unwrap   if self.status == 'shiny'
    end
end
