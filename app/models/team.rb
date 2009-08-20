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

  before_save :set_attribs
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
        fetch_data
        if self.data.nil?
          self.errors.add(:slug, "is invalid")
        end
      end
    end

    def fetch_data
      @data ||= Rumble.team(self.slug, self.api_key)
    end

    def set_attribs
      self.rumble_id = @data['team']['id']
      self.name = @data['team']['name']
      self.app_name = @data['team']['entry']['name']
      self.app_description = @data['team']['entry']['description']
      self.app_url = @data['team']['entry']['direct_url']
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
