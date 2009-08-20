class Team < ActiveRecord::Base
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
  has_many :users, :through => :members

  validates_presence_of :slug

  before_validation :fetch_data
  before_save :set_attribs
  before_update :set_dull
  after_create :set_members

  validates_each :slug do |record, attr, value|
    if record.data.nil?
      record.errors.add(attr, 'is invalid')
    end
  end

  private
    def fetch_data
      @data ||= Rumble.team(self.slug)
    end

    def set_attribs
      self.name = @data['team']['name']
      self.app_name = @data['team']['entry']['name']
      self.app_description = @data['team']['entry']['description']
      self.app_url = @data['team']['entry']['direct_url']
    end

    def set_members
      if (members = @data['team']['members'])
        members.each do |hash|
          Member.create do |member|
            member.nickname = hash['nickname']
            member.team = self
          end
        end
      end
    end

    def set_dull
      self.unwrap   if self.status == 'shiny'
    end
end
